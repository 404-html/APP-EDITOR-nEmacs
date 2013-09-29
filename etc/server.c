/* Communication subprocess for GNU Emacs acting as server.
   Copyright (C) 1986, 1987 Free Software Foundation, Inc.

This file is part of GNU Emacs.

GNU Emacs is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU Emacs is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */


/* The GNU Emacs edit server process is run as a subprocess of Emacs
   under control of the file lisp/server.el.
   This program accepts communication from client (program emacsclient.c)
   and passes their commands (consisting of keyboard characters)
   up to the Emacs which then executes them.  */

/* This must precede sys/signal.h on certain machines.  */
#include <sys/types.h>
/* This must precede config.h on certain machines.  */
#include <sys/signal.h>

#define NO_SHORTNAMES
#include "../src/config.h"
#undef read
#undef write
#undef open
#undef close

#if defined (OS2)

#include <stdio.h>
#include <process.h>
#include <os2.h>

static void error (ULONG rc, const char *fun)
{
  (void)fprintf (stderr, "%s failed, rc=%lu\n", fun, rc);
  exit (1);
}

#define ERROR(fun) if (rc != 0) error (rc, fun)

int main (int argc, char *argv[])
{
  HQUEUE hq_server, hq_client;
  ULONG rc, len;
  PID owner_pid;
  PVOID data;
  REQUESTDATA request;
  BYTE priority;
  char buffer[1024], name[512], *p;
  long client_pid;

  if (argc == 1)
    {
      if (spawnl (P_NOWAIT, argv[0], argv[0], "-r", NULL) < 0)
	  {
	  perror ("spawn");
	  return (1);
	  }
      for (;;)
	{
	  if (fgets (buffer, sizeof (buffer), stdin) == 0)
	    return (0);
	  p = buffer;
	  while (*p != 0 && !(*p >= '0' && *p <= '9'))
	    ++p;
	  client_pid = strtol (p, NULL, 10);
	  (void)sprintf (name, "/queues/emacs/clients/%ld", client_pid);
	  rc = DosOpenQueue (&owner_pid, &hq_client, name);
	  if (rc == 0)
	    {
	      len = strlen (buffer) + 1;
	      rc = DosAllocSharedMem (&data, 0, len,
				      PAG_COMMIT | OBJ_GIVEABLE | PAG_READ
				      | PAG_WRITE);
	      ERROR ("DosAllocSharedMem");
	      rc = DosGiveSharedMem (data, client_pid, PAG_READ);
	      ERROR ("DosGiveSharedMem");
	      (void)memcpy (data, buffer, len);
	      rc = DosWriteQueue (hq_client, 0, len, data, 0);
	      ERROR ("DosWriteQueue");
	      rc = DosFreeMem (data);
	      ERROR ("DosFreeMem");
	      rc = DosCloseQueue (hq_client);
	      ERROR ("DosCloseQueue");
	    }
	}
    }
  else if (argc == 2 && strcmp (argv[1], "-r") == 0)
    {
      rc = DosCreateQueue (&hq_server, QUE_FIFO | QUE_CONVERT_ADDRESS,
			   "/queues/emacs/server");
      ERROR ("DosCreateQueue");
      for (;;)
	{
	  rc = DosReadQueue (hq_server, &request, &len, &data, 0,
			     DCWW_WAIT, &priority, 0);
	  ERROR ("DosReadQueue");
	  (void)printf ("Client: %d ", (int)request.pid);
	  (void)fputs (data, stdout);
	  (void)fflush (stdout);
	  rc = DosFreeMem (data);
	  ERROR ("DosFreeMem");
	}
    }
  else
    {
      (void)fprintf (stderr, "Usage: %s\n", argv[0]);
      return (1);
    }
}

#else

#if !defined(HAVE_SOCKETS) && !defined(HAVE_SYSVIPC)
#include <stdio.h>

main ()
{
  fprintf (stderr, "Sorry, the Emacs server is supported only on Berkeley Unix\n");
  fprintf (stderr, "or System V systems with IPC\n");
  exit (1);
}

#else /* BSD or HAVE_SYSVIPC */

#if defined (HAVE_SOCKETS) && ! defined (HAVE_SYSVIPC)
/* BSD code is very different from SYSV IPC code */

#include <sys/file.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>
#include <errno.h>

extern int errno;

main ()
{
  char system_name[32];
  int s, infd, fromlen;
  struct sockaddr_un server, fromunix;
  char *homedir;
  char *str, string[BUFSIZ], code[BUFSIZ];
  FILE *infile;
  FILE **openfiles;
  int openfiles_size;

  char *getenv ();

  openfiles_size = 20;
  openfiles = (FILE **) malloc (openfiles_size * sizeof (FILE *));
  if (openfiles == 0)
    abort ();

  /* 
   * Open up an AF_UNIX socket in this person's home directory
   */

  if ((s = socket (AF_UNIX, SOCK_STREAM, 0)) < 0)
    {
      perror ("socket");
      exit (1);
    }
  server.sun_family = AF_UNIX;
#ifndef SERVER_HOME_DIR
  gethostname (system_name, sizeof (system_name));
  sprintf (server.sun_path, "/tmp/esrv%d-%s", geteuid (), system_name);

  if (unlink (server.sun_path) == -1 && errno != ENOENT)
    {
      perror ("unlink");
      exit (1);
    }
#else  
  if ((homedir = getenv ("HOME")) == NULL)
    {
      fprintf (stderr,"No home directory\n");
      exit (1);
    }
  strcpy (server.sun_path, homedir);
  strcat (server.sun_path, "/.emacs_server");
  /* Delete anyone else's old server.  */
  unlink (server.sun_path);
#endif

  if (bind (s, &server, strlen (server.sun_path) + 2) < 0)
    {
      perror ("bind");
      exit (1);
    }
  /*
   * Now, just wait for everything to come in..
   */
  if (listen (s, 5) < 0)
    {
      perror ("listen");
      exit (1);
    }

  /* Disable sigpipes in case luser kills client... */
  signal (SIGPIPE, SIG_IGN);
  for (;;)
    {
      int rmask = (1 << s) + 1;
      if (select (s + 1, &rmask, 0, 0, 0) < 0)
	perror ("select");
      if (rmask & (1 << s))	/* client sends list of filenames */
	{
	  fromlen = sizeof (fromunix);
	  fromunix.sun_family = AF_UNIX;
	  infd = accept (s, &fromunix, &fromlen); /* open socket fd */
	  if (infd < 0)
	    {
	      if (errno == EMFILE || errno == ENFILE)
		printf ("Too many clients.\n");
	      else
		perror ("accept");
	      continue;
	    }

	  if (infd >= openfiles_size)
	    {
	      openfiles_size *= 2;
	      openfiles = (FILE **) realloc (openfiles,
					     openfiles_size * sizeof (FILE *));
	      if (openfiles == 0)
		abort ();
	    }

	  infile = fdopen (infd, "r+"); /* open stream */
	  if (infile == NULL)
	    {
	      printf ("Too many clients.\n");
	      write (infd, "Too many clients.\n", 18);
	      close (infd);		/* Prevent descriptor leak.. */
	      continue;
	    }
	  str = fgets (string, BUFSIZ, infile);
	  if (str == NULL)
	    {
	      perror ("fgets");
	      close (infd);		/* Prevent descriptor leak.. */
	      continue;
	    }
	  openfiles[infd] = infile;
	  printf ("Client: %d %s", infd, string);
	  /* If what we read did not end in a newline,
	     it means there is more.  Keep reading from the socket
	     and outputting to Emacs, until we get the newline.  */
	  while (string[strlen (string) - 1] != '\n')
	    {
	      if (fgets (string, BUFSIZ, infile) == 0)
		break;
	      printf ("%s", string);
	    }
	  fflush (stdout);
	  fflush (infile);
	  continue;
	}
      else if (rmask & 1) /* emacs sends codeword, fd, and string message */
	{
	  /* Read command codeword and fd */
	  clearerr (stdin);
	  scanf ("%s %d%*c", code, &infd);
	  if (ferror (stdin) || feof (stdin))
	    {
	      fprintf (stderr, "server: error reading from standard input\n");
	      exit (1);
	    }

	  /* Transfer text from Emacs to the client, up to a newline.  */
	  infile = openfiles[infd];
	  while (1)
	    {
	      if (fgets (string, BUFSIZ, stdin) == 0)
		break;
	      fprintf (infile, "%s", string);
	      if (string[strlen (string) - 1] == '\n')
		break;
	    }
	  fflush (infile);

	  /* If command is close, close connection to client.  */
	  if (strncmp (code, "Close:", 6) == 0) 
	    if (infd > 2) 
	      {
		fclose (infile);
		close (infd);
	      }
	  continue;
	} 
    }
}

#else  /* This is the SYSV IPC section */

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <setjmp.h>

jmp_buf msgenv;

void /* void here fixes bug on sgi.
	Let's hope this doesn't break other systems.  */
msgcatch ()
{
  longjmp (msgenv, 1);
}


/* "THIS has to be fixed.  Remember, stderr may not exist...-rlk."
   Incorrect.  This program runs as an inferior of Emacs.
   Its stderr always exists--rms.  */
#include <stdio.h>

main ()
{
  int s, infd, fromlen;
  key_t key;
  struct msgbuf * msgp =
    (struct msgbuf *) malloc (sizeof *msgp + BUFSIZ);
  struct msqid_ds msg_st;
  int p;
  char *homedir, *getenv ();
  char string[BUFSIZ];
  FILE *infile;

  /*
   * Create a message queue using ~/.emacs_server as the path for ftok
   */
  if ((homedir = getenv ("HOME")) == NULL)
    {
      fprintf (stderr,"No home directory\n");
      exit (1);
    }
  strcpy (string, homedir);
  strcat (string, "/.emacs_server");
  creat (string, 0600);
  key = ftok (string, 1);	/* unlikely to be anyone else using it */
  s = msgget (key, 0600 | IPC_CREAT);
  if (s == -1)
    {
      perror ("msgget");
      exit (1);
    }

  /* Fork so we can close connection even if parent dies */
  p = fork ();
  if (setjmp (msgenv))
    {
      msgctl (s, IPC_RMID, 0);
      kill (p, SIGKILL);
      exit (0);
    }
  signal (SIGTERM, msgcatch);
  signal (SIGINT, msgcatch);
  /* If parent goes away, remove message box and exit */
  if (p == 0)
    {
      p = getppid ();
      setpgrp ();		/* Gnu kills process group on exit */
      while (1)
	{
	  if (kill (p, 0) < 0)
	    {
	      msgctl (s, IPC_RMID, 0);
	      exit (0);
	    }
	  sleep (10);
	}
    }

  while (1)
    {
      if ((fromlen = msgrcv (s, msgp, BUFSIZ - 1, 1, 0)) < 0)
        {
	  perror ("msgrcv");
	  exit (1);
        }
      else
        {
	  msgctl (s, IPC_STAT, &msg_st);
	  strncpy (string, msgp->mtext, fromlen);
	  string[fromlen] = 0;	/* make sure */
	  /* Newline is part of string.. */
	  printf ("Client: %d %s", s, string); 
	  fflush (stdout);
	  /* Now, wait for a wakeup */
	  fgets (msgp->mtext, BUFSIZ, stdin);
	  msgp->mtext[strlen (msgp->mtext)-1] = 0;
	  /*	  strcpy (msgp->mtext, "done");*/
	  msgp->mtype = msg_st.msg_lspid;
	  msgsnd (s, msgp, strlen (msgp->mtext)+1, 0);
	}
    }
}

#endif /* SYSV IPC */

#endif /* BSD && IPC */

#endif /* OS2 */

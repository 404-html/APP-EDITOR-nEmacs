/* OS/2 specific functions for GNU Emacs for OS/2
   Copyright (C) 1992 Free Software Foundation, Inc.

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


#include <signal.h>
#include "lisp.h"



/* Look at ctrl-break-action for explanation. */
int Vctrl_break_action;


void ctrl_break_signal()
{

  signal(SIGBREAK, SIG_ACK);

  switch (Vctrl_break_action)
    {
    case 0:
      break;
      
    case 1:
      Vquit_flag = Qt;
      raise(SIGINT);
      break;

    case 2:
      exit(1); break;

    case 3:
      abort(); break;

    default:
      break;
      
    }
  
}


syms_of_os2()
{
  
  DEFVAR_INT("ctrl-break-action", &Vctrl_break_action,
     "Determines the behavior of Emacs after Ctrl-Break has been pressed.\n\
Available only under OS/2.\n\
0 : Do nothing, just return C-@.\n\
1 : Like C-g C-g, termination with request.\n\
2 : Terminate program immediatly without request.\n\
3 : Force an abnormal program termination (dump core) without request.\n\
The default value is 1.
It is strongly recommended not to use a value of 2 or higher
since you may loose data after hitting Ctrl-Break !");
  Vctrl_break_action = 1;

}

     

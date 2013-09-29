/*      Sj3serv Interface for Nemacs
        Coded by Yutaka Ishikawa at ETL (yisikawa@etl.go.jp)
                 Satoru Tomura   at ETL (tomura@etl.go.jp)
		 Kiyoji Ishii	 at SONY (kiyoji@sm.sony.co.jp)


   This file is part of Egg on Nemacs (Japanese environment)

   Egg is distributed in the forms of patches to GNU
   Emacs under the terms of the GNU EMACS GENERAL PUBLIC
   LICENSE which is distributed along with GNU Emacs by the
   Free Software Foundation.

   Egg is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied
   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
   PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
   more details.

   You should have received a copy of the GNU EMACS GENERAL
   PUBLIC LICENSE along with Nemacs; see the file COPYING.
   If not, write to the Free Software Foundation, 675 Mass
   Ave, Cambridge, MA 02139, USA. */

/*
 *      CHANGE LOG
 *
 *	1991.07.16 Kanji conversion function is changed by K.Ishii
 *	1991.01.22 sj3-server-henkan-end and sj3-server-henkan-next
 *		   are changed by K.Ishii
 *	1991.01.14 a bug fixed by K.Ishii
 *	1991.01.07 sj3-server-henkan-next is changed by K.Ishii
 *	1990.12.26 modified for sj3serv by K.Ishii
 *      1989.12.12 in makeBunsetsu and makeKouho, call wcstrlen2 by K.Handa
 *      1989.12.12 bitPos modified and renamed to bunpoCode
 *      1989.12.06 a bug fixed by S.T.
 *      1989.11.25 wnn-server-*evf added by S.T.
 *      1989.11.21 jserver-* are renamed to wnn-* by S.T.
 *      1988.11.17 jserver-inspect-henkan is added by S.T.
 *      1988.11.17 jserver-make-directory is added by S.T.
 *      1988.11.08 jserver-dict-save is added: save current dictionary and
 *                 frequency information of system dictionaries by S.T. 
 *      1988.11.08 jserver-open: when jserver-host-name is nil, 
 *                 it means local host by S.T.
 *	1988.07.14 Enable to add alphabetical "yomi" into a dictionary by Y.I.
 *	1988.07.14 Bug for vax is fixed by atarashi@cslv4.nec.junet.
 *	-----------------------------------------------------------------------
 *	1988.06.09
 *	1988.01.26
 *	1988.01.12
 *	-----------------------------------------------------------------------
 *
 *	Functions defined in this file are
 *	   (sj3-server-open sj3-host-name login-name)
 *		sj3-host-name: STRING or NIL
 *		login-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		You must call this function before using sj3serv.
 *
 *	   (sj3-server-close)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		You should call this function when you stop using sj3serv.
 *		If you have not called it and are going to exit emacs,
 *		sj3-server-close is automatically invoked.
 *
 *	   (sj3-server-open-dict dict-file-name file-passwd)
 *		dict-file-name: STRING
 *		file-passwd: STRING
 *		DESCRIPTION:
 *		After calling the sj3-server-open, you must assert dictionaries
 *		which you use in sj3serv.
 *		Dictionary files are devided into two categories:
 *		system and user. System dictionary files are read-only while
 *		user dictionary files are writable.
 *
 *	   (sj3-server-close-dict dict-no)
 *		dict-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-make-dict dict-file-name)
 *		dict-file-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *         (sj3-server-open-stdy study-file-name)
 *		study-file-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-close-stdy)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-make-stdy study-file-name)
 *		study-file-name: STRING
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-lock-dict)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-unlock-dict)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-henkan-begin henkan-string)
 *		henkan-string: STRING
 *		RETURNS: a LIST of pairs of bunsetu-kanji and bunsetu-yomi.
 *		DESCRIPTION:
 *		This function is called if you want to change Kana-string to
 *		Kanji-string. The Kana-string must be filled in henkan-string.
 *
 *	   (sj3-server-henkan-next bunsetu-no )
 *		bunsetu-no: INTEGER
 *		RETURNS: a LIST of pairs of bunsetu-kanji and bunsetu-yomi.
 *		DESCRIPTION:
 *		return candidates for bunsetsu pointed by bunsetsu-no.
 *
 *	   (sj3-server-henkan-kakutei bunsetsu-no kouho-no)
 *		bunsetsu-no: INTEGER
 *		kouho-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *		word pointed by kouho-no is chosen for bunsetsu pointed by
 *		bunsetsu-no.
 *
 *	   (sj3-server-bunsetu-henkou bunsetu-no bunsetu-length)
 *		bunsetu-no: INTEGER
 *		bunsetu-length: INTEGER
 *		RETURNS:
 *		DESCRIPTION:
 *		bunsetsu is changed.
 *
 *	   (sj3-server-henkan-quit)
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *	
 *	   (sj3-server-henkan-end &optional bunsetu-no)
 *              bunsetu-no: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-dict-add dic-no tango yomi bunpo-type)
 *		dict-no: INTEGER
 *		tango: STRING
 *		yomi: STRING
 *		bunpo-type: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-dict-delete dic-no tango yomi bunpo-type)
 *		dict-no: INTEGER
 *		tango: STRING
 *		yomi: STRING
 *		bunpo-type: INTEGER
 *		RETURNS: BOOLEAN
 *		DESCRIPTION:
 *
 *	   (sj3-server-dict-info yomi)
 *		yomi: STRING
 *		RETURNS: a LIST of dict-joho
 *		DESCRIPTION:
 *
 *	   (sj3-server-file-access file-name file-mode)
 *		file-name: STRING
 *		file-mode: INTEGER
 *		RETURNS: INTEGER
 *		DESCRIPTION:
 *
 *         (sj3-server-make-directory pathname)
 *              pathname: STRING
 *              RETURNS: BOOLEAN
 *              DESCRIPTION:
 *
 */

#include "config.h"
#include <setjmp.h>
#include <ctype.h>
#include "sj3lib.h"

#ifdef NULL
#undef NULL
#endif NULL
#include "lisp.h"
#include "buffer.h"
#include "window.h"
#include "kanji.h"

#define	DOUON_BUF_SIZE		256
#define	MAX_BUNSETSU_SUU	50
#define MAX_OPEN_DICT		16
#define WORD_SIZE		64

#define	DEFIDXLEN		2048
#define	DEFSEGLEN		2048
#define	DEFSEGNUM		256
#define	DEFSTYNUM		2048
#define	DEFCLSTEP		1
#define	DEFCLLEN		2048

/* Communication error code */
#define SJ3_SJ3SERV_DEAD	1
#define SJ3_SOCK_OPEN_FAIL	2
#define SJ3_ALLOC_FAIL		6
#define	SJ3_BAD_HOST		12
#define SJ3_BAD_USER		13
#define	SJ3_NOT_A_DICT		31
#define SJ3_NO_EXIST		35
#define	SJ3_OPEN_ERR		37
#define	SJ3_PARAMR		39
#define SJ3_PARAMW		40
#define	SJ3_NOT_A_USERDICT	71
#define	SJ3_RONLY_DICT		72
#define	SJ3_BAD_YOMI		74
#define	SJ3_BAD_KANJI		75
#define SJ3_BAD_HINSHI		76
#define	SJ3_WORD_ALREADY_EXIST	82
#define	SJ3_JISHOTABLE_FULL	84
#define	SJ3_WORD_NO_EXIST	92
#define SJ3_MKDIR_FAIL		102

/*
 *	client structure
 */
typedef	struct sj3_client_env {
	int		fd;			/* file descriptor */
	int		serv_dead_flg;
	jmp_buf		serv_dead;
	int		stdy_size;		/* size of study ID */
} SJ3_CLIENT_ENV;

typedef struct SJ3_BJOHO {
	int		ent;
	int		skouho;
	int		srclen;
	int		destlen;
	u_char		*srcstr;
	u_char		*deststr;
	struct studyrec	dcid;
} SJ3_BJOHO;

typedef struct SJ3_YJOHO {
	int		srclen;
	u_char		*srcstr;
} SJ3_YJOHO;

typedef struct SJ3_DJOHO {
	int		dictno;
	int		bunpo;
	SJ3_DOUON	*dop;
} SJ3_DJOHO;

typedef struct SJ3_DICNO {
	int		type;		/* 0:sysdic 1:userdic */
	int		dictno;
} SJ3_DICNO;

static SJ3_CLIENT_ENV	client;
static int		bunsetsuNo;
static int		dictcnt;
static SJ3_DICNO	diclist[MAX_OPEN_DICT];

static SJ3_BJOHO	bjoho[MAX_BUNSETSU_SUU];
static SJ3_YJOHO	yjoho[MAX_BUNSETSU_SUU];
static u_char 		yomibuf[SJ3_IKKATU_YOMI];
static u_char		kanjibuf[SJ3_IKKATU_YOMI * 2];
static u_char		commbuf[SJ3_IKKATU_YOMI * 2];

extern int 		sj3_error_number;

Lisp_Object	makeBunsetsu();
Lisp_Object	makeJishoJoho();
Lisp_Object	makekatastr();
Lisp_Object	make_eucstr();

/* Lisp Variables and Constants Definition */
Lisp_Object	Vsj3_error_code;
Lisp_Object	Qsj3_dead;
Lisp_Object	Qsj3_already_exist;
Lisp_Object	Qsj3_no_connection;
Lisp_Object	Qsj3_arguments_missmatch;
Lisp_Object	Qsj3_alloc_fail;
Lisp_Object	Qsj3_open_fail;
Lisp_Object	Qsj3_close_fail;
Lisp_Object	Qsj3_too_many_bunsetsu;
Lisp_Object	Qsj3_not_a_dict;
Lisp_Object	Qsj3_no_exist_file;
Lisp_Object	Qsj3_full_jisho_table;
Lisp_Object	Qsj3_cannot_read_file;
Lisp_Object	Qsj3_cannot_write_file;
Lisp_Object	Qsj3_cannot_open_file;
Lisp_Object	Qsj3_no_more_open_dict;
Lisp_Object	Qsj3_read_only_dict;
Lisp_Object	Qsj3_not_userdict;
Lisp_Object	Qsj3_too_many_moji;
Lisp_Object	Qsj3_too_long_yomi;
Lisp_Object	Qsj3_too_long_kanji;
Lisp_Object	Qsj3_bad_yomi;
Lisp_Object	Qsj3_bad_kanji;
Lisp_Object	Qsj3_bad_hinshi;
Lisp_Object	Qsj3_already_exist_word;
Lisp_Object	Qsj3_not_exist_word;
Lisp_Object	Qsj3_cannot_mkdir;
Lisp_Object	Qsj3_not_a_username;
Lisp_Object	Qsj3_not_a_hostname;
Lisp_Object	Qsj3_unknown_fail;

/* Lisp functions definition */
DEFUN ("sj3-server-open", Fsj3_open, Ssj3_open, 2, 2, 0,
	"For Sj3.")
	(hname, lname)
register Lisp_Object hname, lname;
{
	char tmp[32];

	if ((hname != Qnil  &&  XTYPE (hname) != Lisp_String) ||
	     XTYPE(lname) != Lisp_String){
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd != -1) {
		Vsj3_error_code = Qsj3_already_exist;
		return Qnil;
	}
	sprintf(tmp, "%d.sj3_egg", getpid());
        if (hname == Qnil) {
		if (sj3_make_connection(&client, "", 
				XSTRING(lname)->data, tmp) < 0) {
			errorSet();
			client.fd = -1;
			return Qnil;
		}
	} else {
		if (sj3_make_connection(&client, XSTRING(hname)->data, 
			      XSTRING(lname)->data, tmp) < 0) {
			errorSet();
			client.fd = -1;
			return Qnil;
		}
	}
	if (client.stdy_size > SJ3_WORD_ID_SIZE) {
		sj3_erase_connection(&client);
		Vsj3_error_code = Qsj3_open_fail;
		return Qnil;
	}
	dictcnt = 0;
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-close", Fsj3_close, Ssj3_close, 0, 0, 0,
	"For Sj3.")
	()
{
	if (sj3_exit() < 0)
		return Qnil;
	else
		return Qt;
}

DEFUN ("sj3-server-open-dict", Fsj3_open_dict, Ssj3_open_dict, 1, 2, 0,
	"For Sj3.")
	(dfname, passwd)
register Lisp_Object dfname, passwd;
{
	Lisp_Object	val;
	SJ3_DICNO	*dnop;
	int		v;

	if (XTYPE (dfname) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if (dictcnt >= MAX_OPEN_DICT) {
		Vsj3_error_code = Qsj3_no_more_open_dict;
		return Qnil;
	}

	dnop = &diclist[dictcnt];
	if (passwd == Qnil) {
		dnop->type = 0;
		v = sj3_open_dictionary(&client, XSTRING(dfname)->data, 0); 
	} else {
		dnop->type = 1;
		v = sj3_open_dictionary(&client, XSTRING(dfname)->data, 
					XSTRING(passwd)->data);
	}
	if (v == 0) {
		errorSet();
		return Qnil;
	}
	dnop->dictno = v;
	dictcnt++;
	XSETTYPE (val, Lisp_Int);
	XFASTINT (val) = v;
	Vsj3_error_code = Qnil;
	return val;
}

DEFUN ("sj3-server-close-dict", Fsj3_close_dict, Ssj3_close_dict, 1, 1, 0,
	"For Sj3.")
	(dno)
register Lisp_Object dno;
{
	register int 	i, no;
	SJ3_DICNO	*dnop;

	if (XTYPE (dno) != Lisp_Int || (no = XINT(dno)) == 0) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	dnop = diclist;
	for (i = 0; i < dictcnt; i++) {
		if (no == dnop->dictno) {
			dnop->dictno = 0;
			break;
		}
		dnop++;
	}
	if ( i >= dictcnt) {
		Vsj3_error_code = Qsj3_not_a_dict;
		return Qnil;
	}
	if (close_dict(dno) != 0)
		return Qnil;
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-make-dict", Fsj3_make_dict, Ssj3_make_dict, 1, 1, 0,
	"For Sj3.")
	(dfname)
register Lisp_Object dfname;
{
	if (XTYPE (dfname) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if (sj3_make_dict_file(&client, XSTRING(dfname)->data, 
				DEFIDXLEN, DEFSEGLEN, DEFSEGNUM) < 0) {
		errorSet();
		return Qnil;
	}
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-open-stdy", Fsj3_open_stdy, Ssj3_open_stdy, 1, 1, 0,
	"For Sj3.")
	(sfname)
register Lisp_Object sfname;
{
	if (XTYPE (sfname) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if  (sj3_open_study_file(&client, XSTRING(sfname)->data, "") < 0) {
		errorSet();
		return Qnil;
	}
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-close-stdy", Fsj3_close_stdy, Ssj3_close_stdy, 0, 0, 0,
	"For Sj3.")
	()
{
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if  (close_stdy() != 0) 
		return Qnil;
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-make-stdy", Fsj3_make_stdy, Ssj3_make_stdy, 1, 1, 0,
	"For Sj3.")
	(sfname)
register Lisp_Object sfname;
{
	if (XTYPE (sfname) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if (sj3_make_study_file(&client, XSTRING(sfname)->data,
				DEFSTYNUM, DEFCLSTEP, DEFCLLEN) < 0) {
		errorSet();
		return Qnil;
	}
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-lock-dict", Fsj3_lock_dict, Ssj3_lock_dict, 0, 0, 0,
	"For Sj3.")
	()
{
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if  (sj3_lock_server(&client) < 0) {
		errorSet();
		return Qnil;
	}
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-unlock-dict", Fsj3_unlock_dict, Ssj3_unlock_dict, 0, 0, 0,
	"For Sj3.")
	()
{
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if  (sj3_unlock_server(&client) < 0) {
		errorSet();
		return Qnil;
	}
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-henkan-begin", Fsj3_begin_henkan, Ssj3_begin_henkan, 
       1, 1, 0,
	"For Sj3.")
	(hstring)
register Lisp_Object hstring;
{
	register int		i, len, ksize;
	register u_char		*yp, *kp, *cp;
	Lisp_Object 		val;
	SJ3_BJOHO		*bjp;

	bunsetsuNo = 0;
	if (XTYPE (hstring) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}

	if ((len = strlen(XSTRING(hstring)->data)) > SJ3_IKKATU_YOMI) {
		Vsj3_error_code = Qsj3_too_many_moji;
		return Qnil;
	}
	len = e2s(len, XSTRING(hstring)->data, yomibuf);
	yomibuf[len] = '\0';
	yp = yomibuf;
	kp = kanjibuf;
	ksize = SJ3_IKKATU_YOMI * 2;
	bjp = bjoho;
	while (*yp) {
		cp = commbuf;
		if((len = sj3_ikkatu_henkan(&client, yp, cp, ksize)) < 0) {
			errorSet();
			return Qnil;
		} else if (len == 0) {
			bjp->srclen = strlen(yp);
			bjp->srcstr = yp;
			bjp->destlen = bjp->srclen;
			strcpy(kp, yp);
			bjp->deststr = kp;
			yp += bjp->srclen;
			kp += bjp->destlen;
			bunsetsuNo++;
			break;
		}
		while (*cp) {
			bjp->srclen = *cp++;
			cp += client.stdy_size;
			bjp->destlen = strlen(cp);
			bjp->srcstr = yp;
			bjp->deststr = kp;
			while (*cp) 
				*kp++ = *cp++;
			ksize -= bjp->destlen;
			cp++;
			yp += bjp->srclen;
			bjp++;
			/* Too many bunsetsu */
			if(++bunsetsuNo >= MAX_BUNSETSU_SUU - 1) {
				Vsj3_error_code = Qsj3_too_many_bunsetsu;
				return Qnil;
			}
		}
		*kp = '\0';
	}
	
	val = Qnil;
	for(i = bunsetsuNo - 1; i >= 0; i--) {
		bjoho[i].ent = -1;
		bjoho[i].skouho = 0;
		bzero(&(bjoho[i].dcid), sizeof(bjoho[i].dcid));
		yjoho[i].srclen = bjoho[i].srclen;
		yjoho[i].srcstr = bjoho[i].srcstr;
		val = Fcons(makeBunsetsu(&bjoho[i]), val);
	}
	
	bjoho[bunsetsuNo].ent = -1;
	bjoho[bunsetsuNo].skouho = 0;
	bjoho[bunsetsuNo].destlen = 0;
	bjoho[bunsetsuNo].deststr = kp;
	bjoho[bunsetsuNo].srclen = 0;
	bjoho[bunsetsuNo].srcstr = yp;
	yjoho[bunsetsuNo].srclen = 0;
	yjoho[bunsetsuNo].srcstr = yp;
	Vsj3_error_code = Qnil;
	return val;
}

DEFUN ("sj3-server-henkan-next", Fsj3_jikouho, Ssj3_jikouho, 1, 1, 0,
	"For Sj3.")
	(bunNo)
register Lisp_Object bunNo;
{
	Lisp_Object	val;
	register int 	kouho;
	int		no;
	SJ3_BJOHO	*bjp;
	SJ3_DOUON	douon[DOUON_BUF_SIZE];

	if( XTYPE(bunNo) != Lisp_Int ||
	   (no =  XINT(bunNo)) < 0 || no >= bunsetsuNo) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	val = Qnil;
	Vsj3_error_code = Qnil;
	bjp = &bjoho[no];
	val = Fcons(make_eucstr(bjp->srcstr, bjp->srclen), val);
	val = Fcons(makekatastr(bjp->srcstr, bjp->srclen), val);

	if (bjp->srclen > SJ3_BUNSETU_YOMI || bjp->ent == 0)
		return val;

	kouho = sj3_bunsetu_kouhosuu(&client, bjp->srcstr, bjp->srclen);
	if (kouho < 0) {
		errorSet();
		return Qnil;
	} 
	bjp->ent = kouho;
	if (kouho > 0) {
		if (sj3_bunsetu_zenkouho(&client, bjp->srcstr, bjp->srclen,
								douon) < 0) {
			errorSet();
			return Qnil;
		}
	}
	if (kouho > 0) {
		 if (strncmp(douon[0].ddata,bjp->deststr,bjp->destlen) != 0) {
			while (kouho) {
				kouho--;
				if (strncmp(douon[kouho].ddata, bjp->deststr,
							   bjp->destlen) == 0) {
					bjp->skouho = kouho;
					break;
				}
				val = Fcons(make_eucstr(douon[kouho].ddata,
							douon[kouho].dlen),val);
			}
			while (kouho) {
				kouho--;
				val = Fcons(make_eucstr(douon[kouho].ddata,
						douon[kouho].dlen), val);
			}
			val = Fcons(make_eucstr(bjp->deststr,bjp->destlen),val);
		} else {
			while (kouho) {
				kouho--;
				val = Fcons(make_eucstr(douon[kouho].ddata,
						douon[kouho].dlen), val);
			}
		}
	}
	return val;
}

DEFUN ("sj3-server-henkan-kakutei", Fsj3_kakutei, Ssj3_kakutei, 2, 2, 0,
	"For Sj3.")
	(bunNo, kouhoNo)
register Lisp_Object bunNo, kouhoNo;
{
	int		bno, kno;
	SJ3_DOUON	douon[DOUON_BUF_SIZE];

	if (XTYPE(bunNo) != Lisp_Int || XTYPE(kouhoNo) != Lisp_Int ) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}

	bno = XINT(bunNo);
	kno = XINT(kouhoNo);
	if (bno < 0 || bno >= bunsetsuNo || kno < 0 || 
	   (kno > 0 && (bjoho[bno].ent == -1 || kno - 2 >= bjoho[bno].ent))) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (bjoho[bno].ent > 0 && kno > 0 && kno < bjoho[bno].ent) {
		if (sj3_bunsetu_zenkouho(&client, bjoho[bno].srcstr,
					 bjoho[bno].srclen, douon) < 0) {
			errorSet();
			return Qnil;
		}
		if (kno <= bjoho[bno].skouho)
			kno--;
		if (sj3_tango_gakusyuu(&client, &(douon[kno].dcid)) < 0) {
			errorSet();
			return Qnil;
		}
	}
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-bunsetu-henkou", Fsj3_bunsetu_henkou, Ssj3_bunsetu_henkou,
       2, 2, 0,
	"For Sj3.")
	(bunNo, len)
register Lisp_Object bunNo, len;
{
	Lisp_Object	val;
	register int	i, no, next;
	register u_char	*p;
	char		kbuf[SJ3_IKKATU_YOMI * 2];
	int		ylen, olen, rlen, kouho1, kouho2;
	SJ3_BJOHO	*bjp, *nbjp;

	if(XTYPE(bunNo) != Lisp_Int || XTYPE(len) != Lisp_Int ||
	   (no =  XINT(bunNo)) < 0 || no >= bunsetsuNo) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	bjp = &bjoho[no];
	ylen = getwlen(bjp->srcstr, XINT(len));
	olen = bjp->srclen;
	rlen = changeBjoho(no, ylen);
	if (ylen > SJ3_BUNSETU_YOMI) {
		kouho1 = 0;
	} else {
		kouho1 = sj3_bunsetu_kouhosuu(&client, bjp->srcstr, ylen);
		if (kouho1 < 0) {
			errorSet();
			return Qnil;
		}
	}
	next = no + 1;
	if (rlen > 0) {
		nbjp = &bjoho[next];
		kouho2 = sj3_bunsetu_kouhosuu(&client, nbjp->srcstr, 
						       nbjp->srclen);
		if (kouho2 < 0) {
			errorSet();
			return Qnil;
		}
		if (ylen < olen && kouho2 == 0) {
			i = bunsetsuNo;
			bjoho[i + 1].ent = -1;
			bjoho[i + 1].skouho = 0;
			bjoho[i + 1].srclen = 0;
			bjoho[i + 1].srcstr = bjoho[i].srcstr;
			for (; i > next; i--) {
				bjoho[i].ent = bjoho[i - 1].ent;
				bjoho[i].skouho = bjoho[i - 1].skouho;
				bjoho[i].srclen = bjoho[i-1].srclen;
				bjoho[i].srcstr = bjoho[i-1].srcstr;
				bjoho[i].destlen = bjoho[i-1].destlen;
				bjoho[i].deststr = bjoho[i-1].deststr;
				bcopy(&(bjoho[i-1].dcid),
					&(bjoho[i].dcid),client.stdy_size);
			}
			nbjp->srclen = rlen;
			nbjp->destlen = 0;
			bjoho[i+1].srclen -= rlen;
			bjoho[i+1].srcstr += rlen;
			bunsetsuNo++;
			kouho2 = sj3_bunsetu_kouhosuu(&client, nbjp->srcstr, 
							       nbjp->srclen);
			if (kouho2 < 0) {
				errorSet();
				return Qnil;
			}
		}
		next++;
	}
	strcpy(kbuf, bjoho[next].deststr);

	if (makeBjoho(kouho1, bjp) < 0) {
		errorSet();
		return Qnil;
	}
	if (rlen > 0) {
		if (makeBjoho(kouho2, nbjp) < 0) {
			errorSet();
			return Qnil;
		}
	}
	p = bjoho[next].deststr;
	strcpy(p, kbuf);
	for (i = next; i < bunsetsuNo; i++) {
		p += bjoho[i].destlen;
		bjoho[i + 1].deststr = p;
	}
	bjoho[i].destlen = 0;
	val = Qnil;
	for (i = bunsetsuNo - 1; i >= 0; i--)
		val = Fcons(makeBunsetsu(&bjoho[i]), val);
	
	Vsj3_error_code = Qnil;
	return val;
}

DEFUN ("sj3-server-henkan-quit", Fsj3_quit_henkan, Ssj3_quit_henkan, 0, 0, 0,
	"For Sj3.")
	()
{
	Vsj3_error_code = Qnil;
	return Qt;
}

DEFUN ("sj3-server-henkan-end", Fsj3_end_henkan, Ssj3_end_henkan, 0, 1, 0,
	"For Sj3.")
	(bunNo)
Lisp_Object  bunNo;
{
	register int 	i, len;
	int		bno;
	SJ3_BJOHO	*bjp;
	SJ3_YJOHO	*yjp;

	if(XTYPE(bunNo) != Lisp_Int && bunNo != Qnil){
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if (bunNo != Qnil)
		bno = XINT(bunNo);
	else
		bno = bunsetsuNo;
	yjp = yjoho;
	bjp = bjoho;
	Vsj3_error_code = Qnil;
	for (i = 0; i < bno - 1; i++) {
		if (bjp->srcstr == yjp->srcstr && bjp->srclen == yjp->srclen) {
			yjp++;
			bjp++;
			continue;
		}
		bjp++;
		for (;yjp->srcstr < bjp->srcstr;yjp++) ;
		if ((bjp-1)->ent > 0 && bjp->ent > 0) {
			if (sj3_bgakusyuu((bjp-1), bjp) < 0)
				return Qnil;
			len = yjp->srcstr - bjp->srcstr;
			if (len == bjp->srclen || 
				bjp->srclen - yjp->srclen == len) {
				if (len != bjp->srclen && yjp->srclen != 0)
					yjp++;
				bjp++;
				i++;
			}
		}
	}
	if (bjp->srclen != yjp->srclen && bjp->ent > 0) {
		if (sj3_bgakusyuu(bjp, 0) < 0)
			return Qnil;
	}
	return Qt;
}

DEFUN ("sj3-server-dict-add", Fsj3_dict_toroku, Ssj3_dict_toroku, 4, 4, 0,
	"For Sj3.")
	(dno, kanji, yomi, bunpo)
register Lisp_Object dno, kanji, yomi, bunpo;
{
	register int yl, kl;
	u_char ybuf[WORD_SIZE], kbuf[WORD_SIZE];

	if(XTYPE(dno) != Lisp_Int || XTYPE(kanji) != Lisp_String
	  || XTYPE(yomi) != Lisp_String || XTYPE(bunpo) != Lisp_Int) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if ((yl = strlen(XSTRING(yomi)->data)) >= WORD_SIZE) {
		Vsj3_error_code = Qsj3_too_long_yomi;
		return Qnil;
	}
	if ((kl = strlen(XSTRING(kanji)->data)) > WORD_SIZE) {
		Vsj3_error_code = Qsj3_too_long_kanji;
		return Qnil;
	}
	yl = e2s(yl, XSTRING(yomi)->data, ybuf);
	ybuf[yl] = '\0';
	kl = e2s(kl, XSTRING(kanji)->data, kbuf);
	kbuf[kl] = '\0';
	if(sj3_tango_touroku(&client, XINT(dno), ybuf, kbuf, XINT(bunpo)) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vsj3_error_code = Qnil;
		return Qt;
	}
}


DEFUN ("sj3-server-dict-delete", Fsj3_dict_sakujo, Ssj3_dict_sakujo, 4, 4, 0,
	"For Sj3.")
	(dno, kanji, yomi, bunpo)
register Lisp_Object dno, kanji, yomi, bunpo;
{
	register int yl, kl;
	u_char ybuf[WORD_SIZE], kbuf[WORD_SIZE];

	if(XTYPE(dno) != Lisp_Int || XTYPE(kanji) != Lisp_String
	  || XTYPE(yomi) != Lisp_String || XTYPE(bunpo) != Lisp_Int) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}

	if ((yl = strlen(XSTRING(yomi)->data)) >= WORD_SIZE) {
		Vsj3_error_code = Qsj3_too_long_yomi;
		return Qnil;
	}
	if ((kl = strlen(XSTRING(kanji)->data)) > WORD_SIZE) {
		Vsj3_error_code = Qsj3_too_long_kanji;
		return Qnil;
	}
	yl = e2s(yl, XSTRING(yomi)->data, ybuf);
	ybuf[yl] = '\0';
	kl = e2s(kl, XSTRING(kanji)->data, kbuf);
	kbuf[kl] = '\0';
	if(sj3_tango_sakujo(&client, XINT(dno), ybuf, kbuf, XINT(bunpo)) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vsj3_error_code = Qnil;
		return Qt;
	}
}


DEFUN ("sj3-server-dict-info", Fsj3_dict_joho, Ssj3_dict_joho, 1, 1, 0,
	"For Sj3.")
	(yomi)
register Lisp_Object yomi;
{
	register int	yl, i;
	int		count, sysdicno;
	u_char 		ybuf[WORD_SIZE];
	SJ3_DOUON	douon[DOUON_BUF_SIZE];
	SJ3_DJOHO	djoho[DOUON_BUF_SIZE];
	Lisp_Object	val;

	if(XTYPE(yomi) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if ((yl = strlen(XSTRING(yomi)->data)) >= WORD_SIZE) {
		Vsj3_error_code = Qsj3_too_long_yomi;
		return Qnil;
	}
	yl = e2s(yl, XSTRING(yomi)->data, ybuf);
	ybuf[yl] = '\0';
	if ((count = sj3_bunsetu_kouhosuu(&client, ybuf, yl)) < 0) {
		errorSet();
		return Qnil;
	}
	val = Qnil;
	Vsj3_error_code = Qnil;
	if (count > 0) {
		if (sj3_bunsetu_zenkouho(&client, ybuf, yl, douon) < 0) {
			errorSet();
			return Qnil;
		}
		sysdicno = 0;
		for (i = 0; i < dictcnt; i++) {
			if (diclist[i].type == 0) {
				sysdicno = diclist[i].dictno;
				break;
			}
		}
		for (i = 0; i < count; i++) {
			djoho[i].dop = &douon[i];
			djoho[i].dictno = sysdicno;
			djoho[i].bunpo = 190;
		}
		djoho[i].dictno = -1;
		makeDjoho(ybuf, yl, djoho);
		for (count; count > 0; count--) {
			if (djoho[count - 1].dictno <= 0)
				continue;
			val = Fcons(makeJishoJoho(&djoho[count - 1]), val);
		}
	}
	return val;
}


DEFUN ("sj3-server-file-access", Fsj3_file_access, Ssj3_file_access, 2, 2, 0,
	"For Sj3.")
	(fname, fmode)
register Lisp_Object fname, fmode;
{

	if (XTYPE(fname) != Lisp_String || XTYPE(fmode) != Lisp_Int) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
/*
 *	if(sj3_access(&client, XSTRING(fname)->data, XINT(fmode)) < 0) {
 *		errorSet();
 *		return Qnil;
 *	} else {
 *		Vsj3_error_code = Qnil;
 *		return Qt;
 *	}
 */
 	Vsj3_error_code = Qnil;
 	return make_number(sj3_access(&client, XSTRING(fname)->data, 
								XINT(fmode)));
}


DEFUN ("sj3-server-make-directory", Fsj3_make_directory,
         Ssj3_make_directory, 1, 1, 0,
	"For Sj3.")
	(pathname)
register Lisp_Object pathname;
{

	if(XTYPE(pathname) != Lisp_String) {
		Vsj3_error_code = Qsj3_arguments_missmatch;
		return Qnil;
	}
	if (client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return Qnil;
	}
	if(sj3_make_directory(&client, XSTRING(pathname)->data) < 0) {
		errorSet();
		return Qnil;
	} else {
		Vsj3_error_code = Qnil;
		return Qt;
	}
}

Lisp_Object
makeBunsetsu(bjp)
SJ3_BJOHO	*bjp;
{
	Lisp_Object	val1, val2;

	/* make kanji with kana */
	val1 = make_eucstr(bjp->deststr, bjp->destlen);

	/* make kana */
	val2 = make_eucstr(bjp->srcstr, bjp->srclen);
	return Fcons(val1, val2);
}

Lisp_Object
make_eucstr(str, len)
u_char *str;
int len;
{
	register int	i;
	u_char		chbuf[SJ3_IKKATU_YOMI * 2];

	i = s2e(len, str, chbuf);
	return make_string(chbuf, i);
}

Lisp_Object
makekatastr(str, len)
u_char *str;
int len;
{
	register int i;
	u_char	kata[SJ3_IKKATU_YOMI], ch;

	len = s2e(len, str, kata);
	for (i = 0; i < len; i++) {
		if ((ch = kata[i]) >= 0x80) {
			if (ch == 0xa4)
				kata[i] = 0xa5;
			i++;
		}
	}
	return make_string(kata, len);
}

Lisp_Object
makeJishoJoho(djp)
SJ3_DJOHO *djp;
{
	Lisp_Object 	str, bunpo, jisho, val;
	SJ3_DOUON	*dop;

	dop = djp->dop;
	str = make_eucstr(dop->ddata, dop->dlen);
	XFASTINT(bunpo) = djp->bunpo;
	XFASTINT(jisho) = djp->dictno;
	val = Fcons(jisho, Qnil);
	val = Fcons(bunpo, val);
	val = Fcons(str, val);
	return val;
}

changeBjoho(no, len)
int no, len;
{
	register int 	i, j;
	int		rlen;
	SJ3_BJOHO	*bjp, *nbjp;

	bjp = &bjoho[no];
	if (len < bjp->srclen) {
		rlen = bjp->srclen - len;
		nbjp = &bjoho[no+1];
		if (no == bunsetsuNo - 1) {
			bunsetsuNo++;
			(nbjp + 1)->ent = -1;
			(nbjp + 1)->srcstr = nbjp->srcstr;
			(nbjp + 1)->srclen = 0;
			nbjp->destlen = 0;
		}
		nbjp->srclen += rlen;
		nbjp->srcstr -= rlen;
	} else {
		rlen = len - bjp->srclen;
		for (i = no + 1; i < bunsetsuNo; i++) {
			if (rlen < bjoho[i].srclen)
				break;
			rlen -= bjoho[i].srclen;
			bjp->destlen += bjoho[i].destlen;
		}
		if (i >= bunsetsuNo) {
			bjoho[no + 1].ent = -1;
			bjoho[no + 1].skouho = 0;
			bjoho[no + 1].srcstr = bjoho[bunsetsuNo].srcstr;
			bjoho[no + 1].srclen = 0;
			bunsetsuNo = no + 1;
			rlen = 0;
		} else {
			i -= (no + 1);
			if (i > 0) {
				bunsetsuNo -= i;
				for (j = no + 1;j < bunsetsuNo; j++) {
					nbjp = &bjoho[j + i];
					bjoho[j].ent = nbjp->ent;
					bjoho[j].skouho = nbjp->skouho;
					bjoho[j].srclen = nbjp->srclen;
					bjoho[j].srcstr = nbjp->srcstr;
					bjoho[j].destlen = nbjp->destlen;
					bjoho[j].deststr = nbjp->deststr;
					bcopy(&(nbjp->dcid), &(bjoho[j].dcid),
							client.stdy_size);
				}
				bjoho[j].ent = -1;
				bjoho[j].skouho = 0;
				bjoho[j].srclen = 0;
				bjoho[j].srcstr = bjoho[j + i].srcstr;
			}
			bjoho[no + 1].srclen -= rlen;
			bjoho[no + 1].srcstr += rlen;
		}
	}
	bjp->srclen = len;
	return rlen;
}

makeBjoho(kouho, bjp)
int kouho;
SJ3_BJOHO *bjp;
{
	register u_char *p, *q;

	p = commbuf;
	if (kouho > 0) {
		if (sj3_bunsetu_henkan(&client,bjp->srcstr,bjp->srclen,p) < 0)
			return -1;
		bjp->ent = 1;
		bcopy(p, &(bjp->dcid), client.stdy_size);
		p += client.stdy_size;
		bjp->destlen = strlen(p);
		strcpy(bjp->deststr, p);
	} else {
		(void)s2e(bjp->srclen, bjp->srcstr, p);
		q = p + bjp->srclen - 1;
		while (p < q) {
			if (*p >= 0x80) {
				if (*p == 0xa4)
					*p = 0xa5;
				p++;
			}
			p++;
		}
		bjp->ent = 0;
		bjp->destlen = bjp->srclen;
		(void)e2s(bjp->destlen, commbuf, bjp->deststr);
	}
	(bjp+1)->deststr = bjp->deststr + bjp->destlen;
}

makeDjoho(str, len, djp)
u_char *str;
int len;
SJ3_DJOHO *djp;
{
	register int 	i, cmp, ret;
	register u_char *p;
	int		udicno;
	SJ3_DJOHO 	*dp;
	SJ3_DOUON 	*dop;

	for (i = 0; i < dictcnt; i++) {
		if (diclist[i].type == 0)
			continue;
		p = commbuf;
		udicno = diclist[i].dictno;
		ret = sj3_tango_syutoku(&client, udicno, p);
		while (!ret) {
			if ((cmp = strcmp(str, p)) < 0) 
				break;
			else if (cmp == 0) {
				p += (len + 1);
				for (dp = djp; dp->dictno >= 0; dp++) {
					if (dp->bunpo != 190)
						continue;
					dop = dp->dop;
					if (strcmp(dop->ddata, p) == 0) {
						dp->dictno = udicno;
						p += (dop->dlen + 1);
						dp->bunpo = *p;
						break;
					}
				}
			}
			p = commbuf;
			ret = sj3_tango_jikouho(&client, udicno, p);
		}
		if (ret < 0 && sj3_error_number == SJ3_SJ3SERV_DEAD)
			break;
	}
}

getwlen(str, len)
u_char *str;
int len;
{
	register int i;
	int rlen;

	rlen = 0;
	for (i = 0; i < len; i++) {
		if (Shift_JIS_P(*str)) {
			rlen++;
			str++;
		}
		rlen++;
		str++;
	}
	return rlen;
}

sj3_exit()
{
	if(client.fd < 0) {
		Vsj3_error_code = Qsj3_no_connection;
		return -1;
	}
	if(sj3_close_dict_stdy() < 0)
		return -1;

	if(sj3_erase_connection(&client) < 0) {
		errorSet();
		return -1;
	}
	Vsj3_error_code = Qnil;
	return 0;
}

sj3_close_dict_stdy()
{
	register int i, dno;

	for (i = 0; i < dictcnt; i++) {
		if ((dno = diclist[i].dictno) == 0)
			continue;
		if (close_dict(dno) < 0)
			return -1;
	}
	if (close_stdy() < 0)
		return -1;
	return 0;
}

close_dict(no)
int no;
{
	int ret;

	ret = 0;
	if (sj3_close_dictionary(&client, no) < 0) {
		errorSet();
		if (sj3_error_number == SJ3_SJ3SERV_DEAD)
			ret = -1;
		else
			ret = 1;
	}
	return ret;
}

close_stdy()
{
	int ret;

	ret = 0;
	if (sj3_close_study_file(&client) < 0) {
		errorSet();
		if (sj3_error_number == SJ3_SJ3SERV_DEAD)
			ret = -1;
		else
			ret = 1;
	}
	return ret;
}

sj3_bgakusyuu(bjp, nbjp)
SJ3_BJOHO *bjp, *nbjp;
{
	u_char ybuf1[SJ3_BUNSETU_YOMI];
	u_char ybuf2[SJ3_BUNSETU_YOMI];
	SJ3_STUDYREC	*dcid;

	strncpy(ybuf1, bjp->srcstr, bjp->srclen);
	ybuf1[bjp->srclen] = '\0';
	if (nbjp != 0) {
		strncpy(ybuf2, nbjp->srcstr, nbjp->srclen);
		ybuf2[nbjp->srclen] = '\0';
		dcid = &(nbjp->dcid);
	} else {
		ybuf2[0] = '\0';
		dcid = 0;
	}
	if (sj3_bunsetu_gakusyuu(&client, ybuf1, ybuf2, dcid) < 0) {
		errorSet();
		if (sj3_error_number == SJ3_SJ3SERV_DEAD)
			return -1;
	}
	return 0;
}

syms_of_sj3()
{
	defsubr(&Ssj3_open);
	defsubr(&Ssj3_close);
	defsubr(&Ssj3_open_dict);
	defsubr(&Ssj3_close_dict);
	defsubr(&Ssj3_make_dict);
	defsubr(&Ssj3_open_stdy);
	defsubr(&Ssj3_close_stdy);
	defsubr(&Ssj3_make_stdy);
	defsubr(&Ssj3_lock_dict);
	defsubr(&Ssj3_unlock_dict);
	defsubr(&Ssj3_begin_henkan);
	defsubr(&Ssj3_jikouho);
	defsubr(&Ssj3_kakutei);
	defsubr(&Ssj3_bunsetu_henkou);
	defsubr(&Ssj3_quit_henkan);
	defsubr(&Ssj3_end_henkan);
	defsubr(&Ssj3_dict_toroku);
	defsubr(&Ssj3_dict_sakujo);
	defsubr(&Ssj3_dict_joho);
	defsubr(&Ssj3_file_access);
        defsubr(&Ssj3_make_directory);

	DEFVAR_LISP ("sj3-error-code", &Vsj3_error_code, "For sj3");
	Vsj3_error_code = Qnil;

	Qsj3_dead = intern (":sj3-dead");
	Qsj3_already_exist = intern (":already-exist");
	Qsj3_no_connection = intern (":sj3-no-connection");
	Qsj3_arguments_missmatch = intern(":arguments-missmatch");
	Qsj3_alloc_fail = intern(":alloc-fail");
	Qsj3_open_fail = intern(":open-fail");
	Qsj3_close_fail = intern(":close-fail");
	Qsj3_too_many_bunsetsu = intern(":too-many-bunsetsu");
	Qsj3_not_a_dict = intern(":not-a-dict");
	Qsj3_no_exist_file = intern(":no-exist-file");
	Qsj3_full_jisho_table = intern(":full-jisho-table");
	Qsj3_cannot_read_file = intern(":cannot-read-file");
	Qsj3_cannot_write_file = intern(":cannot-write-file");
	Qsj3_cannot_open_file = intern(":cannot-open-file");
	Qsj3_no_more_open_dict = intern(":no_more-open-dict");
	Qsj3_read_only_dict = intern(":read-only-dict");
	Qsj3_not_userdict = intern(":not-userdict");
	Qsj3_too_many_moji = intern(":too-many-moji");
	Qsj3_too_long_yomi = intern(":too-long-yomi");
	Qsj3_too_long_kanji = intern(":too-long-kanji");
	Qsj3_bad_yomi = intern(":bad-yomi");
	Qsj3_bad_kanji = intern(":bad-kanji");
	Qsj3_bad_hinshi = intern(":bad-hinshi");
	Qsj3_already_exist_word = intern(":already-exist-word");
	Qsj3_not_exist_word = intern(":not-exist-word");
	Qsj3_cannot_mkdir = intern(":cannot-mkdir");
	Qsj3_not_a_username = intern(":not-a-username");
	Qsj3_not_a_hostname = intern(":not-a-hostname");
	Qsj3_unknown_fail = intern(":unknown-fail");

	client.fd = -1;
}

errorSet()
{
	switch(sj3_error_number) {
	case SJ3_NO_EXIST:
		Vsj3_error_code = Qsj3_no_exist_file;
		break;
	case SJ3_NOT_A_DICT:
		Vsj3_error_code = Qsj3_not_a_dict;
		break;
	case SJ3_JISHOTABLE_FULL:
		Vsj3_error_code = Qsj3_full_jisho_table;
		break;
	case SJ3_PARAMR:
		Vsj3_error_code = Qsj3_cannot_read_file;
		break;
	case SJ3_PARAMW:
		Vsj3_error_code = Qsj3_cannot_write_file;
		break;
	case SJ3_OPEN_ERR:
		Vsj3_error_code = Qsj3_cannot_open_file;
		break;
	case SJ3_NOT_A_USERDICT:
		Vsj3_error_code = Qsj3_not_userdict;
		break;
	case SJ3_RONLY_DICT:
		Vsj3_error_code = Qsj3_read_only_dict;
		break;
	case SJ3_BAD_YOMI:
		Vsj3_error_code = Qsj3_bad_yomi;
		break;
	case SJ3_BAD_KANJI:
		Vsj3_error_code = Qsj3_bad_kanji;
		break;
	case SJ3_BAD_HINSHI:
		Vsj3_error_code = Qsj3_bad_hinshi;
		break;
	case SJ3_WORD_NO_EXIST:
		Vsj3_error_code = Qsj3_not_exist_word;
		break;
	case SJ3_WORD_ALREADY_EXIST:
		Vsj3_error_code = Qsj3_already_exist_word;
		break;
	case SJ3_SJ3SERV_DEAD:
		Vsj3_error_code = Qsj3_dead;
		break;
	case SJ3_ALLOC_FAIL:
		Vsj3_error_code = Qsj3_alloc_fail;
		break;
	case SJ3_SOCK_OPEN_FAIL:
		Vsj3_error_code = Qsj3_open_fail;
		break;
	case SJ3_MKDIR_FAIL:
		Vsj3_error_code = Qsj3_cannot_mkdir;
		break;
	case SJ3_BAD_USER:
		Vsj3_error_code = Qsj3_not_a_username;
		break;
	case SJ3_BAD_HOST:
		Vsj3_error_code = Qsj3_not_a_hostname;
		break;
	default:
/*		Vsj3_error_code = Qsj3_unknown_fail; */
		Vsj3_error_code = make_number( sj3_error_number);
	}
}

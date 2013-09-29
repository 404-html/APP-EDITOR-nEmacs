/* Nemacs site configuration file
   Coded by K.Handa, Electrotechnical Lab. (handa@elt.go.jp)

   This file is part of Nemacs (Japanese version of GNU Emacs).

   Nemacs is distributed in the forms of patches to GNU
   Emacs under the terms of the GNU EMACS GENERAL PUBLIC
   LICENSE which is distributed along with GNU Emacs by the
   Free Software Foundation.

   Nemacs is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied
   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
   PURPOSE.  See the GNU EMACS GENERAL PUBLIC LICENSE for
   more details.

   You should have received a copy of the GNU EMACS GENERAL
   PUBLIC LICENSE along with Nemacs; see the file COPYING.
   If not, write to the Free Software Foundation, 675 Mass
   Ave, Cambridge, MA 02139, USA. */

/* 90.2.27  created for Nemacs Ver.3.3.1 by K.Handa */

#ifdef NEMACS

/* define EGG if you want to use EGG */
/* #define EGG */

/* define SKK if you want to use SKK, or don't want to use Wnn, Canna, etc */
#define SKK

#ifdef  SKK

#define LIBWNN
#define INCWNN
#define	LIBCANNA
#define	INCCANNA

#else   /* SKK */

#ifndef	EGG
/* define CANNA if you want to use CANNA */
#define	CANNA
#endif

/* define also CANNA2 if you want to use CANNA version 2.1 or higher */
#ifdef	CANNA
#define	CANNA2
#endif

#ifdef EGG
/* define one of WNN3, WNN4, and WNN4V3 */
#define WNN4V3
#ifndef	WNN4V3
#define	SJ3	/* Dummy !! */
#endif
#endif

#ifdef WNN4V3
#define LIBWNN /usr/X386/lib/libjd.a
#define INCWNN -I/usr/include/wnn
#else   /* not WNN4V3 */
#ifdef WNN3
#define LIBWNN /usr/local/wnn3/jlib/libjd.a
#define INCWNN -I/usr/local/wnn3/include
#else   /* not WNN4V3 nor WNN3 */
#ifdef	SJ3
#define	LIBWNN /usr/lib/libsj3lib.a
#define	INCWNN -I/usr/include/sj3
#else
#define LIBWNN
#define INCWNN
#endif  /* not WNN3 */
#endif  /* not WNN4V3 */
#endif

#ifdef	CANNA
#define	LIBCANNA	/usr/lib/libcanna.a
#define	INCCANNA	-I/usr/local/canna/include
#else
#define	LIBCANNA
#define	INCCANNA
#endif

/* Temporary Setting */
#define MScreenWidth 300
#endif  /* SKK */
#endif  /* NEMACS */

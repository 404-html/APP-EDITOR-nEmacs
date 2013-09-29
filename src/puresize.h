/* PURESIZE definition file
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
#undef PURESIZE
#if defined(EGG) || defined(CANNA)
#ifdef HAVE_X_WINDOWS
/*#define PURESIZE 300000*/
#define PURESIZE 296000
#else
/*#define PURESIZE 296000*/
#define PURESIZE 260000
#endif
#else  /* not EGG */
#ifdef HAVE_X_WINDOWS
/*#define PURESIZE 216000*/
#define PURESIZE 216000
#else
/*#define PURESIZE 212000*/
#define PURESIZE 212000
#endif
#endif  /* not EGG */
#endif  /* not NEMACS */

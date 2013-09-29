/* Fundamental definitions for Nemacs.
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

/* 87.6.5   created by K.Handa */
/* 87.12.9  modified for Nemacs Ver.2.0 by K.Handa */
/* 88.5.25  modified for Nemacs Ver.2.1 by K.Handa */
/* 89.2.22  modified for Nemacs Ver.3.0 by K.Handa */
/* 89.11.17 modified for Nemacs Ver.3.2 by K.Handa */
/* 89.12.15 modified for Nemacs Ver.3.2.1 by S. Tomura */

#define ESC_CODE 033

#define S2E(i1, i2, c1, c2) \
{ \
  if (i2 >= 0x9f) { \
    if (i1 >= 0xe0) c1 = i1*2 - 0xe0; \
    else c1 = i1*2 - 0x60; \
    c2 = i2 + 2; \
  } else { \
    if (i1 >= 0xe0) c1 = i1*2 - 0xe1; \
    else c1 = i1*2 - 0x61; \
    if (i2 >= 0x7f) c2 = i2 + 0x60; \
    else c2 = i2 +  0x61; \
  } \
}

#define E2S(i1, i2, c1, c2) \
{ \
  if (i1 & 1) { \
    if (i1 < 0xdf) c1 = i1/2 + 0x31; \
    else c1 = i1/2 + 0x71; \
    if (i2 >= 0xe0) c2 = i2 - 0x60; \
    else c2 = i2 - 0x61; \
  } else {			 \
    if (i1 < 0xdf) c1 = i1/2 + 0x30; \
    else  c1 = i1/2 + 0x70; \
    c2 = i2 - 2; \
  } \
}

#define S2J(i1, i2, c1, c2) \
{ \
  if (i2 >= 0x9f) { \
    c1 = (i1 * 2 - ((i1 >= 0xe0) ? 0xe0 : 0x60)) & 0x7f; \
    c2 = i2 - 0x7e; \
  } else { \
    c1 = (i1 * 2 - ((i1 >= 0xe0) ? 0xe1 : 0x61)) & 0x7f; \
    c2 = (i2 + ((i2 >= 0x7f) ? 0x60 : 0x61)) & 0x7f; \
  } \
}

#define J2S(i1, i2, c1, c2) \
{ \
  i1 |= 0x80; i2 |= 0x80; \
  if (i1 & 1) { \
    c1 = i1/2 + ((i1 < 0xdf) ? 0x31 : 0x71); \
    c2 = i2 - ((i2 >= 0xe0) ? 0x60 : 0x61); \
  } else { \
    c1 = i1/2 + ((i1 < 0xdf) ? 0x30 : 0x70); \
    c2 = i2 - 2; \
  } \
}

#ifdef emacs

extern unsigned char jcode_table[256];
#define Shift_JIS_P(c) (jcode_table[(unsigned char)c] & 1)
#define JIS_P(c) (jcode_table[(unsigned char)c] & 2)
#define EUC_P(c) (jcode_table[(unsigned char)c] & 4)
#define JCODE(c) EUC_P(c)
#define JCODEP(p) (JCODE(*p) && JCODE(*(p+1)))

#define NOCONV 0
#define Shift_JIS 1
#define JIS 2
#define EUC 3

extern int kanji_code_min;		/* = NOCONV */
extern int kanji_code_max;		/* = EUC */
extern int kanji_input_code;		/* One of above */
extern int kanji_display_code;		/* One of above */
extern int default_kanji_process_code; /* One of above */

extern int kanji_JIS_flag;	/* Flag: JIS code is being read */
extern int to_kanji_display;	/* ESC sequence to go to Kanji */
extern int to_ascii_display;	/* ESC sequence to go to Ascii */
extern int to_kanji_fileio;	/* ESC sequence to go to Kanji */
extern int to_ascii_fileio;	/* ESC sequence to go to Ascii */
extern int to_kanji_process;	/* ESC sequence to go to Kanji */
extern int to_ascii_process;	/* ESC sequence to go to Ascii */

extern Lisp_Object Qkanji_self_insert;	/* Command for Kanji insert */

extern Lisp_Object Fkanji_jis_start(), Fkanji_jis_end(), Fkanji_point();
extern Lisp_Object Fconvert_region_kanji_code(), Fconvert_string_kanji_code();
extern Lisp_Object Fcheck_region_kanji_code(), Fcheck_string_kanji_code();

extern char *get_kanji_work_area();
extern int convert_kanji_code();

/* Used to notify write_chars() the kanji-flag
   of the currently drawing buffer */
extern int current_kanji_flag;

/* patch by K.Handa  88.5.23 based on the idea of Mr. sanewo 88.3.8 */
#define KANJI_MODE_CHAR_MASK	0x00ff
#define KANJI_MODE_CHAR(m)	((m) & KANJI_MODE_CHAR_MASK)
#define KANJI_MODE_CHAR_SET(m,c) ((m) = ((m) & ~KANJI_MODE_CHAR_MASK) \
				         | ((c) &  KANJI_MODE_CHAR_MASK))
#define KANJI_MODE_PENDING_MASK	0x0f00
#define KANJI_MODE_PENDING(m)	((m) & KANJI_MODE_PENDING_MASK)
#define KANJI_MODE_PENDING_NONE 0x0000
#define KANJI_MODE_PENDING_CHAR 0x0100
#define KANJI_MODE_PENDING_ESC  0x0200
#define KANJI_MODE_PENDING_SET(m,s) ((m) = ((m) & ~KANJI_MODE_PENDING_MASK) \
				            | ((s) &  KANJI_MODE_PENDING_MASK))
#define KANJI_MODE_FLAG_MASK	0xf000
#define KANJI_MODE_FLAG(m)	((m) & KANJI_MODE_FLAG_MASK)
#define KANJI_MODE_NORMAL	0x0000
#define KANJI_MODE_KANJI	0x1000
#define KANJI_MODE_FLAG_SET(m,f) ((m) = ((m) & ~KANJI_MODE_FLAG_MASK) \
				         | ((f) &  KANJI_MODE_FLAG_MASK))
/* end of patch */

/* patch by K.Handa  89.11.17 */
#define KANJI_WORK_SIZE 1024
extern char kanji_work_area[KANJI_WORK_SIZE];
/* end of patch */

#endif  /* emacs */

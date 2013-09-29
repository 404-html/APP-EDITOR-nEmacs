/* Fundamental subroutines for handling Japanese code in Nemacs.
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

/* 87.6.7   created by K.Handa */
/* 87.7.12  modified by K.Handa */
/* 87.12.9  modified for Nemacs Ver.2.0 by K.Handa */
/* 88.5.19  modified for Nemacs Ver.2.1 by K.Handa */
/* 89.2.22  modified for Nemacs Ver.3.0 by K.Handa */
/* 89.9.3   modified by S. Tomura */
/* 89.12.23 modified for Nemacs Ver.3.2.3 by K.Handa
	'kanji_read_from_process' handles invalid kanji sequence correctly. */
/* 90.1.26  modified for Nemacs Ver.3.3.1 by nomura@ws.sony.co.jp
	kanji-char-after returns correct value when pointed the 2nd char. */

#include <stdio.h>

#include "config.h"
#undef NULL
#include "lisp.h"
#include "buffer.h"
#include "syntax.h"
#include "kanji.h"

#ifdef  SKK
Lisp_Object VNEMACS ;
#endif
#ifdef	EGG
#ifdef	SJ3
Lisp_Object VNEMACS, VEGG, VWNN3, VWNN4V3, VWNN4, VSJ3;
#else
Lisp_Object VNEMACS, VEGG, VWNN3, VWNN4V3, VWNN4;
#endif /* SJ3 */
#endif
#ifdef	CANNA
Lisp_Object VNEMACS, VCANNA;
#endif

int kanji_code_min;
int kanji_code_max;
int kanji_input_code;
int kanji_display_code;
int default_kanji_process_code;
int to_kanji_display;
int to_ascii_display;
int to_kanji_fileio;
int to_ascii_fileio;
int to_kanji_process;
int to_ascii_process;
Lisp_Object Qkanji_self_insert;
int kanji_JIS_flag;
int current_kanji_flag;
unsigned char jcode_table[256];

DEFUN ("jcode-type", Fkanji_point, Skanji_point, 1, 2, 0,
  "Return the type of character code at POS.\n\
0: not Jcode, 1: 1st char of Jcode, 2: 2nd char of Jcode.\n\
If POS is out of range, the value is NIL.\n\
If POS is surely at a correct character boundary,\n\
you can give an optional non-NIL arguments for speed-up.")
  (pos, onboundary)
     register Lisp_Object pos, onboundary;
{
  register Lisp_Object type;
  register int n = XINT (pos);
  CHECK_NUMBER (pos, 0);
  if (n < BEGV || n >= ZV) return Qnil;
  XFASTINT (type) = NULL(onboundary) ? kanji_point(n) : JCODE(FETCH_CHAR (n));
  return type;
}

kanji_point(p)
     register int p;
{
  register int start = p;

/* modified by K.Wakamiya (wkenji@flab.fujitsu.co.jp) 90.10.12 */
/* modified for emacs18.59 by S.Okamoto 93.04.30 */
  if (!NULL(current_buffer->kanji_flag) && JCODE(FETCH_CHAR (p)) &&
      p < ZV && p >= BEGV && (ZV-1 - BEGV) > 0) {
    p++;
    while (p < ZV && JCODE(FETCH_CHAR (p))) p++;
    return ((p - start)%2 ? 2 : 1);
/* end of wkenji's modification */
  } else
    return 0;
}

set_point(np)
     int np;	/* new point */
{
  if (NULL (current_buffer->kanji_flag)) return np;
  if (kanji_point(np) == 2) np--;  /* 89.3.10 patch by K.Handa */
  return np;
}

/* 89.3.1  patch by K.Handa */
DEFUN ("kanji-char-after", Fkanji_char_after, Skanji_char_after, 1, 1, 0,
  "One arg, POS, a number.  Return the euc code of kanji character\n\
in the current buffer at position POS.\n\
If the character is not kanji, return normal code of that charcter\n\
If POS is out of range, the value is NIL.")
  (pos)
     Lisp_Object pos;
{
  register Lisp_Object val;
  register int n = XINT (pos);
  CHECK_NUMBER (pos, 0);
  if (n < BEGV || n >= ZV) return Qnil;

  switch (kanji_point(n)) {
  case 0:
    XFASTINT (val) = FETCH_CHAR (n);
    break;
  case 1:
    if (n >= ZV) return Qnil;
    XFASTINT (val) = (FETCH_CHAR (n) << 8) | FETCH_CHAR (n+1);
    break;
  case 2:
    if (n < BEGV) return Qnil;
    XFASTINT (val) = (FETCH_CHAR (n-1) << 8) | FETCH_CHAR (n); /* 90.1.26 */
    break;
  }
  return val;
}

DEFUN ("kanji-delete-region", Fkanji_delete_region, Skanji_delete_region,
  2, 2, "r",
  "Delete the text between point and mark.\n\
If kanji-flag is T and point or mark is in the midst of kanji character,\n\
nondeleted half of 2 byte code is replaced with a space.\n\
When called from a program, expects two arguments,\n\
character numbers specifying the stretch to be deleted.")
  (b, e)
     Lisp_Object b, e;
{
/* 89.9.7 by K.Handa */
  int beg, end, spaces = 0, saved_p;

/* modified by K.Wakamiya (wkenji@flab.fujitsu.co.jp) 90.10.16 */
/* modified for emacs18.59 by S.Okamoto (okamoto@ntttsd.ntt.jp) 93.04.30 */
  register int i;

  CHECK_NUMBER_COERCE_MARKER (b, 0);
  CHECK_NUMBER_COERCE_MARKER (e, 1);

  if (XINT (b) > XINT (e)) {
    i = XFASTINT (b);	/* This is legit even if b is < 0 */
    b = e;
    XFASTINT (e) = i;	/* because this is all we do with i. */
  }
  if (!(BEGV <= XINT (b) && 
	XINT (b) <= XINT (e) &&
	XINT (e) <= ZV))
    args_out_of_range (b, e);
/* end of wkenji's modification */
  beg = XFASTINT (b); end = XFASTINT (e);
  if (!NULL(current_buffer->kanji_flag) && beg != end) {
    if (kanji_point (beg) == 2) { beg--; spaces++;}
    if (kanji_point (end) == 2) { end++; spaces++;}
  }
  del_range(beg, end);
  if (spaces) {
    saved_p = point;
    SET_PT (beg);
    insert ("  ", spaces);
    SET_PT (saved_p);
  }
  return Qnil;
}
/* end of patch */

s2e(n, sbuf, ebuf)
     int n;
     unsigned char *sbuf, *ebuf;
{
  unsigned char *endp = sbuf + n - 1;
  unsigned char *startp = ebuf;
  unsigned char i1, i2;

  while (sbuf < endp) {
    if (Shift_JIS_P(*sbuf)) {
      i1 = *sbuf++; i2 = *sbuf++;
      S2E (i1, i2, *ebuf++, *ebuf++);
    } else
      *ebuf++ = *sbuf++;
  }
  if (sbuf == endp) *ebuf++ = *sbuf++;
  return (ebuf - startp);
}

e2s(n, ebuf, sbuf)
     int n;
     unsigned char *ebuf, *sbuf;
{
  unsigned char *endp = ebuf + n - 1;
  unsigned char *startp = sbuf;
  unsigned char i1, i2;

  while (ebuf < endp) {
    if (EUC_P(*ebuf)) {
      i1 = *ebuf++; i2 = *ebuf++;
      E2S (i1, i2, *sbuf++, *sbuf++);
    } else
	*sbuf++ = *ebuf++;
  }
  if (ebuf == endp) *sbuf++ = *ebuf++;
  return (sbuf - startp);
}

j2e(n, jbuf, ebuf)
     int n;
     unsigned char *jbuf, *ebuf;
{
  unsigned char *endp = jbuf + n - 2;
  unsigned char *startp = ebuf;
  int kanji = 0;

  while (jbuf < endp) {
    if (to_kanji(jbuf)) {
      kanji = 1; jbuf += 3;
    } else if (to_ascii(jbuf)) {
      kanji = 0; jbuf += 3;
    } else if (kanji && JIS_P(*jbuf) && JIS_P(*(jbuf + 1)) ) {
      *ebuf++ = *jbuf++ | 0x80;
      *ebuf++ = *jbuf++ | 0x80;
    } else
      *ebuf++ = *jbuf++;
  }
  if (jbuf == endp) {
    if (kanji && JIS_P(*jbuf) && JIS_P(*(jbuf + 1)) ) {
      *ebuf++ = *jbuf++ | 0x80;
      *ebuf++ = *jbuf++ | 0x80;
    } else {
      *ebuf++ = *jbuf++;
      *ebuf++ = *jbuf++;
    }
  } else if (jbuf == endp + 1)
    *ebuf++ = *jbuf++;
  return (ebuf - startp);
}

e2j(n, ebuf, jbuf, to_kanji_code, to_ascii_code)
     int n;
     unsigned char *ebuf, *jbuf, to_kanji_code, to_ascii_code;
{
  unsigned char *endp = ebuf + n - 1;
  unsigned char *startp = jbuf;
  int kanji = 0;

  while (ebuf < endp) {
    if (kanji) {
      if (EUC_P(*ebuf)) {
	*jbuf++ = *ebuf++ & 0x7f;
	*jbuf++ = *ebuf++ & 0x7f;
      } else {
	*jbuf++ = ESC_CODE; *jbuf++ = '('; *jbuf++ = to_ascii_code;
	*jbuf++ = *ebuf++;
	kanji = 0;
      }
    } else {
      if (EUC_P(*ebuf)) {
	*jbuf++ = ESC_CODE; *jbuf++ = '$'; *jbuf++ = to_kanji_code;
	*jbuf++ = *ebuf++ & 0x7f;
	*jbuf++ = *ebuf++ & 0x7f;
	kanji = 1;
      } else
	*jbuf++ = *ebuf++;
    }
  }
  if (kanji) {
    *jbuf++ = ESC_CODE; *jbuf++ = '('; *jbuf++ = to_ascii_code;
  }
  if (ebuf == endp) *jbuf++ = *ebuf++;
  return (jbuf - startp);
}

s2j(n, buf1, buf2, to_kanji_code, to_ascii_code)
     int n;
     unsigned char *buf1, *buf2, to_kanji_code, to_ascii_code;
{
  unsigned char *endp = buf1 + n - 1, *startp = buf2, i1, i2;
  int kanji = 0;

  while (buf1 < endp) {
    if (kanji) {
      if (Shift_JIS_P(*buf1)) {
	i1 = *buf1++; i2 = *buf1++;
	S2J(i1, i2, *buf2++, *buf2++);
      } else {
	*buf2++ = ESC_CODE; *buf2++ = '('; *buf2++ = to_ascii_code;
	*buf2++ = *buf1++;
	kanji = 0;
      }
    } else {
      if (Shift_JIS_P(*buf1)) {
	*buf2++ = ESC_CODE; *buf2++ = '$'; *buf2++ = to_kanji_code;
	i1 = *buf1++; i2 = *buf1++;
	S2J(i1, i2, *buf2++, *buf2++);
	kanji = 1;
      } else
	*buf2++ = *buf1++;
    }
  }
  if (kanji) {
    *buf2++ = ESC_CODE; *buf2++ = '('; *buf2++ = to_ascii_code;
  }
  if (buf2 == endp) *buf2++ = *buf1++;
  return (buf2 - startp);
}

j2s(n, buf1, buf2)
     int n;
     unsigned char *buf1, *buf2;
{
  unsigned char *endp = buf1 + n - 2, *startp = buf2, i1,i2;
  int kanji = 0;

  while (buf1 < endp) {
    if (to_kanji(buf1)) {
      kanji = 1; buf1 += 3;
    } else if (to_ascii(buf1)) {
      kanji = 0; buf1 += 3;
    } else if (kanji && JIS_P(*buf1) && JIS_P(*(buf1 + 1)) ) {
      i1 = *buf1++; i2 = *buf1++;
      J2S(i1, i2, *buf2++, *buf2++);
    } else
      *buf2++ = *buf1++;
  }
  if (buf1 == endp) {
    if (kanji && JIS_P(*buf1) && JIS_P(*(buf1 + 1)) ) {
      i1 = *buf1++; i2 = *buf1++;
      J2S(i1, i2, *buf2++, *buf2++);
    } else
      *buf2++ = *buf1++;
      *buf2++ = *buf1++;
  } else if (buf1 == endp + 1)
    *buf2++ = *buf1++;
  return (buf2 - startp);
}

to_kanji(buf)
     unsigned char *buf;
{
  return (*buf++ == ESC_CODE &&
	  *buf++ == '$' &&
	  (*buf == '@' || *buf == 'B'));
}

to_ascii(buf)
     unsigned char *buf;
{
  return (*buf++ == ESC_CODE &&
	  *buf++ == '(' &&
	  (*buf == 'J' || *buf == 'B' || *buf == 'H'));
}

char kanji_work_area[KANJI_WORK_SIZE];
char *malloced_area;

char *
get_kanji_work_area(len, code)
     int len, code;
{
  free_kanji_work_area();
  if (code == JIS) len = len * 3 + 2;
  if (len > KANJI_WORK_SIZE)
    if ((malloced_area = malloc(len)) == (char *)0) {
      malloced_area = kanji_work_area;
      memory_full ();
    }
  return malloced_area;
}

free_kanji_work_area()
{
  if (malloced_area != kanji_work_area) {
    free(malloced_area);
    malloced_area = kanji_work_area;
  }
}

DEFUN ("convert-region-kanji-code", Fconvert_region_kanji_code,
       Sconvert_region_kanji_code, 4, 4, "r\nnSource code: \nnTarget code: ",
  "Convert kanji code of the text between point and mark\n\
from SOURCE code to TARGET code.\n\
When called from a program, takes four args:\n\
STAER, END, SOURCE, and TARGET.")
  (b, e, src, tgt)
      Lisp_Object b, e, src, tgt;
{
  int len, beg, end;
  char *p;

  CHECK_NUMBER(src, 0); CHECK_NUMBER(tgt, 0);
  if (EQ (src,tgt)) error ("no need of converion");

  validate_region (&b, &e);
  beg = XINT (b);
  end = XINT (e);
  len = end - beg;
  prepare_to_modify_buffer ();
  record_change (beg, len);
/* patch 89-09-03 by S. Tomura */
  if (beg <= GPT-1 && end > GPT)
/* end of patch */
    move_gap (beg);

  if (XFASTINT(tgt) == JIS) {
    if (!(p = malloc(len * 3 + 2))) memory_full();
  } else {
    p = (char *)&FETCH_CHAR(beg);
  }
  len = convert_kanji_code(len, &FETCH_CHAR(beg), p,
			   XFASTINT(src), XFASTINT(tgt),
			   to_kanji_fileio, to_ascii_fileio);
  if (XFASTINT(src) == JIS && len < end - beg) {
    del_range(beg + len, end);
  } else if (XFASTINT(tgt) == JIS) {
    del_range(beg, end);
    insert(p, len);
    free(p);
  }
  modify_region(beg, beg + len);

  return Qnil;
}

DEFUN ("convert-string-kanji-code", Fconvert_string_kanji_code,
       Sconvert_string_kanji_code, 3, 3, 0,
  "Convert kanji code in STRING from SOURCE code to TARGET code,\n\
and return the result string.")
  (str, src, tgt)
      Lisp_Object str, src, tgt;
{
  int len;
  char *p;
  Lisp_Object newstr;

  CHECK_STRING(str, 0); CHECK_NUMBER(src, 0); CHECK_NUMBER(tgt, 0);
  len = XSTRING(str)->size;
  if (EQ (src,tgt)) error ("no need of converion");
  if (XFASTINT(src) == JIS) {
    if (!(p = malloc(len))) memory_full();
  } else if (XFASTINT(tgt) == JIS) {
    len = len * 3 + 2;
    if (!(p = malloc(len))) memory_full();
  } else {
    newstr = make_string(XSTRING(str)->data, len);
    p = (char *)XSTRING(newstr)->data;
  }
  len = convert_kanji_code(XSTRING(str)->size, XSTRING(str)->data, p,
			   XFASTINT(src), XFASTINT(tgt),
			   to_kanji_fileio, to_ascii_fileio);
  if (XFASTINT (src) == JIS || XFASTINT (tgt) == JIS) {
    newstr = make_string(p, len);
    free(p);
  }
  return newstr;
}

convert_kanji_code(n, buf1, buf2, code1, code2, to_kanji, to_ascii)
     int n, code1, code2;
     unsigned char *buf1, *buf2;
{
  if (!n || code1 == code2) return n;

  switch (code1) {
  case EUC:
    n = (code2 == Shift_JIS) ? e2s(n, buf1, buf2)
			     : e2j(n, buf1, buf2, to_kanji, to_ascii);
    break;
  case Shift_JIS:
    n = (code2 == EUC) ? s2e(n, buf1, buf2)
		       : s2j(n, buf1, buf2, to_kanji, to_ascii);
    break;
  case JIS:
    n = (code2 == EUC) ? j2e(n, buf1, buf2) : j2s(n, buf1, buf2);
    break;
  }
  return n;
}

DEFUN ("check-region-kanji-code", Fcheck_region_kanji_code,
       Scheck_region_kanji_code, 2, 2, "r",
  "Return kanji code of the text between point and mark.\n\
If no kanji code is in the string, NIL is returned.\n\
If both EUC and Shift-JIS is possible, 0 is returned.\n\
When called from a program, takes two args START and END.")
  (b, e)
      Lisp_Object b, e;
{
  int beg, end, code;

  validate_region (&b, &e);
  beg = XINT (b);
  end = XINT (e);
/* patch 89-09-03 by S. Tomura */
  if (beg <= GPT-1 && end > GPT)
/* end of patch */
    move_gap (beg);

  code = check_kanji_code(&FETCH_CHAR(beg), end - beg);
  return ((code < 0) ? Qnil : make_number(code));
}

DEFUN ("check-string-kanji-code", Fcheck_string_kanji_code,
       Scheck_string_kanji_code, 1, 1, 0,
  "Return kanji code of STRING.\n\
If no kanji code is in the string, NIL is returned.\n\
If both EUC and Shift-JIS is possible, 0 is returned.")
  (str)
      Lisp_Object str;
{
  int code;

  CHECK_STRING(str, 0);
  code = check_kanji_code(XSTRING(str)->data, XSTRING(str)->size);
  return ((code < 0) ? Qnil : make_number(code));
}


check_kanji_code(buf, n)
     int n;
     unsigned char *buf;
{
  unsigned char c, *endp = buf + n - 1;
  int assume_euc = 0;

  while(buf < endp) {
    c = *buf++;
    if (c == ESC_CODE && *buf == '$'&& !assume_euc) return JIS;
    if (c & 0x80) {
      if (c < 0xa0) return Shift_JIS;
      else if (c < 0xe0 || c > 0xef) return EUC;
      c = *buf++;
      if (c < 0xa1) return Shift_JIS;
      else if (c > 0xfc) return EUC;
      assume_euc = 1;
    }
  }
  return (assume_euc ? 0 : -1);
}

/* patch by A.Kato(kato@koudai.cs.titech.junet)  87.7.7 */
/* modified by K.Handa  87.12.9 */
/* modified by K.Handa 88.1.19  according to patch by Mr.Sanewo (88.3.6) */
kanji_read_from_process(d, buf, preceding, nbytes, kanji, code)
     int d, preceding, nbytes, *kanji, code;
     unsigned char *buf;
{
  int n;
  unsigned char *ebuf, *endp, i1, i2, preceding_char = *buf;
  unsigned char *startp = buf;

  if (!nbytes) return 0;
  
  switch (KANJI_MODE_PENDING(*kanji)) {
  case KANJI_MODE_PENDING_CHAR:
    *buf++ = KANJI_MODE_CHAR(*kanji);
    nbytes--;
    break;
  case KANJI_MODE_PENDING_ESC:
    *buf++ = ESC_CODE;
    *buf++ = KANJI_MODE_CHAR(*kanji);
    nbytes -= 2;
    break;
  }
  if (preceding) {
    *buf++ = preceding_char;
    nbytes--;
  }

  if ((n = read(d, buf, nbytes)) <= 0 && !preceding) return -1;

  endp = buf + n;

  switch (code) {
  case EUC:
    if (EUC_P(*(endp - 1))) {
      buf = endp;
      while (--buf >= startp && EUC_P(*buf));
      if ((endp - buf) % 2 == 0) {
	KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_CHAR);
	KANJI_MODE_CHAR_SET(*kanji, *(endp-1));
	endp--;
      } else
	KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_NONE);
    } else
      KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_NONE);
    break;
  case Shift_JIS:
    buf = startp;
    endp--;
    while (buf < endp) {
      if (Shift_JIS_P(*buf)) {
	S2E (*buf, *(buf+1), *buf, *(buf+1));
	buf += 2;
      } else
	buf++;
    }
    if (buf > endp || !Shift_JIS_P(*buf)) {
      KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_NONE);
      endp++;
    } else {
      KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_CHAR);
      KANJI_MODE_CHAR_SET(*kanji, *buf);
    }
    break;
  case JIS:
    buf = (ebuf = startp);
    endp -= 2;
    while (buf < endp) {
      if (to_kanji(buf)) {
	KANJI_MODE_FLAG_SET(*kanji, KANJI_MODE_KANJI);
	buf += 3;
      } else if (to_ascii (buf)) {
	KANJI_MODE_FLAG_SET(*kanji, KANJI_MODE_NORMAL);
	buf += 3;
      } else {
	if (KANJI_MODE_FLAG(*kanji) == KANJI_MODE_NORMAL
	    || !JIS_P(*buf) || !JIS_P(*(buf+1))) {
	  *ebuf++ = *buf++;
	} else {
	  *ebuf++ = *buf++ | 0x80;
	  *ebuf++ = *buf++ | 0x80;
	}
      }
    }
    if (buf == endp) {
      if (*buf == ESC_CODE) {
	KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_ESC);
	KANJI_MODE_CHAR_SET(*kanji, *(buf+1));
      } else {
	if (KANJI_MODE_FLAG(*kanji) == KANJI_MODE_NORMAL
	    || !JIS_P(*buf) || !JIS_P(*(buf+1))) {
	  *ebuf++ = *buf++;
	} else {
	  *ebuf++ = *buf++ | 0x80;
	  *ebuf++ = *buf++ | 0x80;
	}
      }
    }
    if (buf == endp + 1) {
      if (*buf == ESC_CODE) {
	KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_CHAR);
	KANJI_MODE_CHAR_SET(*kanji, ESC_CODE);
      } else {
	if (KANJI_MODE_FLAG(*kanji) == KANJI_MODE_NORMAL || !JIS_P(*buf)) {
	  *ebuf++ = *buf++;
	} else {
	  KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_CHAR);
	  KANJI_MODE_CHAR_SET(*kanji, *buf);
	}
      }
    }
    if (buf == endp + 2)
      KANJI_MODE_PENDING_SET(*kanji, KANJI_MODE_PENDING_NONE);

    endp = ebuf;
    break;
  }
  return (endp - startp);
}

DEFUN ("kanji-jis-start", Fkanji_jis_start, Skanji_jis_start, 0, 0, "",
  "Set flag kanji_JIS_flag to t.")
  ()
{
/* modified by K.Handa 88.5.26 */
  if (!NULL(current_buffer->kanji_flag) && XFASTINT(kanji_input_code) == JIS) {
    kanji_JIS_flag = 1;
  }
  return Qnil;
}

DEFUN ("kanji-jis-end", Fkanji_jis_end, Skanji_jis_end, 0, 0, "",
  "Set kanji_JIS_flag to nil.")
  ()
{
/* modified by K.Handa 88.5.26 */
  if (!NULL(current_buffer->kanji_flag) && XFASTINT(kanji_input_code) == JIS) {
    kanji_JIS_flag = 0;
  }
  return Qnil;
}

init_kanji()
{
  int i;

  bzero(jcode_table, 256);
  for (i = 0x80; i <= 0x9f; i++) jcode_table[i] |= 1;
  for (i = 0xe0; i <= 0xef; i++) jcode_table[i] |= 1;
  for (i = 0x21; i < 0x7f; i++) jcode_table[i] |= 2;
  for (i = 0xa1; i < 0xff; i++) jcode_table[i] |= 4;
  malloced_area = kanji_work_area;
}

syms_of_kanji ()
{
  defsubr (&Skanji_point);
  defsubr (&Skanji_char_after);
  defsubr (&Skanji_delete_region);
  defsubr (&Skanji_jis_start);
  defsubr (&Skanji_jis_end);
  defsubr (&Sconvert_region_kanji_code);
  defsubr (&Sconvert_string_kanji_code);
  defsubr (&Scheck_region_kanji_code);
  defsubr (&Scheck_string_kanji_code);

  DEFVAR_INT ("kanji-code-min", &kanji_code_min,
    "* Minimum value of valid kanji code.");
  kanji_code_min = NOCONV;

  DEFVAR_INT ("kanji-code-max", &kanji_code_max,
    "* Maximum value of valid kanji code.");
  kanji_code_max = EUC;

  DEFVAR_INT ("to-kanji-display", &to_kanji_display,
    "* The last character of ESC sequence to go to Kanji in display");
  to_kanji_display = '@';

  DEFVAR_INT ("to-ascii-display", &to_ascii_display,
    "* The last character of ESC sequence to go to Ascii in display");
  to_ascii_display = 'J';

  DEFVAR_INT ("to-kanji-fileio", &to_kanji_fileio,
     "* The last character of ESC sequence to go to Kanji in fileio");
  to_kanji_fileio = '@';

  DEFVAR_INT ("to-ascii-fileio", &to_ascii_fileio,
    "* The last character of ESC sequence to go to Ascii in fileio");
  to_ascii_fileio = 'J';

  DEFVAR_INT ("to-kanji-process", &to_kanji_process,
     "* The last character of ESC sequence to go to Kanji in process I/O.");
  to_kanji_process = '@';

  DEFVAR_INT ("to-ascii-process", &to_ascii_process,
    "* The last character of ESC sequence to go to Ascii in process I/O.");
  to_ascii_process = 'J';

  DEFVAR_INT ("kanji-input-code", &kanji_input_code,
    "0:No-conversion  1:Shift-JIS  2:JIS  3:EUC/AT&T/DEC");
  kanji_input_code = JIS;

  DEFVAR_INT ("kanji-display-code", &kanji_display_code,
    "0:No-conversion  1:Shift-JIS  2:JIS  3:EUC/AT&T/DEC");
  kanji_display_code = JIS;

/* patch by K.Handa  89.11.25 */
  DEFVAR_LISP ("NEMACS", &VNEMACS, "");
  VNEMACS = Qt;

#ifdef EGG
  DEFVAR_LISP ("EGG", &VEGG, "");
  VEGG = Qt;
#endif
#ifdef WNN3
  DEFVAR_LISP ("WNN3", &VWNN3, "");
  VWNN3 = Qt;
#endif
#ifdef WNN4V3
  DEFVAR_LISP ("WNN4V3", &VWNN4V3, "");
  VWNN4V3 = Qt;
#endif
#ifdef WNN4
  DEFVAR_LISP ("WNN4", &VWNN4, "");
  VWNN4 = Qt;
#endif
#ifdef SJ3
  DEFVAR_LISP ("SJ3", &VSJ3, "");
  VSJ3 = Qt;
#endif
#ifdef	CANNA
  DEFVAR_LISP ("CANNA", &VCANNA, "");
  VCANNA = Qt;
#endif
}

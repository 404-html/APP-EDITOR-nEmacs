/* 88.1.3  modified for Nemacs Ver.2.0 by K.Handa */
/* 88.6.1  modified for Nemacs Ver.2.1 by K.Handa */
/* 89.9.19 modified for Nemacs Ver.3.2 by K.Handa */

/* Declarations having to do with GNU Emacs syntax tables.
   Copyright (C) 1985 Free Software Foundation, Inc.

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

extern Lisp_Object Qsyntax_table_p;
extern Lisp_Object Fsyntax_table_p (), Fsyntax_table (), Fset_syntax_table ();

/* The standard syntax table is stored where it will automatically
   be used in all new buffers.  */
#define Vstandard_syntax_table buffer_defaults.syntax_table

/* A syntax table is a Lisp vector of length 0400, whose elements are integers.

The low 8 bits of the integer is a code, as follows:
*/

enum syntaxcode
  {
    Swhitespace, /* for a whitespace character */
    Spunct,	 /* for random punctuation characters */
    Sword,	 /* for a word constituent */
    Ssymbol,	 /* symbol constituent but not word constituent */
    Sopen,	 /* for a beginning delimiter */
    Sclose,      /* for an ending delimiter */
    Squote,	 /* for a prefix character like Lisp ' */
    Sstring,	 /* for a string-grouping character like Lisp " */
    Smath,	 /* for delimiters like $ in Tex. */
    Sescape,	 /* for a character that begins a C-style escape */
    Scharquote,  /* for a character that quotes the following character */
    Scomment,    /* for a comment-starting character */
    Sendcomment, /* for a comment-ending character */
#ifdef NEMACS  /* 89.10.19  by K.Handa */
    Sjapanese,	 /* for a first char of Japanese code */
#endif
    Smax	 /* Upper bound on codes that are meaningful */
  };

#define SYNTAX(c) \
  ((enum syntaxcode) (XINT (XVECTOR (current_buffer->syntax_table)->contents[(unsigned char) (c)]) & 0377))

#ifdef NEMACS  /* 88.1.5, 89.9.17, 89.10.19  by K.Handa */
enum categorycode {
  /* For 1-byte code */
  Cwhitespace,	/* for a whitespace character */
  Cpunct,	/* for random punctuation characters */
  Cword,	/* for a word constituent */
  Csymbol,	/* symbol constituent but not word constituent */
  Copen,	/* for a beginning delimiter */
  Cclose,	/* for an ending delimiter */
  Cquote,	/* for a prefix character like Lisp ' */
  Cstring,	/* for a string-grouping character like Lisp " */
  Cmath,	/* for delimiters like $ in Tex. */
  Cescape,	/* for a character that begins a C-style escape */
  Ccharquote,	/* for a character that quotes the following character */
  Ccomment,	/* for a comment-starting character */
  Cendcomment,	/* for a comment-ending character */
  /* For Japanese code */
  CJsymbol,
  CJundef,
  CJalpha,
  CJhira,
  CJsphira,
  CJkata,
  CJspkata,
  CJgreek,
  CJrussian,
  CJkanji,
  CJspkanji,
  Cmax		/* Upper bound on codes that are meaningful */
};

extern unsigned char category_table[0400];	/* patch by sanewo  88.5.25 */
extern unsigned char ex_category_table[0200];
#define CATEGORY(c1, c2) \
  (((SYNTAX(c1)==Sjapanese) && (SYNTAX(c2)==Sjapanese) \
			? ((c1 == 0xa1) \
			  ? (enum categorycode) ex_category_table[c2 & 0177] \
			  : (enum categorycode) category_table[c1]) \
			: (enum categorycode) SYNTAX(c1)))
#define CTGJCODE(ctg) ((int)ctg >= (int)CJsymbol && (int)ctg < (int)Cmax)
#define CTGHIRA(ctg) \
  ((enum categorycode)ctg == CJhira || (enum categorycode)ctg == CJsphira)
#define CTGKATA(ctg) \
  ((enum categorycode)ctg == CJkata || (enum categorycode)ctg == CJspkata)
#define CTGKANJI(ctg) \
  ((enum categorycode)ctg == CJkanji || (enum categorycode)ctg == CJspkanji)
#define CTGSPECIAL(ctg) \
  ((enum categorycode)ctg == CJsphira \
   || (enum categorycode)ctg == CJspkata \
   || (enum categorycode)ctg == CJspkanji)
#define CTGJWORD(ctg) ((int)ctg > (int)CJundef && (int)ctg < (int)Cmax)
#define CTGWORD(ctg) ((enum categorycode)ctg == Cword || CTGJWORD (ctg))
#define CTGEXTEND(ctg) (ctg = (enum categorycode) ((int)ctg - CTGSPECIAL(ctg)))
#endif  /* NEMACS */

/* The next 8 bits of the number is a character,
 the matching delimiter in the case of Sopen or Sclose. */

#define SYNTAX_MATCH(c) \
  ((XINT (XVECTOR (current_buffer->syntax_table)->contents[(unsigned char) (c)]) >> 8) & 0377)

/* Then there are four single-bit flags that have the following meanings:
  1. This character is the first of a two-character comment-start sequence.
  2. This character is the second of a two-character comment-start sequence.
  3. This character is the first of a two-character comment-end sequence.
  4. This character is the second of a two-character comment-end sequence.
 Note that any two-character sequence whose first character has flag 1
  and whose second character has flag 2 will be interpreted as a comment start. */

#define SYNTAX_COMSTART_FIRST(c) \
  ((XINT (XVECTOR (current_buffer->syntax_table)->contents[(unsigned char) (c)]) >> 16) & 1)

#define SYNTAX_COMSTART_SECOND(c) \
  ((XINT (XVECTOR (current_buffer->syntax_table)->contents[(unsigned char) (c)]) >> 17) & 1)

#define SYNTAX_COMEND_FIRST(c) \
  ((XINT (XVECTOR (current_buffer->syntax_table)->contents[(unsigned char) (c)]) >> 18) & 1)

#define SYNTAX_COMEND_SECOND(c) \
  ((XINT (XVECTOR (current_buffer->syntax_table)->contents[(unsigned char) (c)]) >> 19) & 1)

/* This array, indexed by a character, contains the syntax code which that
 character signifies (as a char).  For example,
 (enum syntaxcode) syntax_spec_code['w'] is Sword. */

extern unsigned char syntax_spec_code[0400];

#ifdef NEMACS  /* 88.1.17, 88.6.2, 89.9.19  by K.Handa */
extern char category_spec_code[0200];
#endif  /* NEMACS */

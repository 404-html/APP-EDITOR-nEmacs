/* kconv.c -  Japanese code converter
   between two of EUC, JIS, and Shift-JIS code.
   written by K.Handa  89.5.25 */

#include <stdio.h>
#include "../src/kanji.h"

#define TOK1 '$'
#define TOK2 '@'
#define TOA1 '('
#define TOA2 'J'

unsigned char i1, i2, c1, c2;

js(i1, i2, c1, c2)
     unsigned char i1, i2, *c1, *c2;
{
  J2S(i1, i2, *c1, *c2)
}

je(i1, i2, c1, c2)
     unsigned char i1, i2, *c1, *c2;
{
  *c1 = i1 | 0x80; *c2 = i2 | 0x80;
}
     
sj(i1, i2, c1, c2)
     unsigned char i1, i2, *c1, *c2;
{
  S2J(i1, i2, *c1, *c2)
}

ej(i1, i2, c1, c2)
     unsigned char i1, i2, *c1, *c2;
{
  *c1 = i1 & 0x7f; *c2 = i2 & 0x7f;
}

es(i1, i2, c1, c2)
     unsigned char i1, i2, *c1, *c2;
{
  E2S(i1, i2, *c1, *c2)
}

se(i1, i2, c1, c2)
     unsigned char i1, i2, *c1, *c2;
{
  S2E(i1, i2, *c1, *c2)
}

j2some(f)
     int (*f)();
{
  int kanji = 0;

  while ((char)(i1 = getchar()) != EOF) {
    if (kanji) {
      if (i1 == ESC_CODE) {
	if ((i1 = getchar()) == TOA1) {
	  getchar(); kanji = 0;
	} else {
	  putchar(ESC_CODE); ungetc(i1,stdin);
	}
      } else if (0x21 <= i1 && i1 <= 0x7e) {
	f(i1, getchar(), &c1, &c2); putchar(c1); putchar(c2);
      } else
	putchar(i1);
    } else {
      if (i1 == ESC_CODE) {
	if ((i1 = getchar()) == TOK1) {
	  getchar(); kanji = 1;
	} else {
	  putchar(ESC_CODE); ungetc(i1,stdin);
	}
      } else
	putchar(i1);
    }
  }
}

some2j(f)
     int (*f)();
{
  int kanji = 0;

  while ((char)(i1 = getchar()) != EOF) {
    if (kanji) {
      if (i1 & 0x80) {
	f(i1, getchar(), &c1, &c2);
	putchar(c1); putchar(c2);
      } else {
	putchar(ESC_CODE); putchar(TOA1); putchar(TOA2);
	putchar(i1);
	kanji = 0;
      }
    } else {
      if (i1 & 0x80) {
	putchar(ESC_CODE); putchar(TOK1); putchar(TOK2);
	f(i1, getchar(), &c1, &c2);
	putchar(c1); putchar(c2);	  
	kanji = 1;
      } else
	putchar(i1);
    }
  }
}

eands(f)
     int (*f)();
{
  while ((char)(i1 = getchar()) != EOF) {
    if (i1 & 0x80) {
      f(i1, getchar(), &c1, &c2);
      putchar(c1); putchar(c2);
    } else
      putchar(i1);
  }
}

main(argc, argv)
     int argc;
     char **argv;
{
  int type;

  argv++;
  switch (*(*argv)++) {
  case 'j':
    j2some((**argv == 's') ? js : je);
    break;
  case 's':
    if (**argv == 'j') some2j(sj);
    else eands(se);
    break;
  case 'e':
    if (**argv == 'j') some2j(ej);
    else eands(es);
    break;
  default:
    fprintf(stderr, "Usage: kconv {js,sj,je,ej,es,se} < source > target\n");
  }
}

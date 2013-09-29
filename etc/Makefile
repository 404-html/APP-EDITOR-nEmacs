# Modified for Nemacs Ver.3.2  89.9.6  by K.Handa
# 'kconv' is included in $(EXECUTABLES)

CC= gcc
/*CFLAGS= -g*/
CFLAGS= -O2 -DOS2
# For Xenix.  Needed for movemail
#  LOADLIBES= -lx
# For Mips.  Needed for who knows what.
#  CFLAGS = -g -systype bsd43

EXECUTABLES = test-distrib.exe etags.exe ctags.exe wakeup.exe make-docfile.exe \
   digest-doc.exe sorted-doc.exe movemail.exe cvtmail.exe fakemail.exe yow.exe env.exe \
   server.exe emacsclient.exe

all: $(EXECUTABLES)

#clean:
#	-rm -f ${EXECUTABLES} core
#
#distclean:
#	-rm -f ${EXECUTABLES} *~ \#* DOC* core

# This justs verifies that the non-ASCII characters
# in the file `testfile' have no been clobbered by
# whatever means were used to copy and distribute Emacs.
# If they were clobbered, all the .elc files were clobbered too.
test-distrib.exe: test-distrib.c
	$(CC) -o test-distrib.exe test-distrib.c
	./test-distrib

etags.exe: etags.c
	$(CC) -o etags.exe $(CFLAGS) -DETAGS etags.c $(LOADLIBES)

ctags.exe: etags.c
	$(CC) -o ctags.exe $(CFLAGS) -DCTAGS etags.c $(LOADLIBES)

wakeup.exe: wakeup.c
	$(CC) -o wakeup.exe $(CFLAGS) wakeup.c $(LOADLIBES)

make-docfile.exe: make-docfile.c
	$(CC) -o make-docfile.exe $(CFLAGS) make-docfile.c $(LOADLIBES)

digest-doc.exe: digest-doc.c
	$(CC) -o digest-doc.exe $(CFLAGS) digest-doc.c $(LOADLIBES)

sorted-doc.exe: sorted-doc.c
	$(CC) -o sorted-doc.exe $(CFLAGS) sorted-doc.c $(LOADLIBES)

#
movemail.exe: movemail.c ../src/config.h
#	@echo Can't create movemail.exe !!!
#	$(CC) -o movemail.exe $(CFLAGS) movemail.c $(LOADLIBES)

cvtmail.exe: cvtmail.c
#	@echo Can't create cvtmail.exe !!!
#	$(CC) -o cvtmail ${CFLAGS} cvtmail.c $(LOADLIBES)

fakemail.exe: fakemail.c ../src/config.h
#	@echo Can't create fakemail.exe !!!
#	$(CC) -o fakemail ${CFLAGS} fakemail.c $(LOADLIBES)

yow.exe: yow.c ../src/paths.h
	$(CC) -o yow.exe $(CFLAGS) yow.c $(LOADLIBES)

# this is silly -- just use emacs to edit this file!
# (in any case this program doesn't preserve alphabetical ordering,
#  which is why I'm removing it)
#addyow: addyow.c
#	$(CC) -o addyow $(CFLAGS) addyow.c

env.exe: env.c ../src/config.h
	$(CC) -o env.exe -DEMACS $(CFLAGS) env.c $(LOADLIBES)

server.exe: server.c ../src/config.h
	$(CC) -o server.exe $(CFLAGS) server.c $(LOADLIBES) -los2

emacsclient.exe: emacsclient.c ../src/config.h
	$(CC) -o emacsclient.exe $(CFLAGS) emacsclient.c $(LOADLIBES) -los2

# This one is NOT included in EXECUTABLES.
# See ../src/ymakefile.
emacstool.exe: emacstool.c
	$(CC) emacstool.c -o emacstool.exe -g -lsuntool -lsunwindow -lpixrect $(LOADLIBES)

kconv: ../src/kanji.h kconv.c
	$(CC) -o kconv ${CFLAGS} kconv.c

nemacstool.exe: emacstool.c
	$(CC) -o nemacstool.exe -g -DJLE $(CFLAGS) emacstool.c -lsuntool -lmle -lsunwindow -lpixrect $(LOADLIBES)	# For SUN Japanese Language Environment

xvetool.exe: emacstool.c
	$(CC) -o xvetool.exe -g -DXVIEW $(CFLAGS) emacstool.c -lxview -lX -I$(OPENWINHOME)/include -L$(OPENWINHOME)/lib $(LOADLIBES)

xveterm: emacstool.c
	$(CC) -o xveterm ${CFLAGS} -DXVIEW -DTTERM emacstool.c -lxview -lolgx -lX -I$(OPENWINHOME)/include -L$(OPENWINHOME)/lib $(LOADLIBES)



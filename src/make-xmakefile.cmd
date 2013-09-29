rem $(CPP) junk.c | sed -e 's/^#.*//' -e 's/^[ 	][ 	]*$$//' -e 's/^ /	/' | sed -n -e '/^..*$$/p' > xmakefile
gcc -E -DOS2 junk.c | sed -e "s/^#.*//" -e "s/^[ 	][ 	]*$//" -e "s/^ /	/" | sed -n -e "/^..*$/p" > xmakefile

#include <stdio.h>

#define	BUFF_SIZE	2048

int	link(name1, name2)
char	*name1, *name2 ;
{
	FILE	*ifp, *ofp ;
	int	cnt ;
	char	buff[BUFF_SIZE] ;

	if ((ifp = fopen(name1, "rb")) == NULL) {
		return	-1 ;
	}
	if ((ofp = fopen(name2, "wb")) == NULL) {
		fclose(ifp) ;
		return	-1 ;
	}

	while((cnt = fread(buff, BUFF_SIZE, 1, ifp)) == BUFF_SIZE) {
		fwrite(buff, BUFF_SIZE, 1, ofp) ;
	}
	if (cnt > 0) {
		fwrite(buff, BUFF_SIZE, 1, ofp) ;
	}

	fclose(ifp) ;
	fclose(ofp) ;

	return	0 ;
}

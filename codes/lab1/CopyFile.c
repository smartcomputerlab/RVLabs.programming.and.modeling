#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
int fdr,fdw,nb; char buff[512];
fdr=open(argv[1],0);
fdw=creat(argv[2],0777);
while(nb=read(fdr,buff,512)) write(fdw,buff,nb);
close(fdr);close(fdw);
return 0;
}


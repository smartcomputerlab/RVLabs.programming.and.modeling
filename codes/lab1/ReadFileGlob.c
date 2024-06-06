#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
char buff[512];
int fd,nb;
int main(int argc, char **argv)
{
fd=open(argv[1],0);
nb=read(fd,buff,512);
write(1,buff,nb);
close(fd);
return 0;
}

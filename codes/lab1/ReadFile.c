#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
int fd,nb; char buff[512];
fd=open(argv[1],0);
nb=read(fd,buff,512);
write(1,buff,nb);
close(fd);
return 0;
}


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#define BUFLEN 512
// Max length of buffer
#define PORT 8889
// The port on which to send or listen for data
#define REMOTE_ADDR "172.19.71.21"
int main(void)
{
struct sockaddr_in si_me, si_other;
int s;
char buf[BUFLEN];
s=socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
// this structure and bind() are optional for first sender
// the receiver can extract the sender socket
memset((char *) &si_me,0x00,16);
si_me.sin_family = AF_INET;
si_me.sin_port = htons(PORT);
si_me.sin_addr.s_addr = htonl(INADDR_ANY);
// bind socket to port
bind(s,(struct sockaddr*)&si_me,16);
// zero out the structure other (receiver) - this structure is mandatory
memset((char *)&si_other,0x00,16);
si_other.sin_family = AF_INET;
si_other.sin_port = htons(PORT); // to work globally
//si_other.sin_port = htons(PORT+1); // to work locally
//si_other.sin_addr.s_addr = htonl(INADDR_ANY); // to work locally
si_other.sin_addr.s_addr = inet_addr(REMOTE_ADDR); // to work globally
//keep sending data
while(1)
{
printf("write the message\n");scanf("%s",buf);
// try to send data, this is a non blocking call
sendto(s,buf,strlen(buf)+1,0,(struct sockaddr *)&si_other,16);
}
close(s);
return 0;
}

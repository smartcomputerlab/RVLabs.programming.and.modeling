// tcprecv.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#define BUFLEN 512
#define PORT 8899
// Max length of buffer
// The port on which to listen for connection
int main(void)
{
struct sockaddr_in si_me, si_other;
int s,ns, nb, slen = sizeof(si_other);
char buf[BUFLEN];
s=socket(AF_INET, SOCK_STREAM, 0);
memset((char *) &si_other, 0, sizeof(si_other));
si_me.sin_family = AF_INET;
si_me.sin_port = htons(PORT);
si_me.sin_addr.s_addr = htonl(INADDR_ANY);
// Bind is mandatory for the server
bind(s,(struct sockaddr *)&si_me , sizeof(si_me));
listen(s,5);
// log length
while(1)
{
//Accept and incoming connection
puts("Waiting for incoming connections...");
ns=accept(s, (struct sockaddr *)&si_other,(socklen_t*)&slen);
if (ns<0) { puts("accept failed"); continue; }
else puts("Connection accepted");
while(1)
{
memset(buf,0x00,BUFLEN);
nb=read(ns,buf,BUFLEN);
printf("Got message %d bytes: %s\n",nb,buf); if(nb==0) break;
if(buf[0]=='.') { printf("session ended\n");break;}
}
close(ns); // close the working socket
}
close(s);
}

#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void mysig(int sig)
{
printf("SIGINT\n");
}
int main()
{
	signal(SIGINT,mysig);
	while(1)
	{
		sleep(3);
	}
}

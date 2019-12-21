/* vim: set ts=4 sw=4: */
/* Filename    : sig_basic.c
 * Description : simple signal model
 * Author      : SunYoung Kim <sunyzero@yahoo.com>
 * Notes       : sigaction & signal mask
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>

void chk_sigusr(int signum);

int main()
{
	struct sigaction sa_usr1;
	struct sigaction sa_usr2;

	memset(&sa_usr1, 0, sizeof(struct sigaction));
	sa_usr1.sa_handler = chk_sigusr;
	sigfillset(&sa_usr1.sa_mask);	/* blocking signal. So it can't be allowed interrupted by other signal */
#ifdef WITH_SA_NOMASK
	sa_usr1.sa_flags = SA_NODEFER;
#endif

	memset(&sa_usr2, 0, sizeof(struct sigaction));
	sa_usr2.sa_handler = chk_sigusr;
	sigemptyset(&sa_usr2.sa_mask);	/* empty signal mask, so other process can interrupt when is running this handler */
#ifdef WITH_SA_NOMASK
	sa_usr2.sa_flags = SA_NODEFER;
#endif

	sigaction(SIGUSR1, &sa_usr1, NULL);
	sigaction(SIGUSR2, &sa_usr2, NULL);
	printf("[MAIN] SIGNAL Handler installed\n");
	/* USR1 �� ���, �ñ׳� �Ž�ũ�� ä���� �����Ƿ� USR1 �ñ׳� ó���Ⱑ ����Ǵ� ���� 
	   �ٸ� �ñ׳��� ����ϰ� �ȴ�. ���� USR1 �ñ׳� ó���� �����ڿ� �ٸ� �ñ׳��� ����ȴ�.
	   ������, USR2 �� �ñ׳� �Ž�ũ�� ��������Ƿ� ��� �ñ׳��� ����ϰ� �ǰ�,
	   ó���Ⱑ ����Ǵ� ���߿� �ٸ� �ñ׳��� �����ϸ� ��� �����ϰ� ������ �ñ׳� �ڵ鷯�� ����ȴ�.
	 */
	printf("[MAIN] pid is %d\n", getpid());
	for(;;) {
		pause();
		printf("[MAIN] Recv SIGNAL...\n");
	}
	return EXIT_SUCCESS;
}

/* Name : signal handler func about SIGUSR1 & SIGUSR2
 * Desc : sleep 10 sec & print message every second.
 * Argv : 
 * Ret  : None
 */
void chk_sigusr(int signum)
{
	int	i;
	for (i=0; i<10; i++) {
		printf("\tSignal(%s):%d sec.\n", signum == SIGUSR1 ? "USR1":"USR2", i);
		sleep(1);
	}
}

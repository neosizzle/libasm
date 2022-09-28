#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
extern size_t ft_strlen(char *str);

int	main(int argc, char **argv)
{
	char *str = "13123s的发射点发射点发生12313";

	int ret = ft_strlen(str);
	// int ret = 12;
	printf("ret %d, theirs %ld\n", ret, strlen(str));
	return 0;
}

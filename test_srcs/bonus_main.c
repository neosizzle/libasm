# include <stdio.h>
# include <string.h>
# include <unistd.h>
# include <errno.h>
# include <fcntl.h>
extern	int	ft_atoi_base(char *str, char *base);

int	main(int argc, char **argv)
{
	int res = ft_atoi_base("-12", "0123456789");
	printf("res : %d\n", res);
	return 0;
}

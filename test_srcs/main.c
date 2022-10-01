# include <stdio.h>
# include <string.h>
# include <unistd.h>
# include <errno.h>
# include <fcntl.h>
extern size_t ft_strlen(char *str);
extern  char *ft_strcpy(char * dest, const char *src);
extern	int ft_strcmp(const char *s1, const char *s2);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern	char *ft_strdup(const char *s);


int	main(int argc, char **argv)
{
	// char *src = "Hello world\n";
	// char *dst = ft_strdup(src);
	// printf("src %s, dst %s\n", src, dst);
	int ret = ft_write(1, "", 0);
	printf("ret %d\n", ret);
	return 0;
}

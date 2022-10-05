#include "main.h"

static void strlencmp(char *str)
{
	if (ft_strlen(str) == strlen(str)) 
		ok();
	else
	{
		ko();
	}
}

static void strcpycmp(char *src)
{
	char *dest = malloc(1024);
	char *ret_mine = strcpy(dest, src);
	char *ret_theirs = strcpy(dest, src);
	if (!strcmp(ret_mine, ret_theirs) && dest == ret_mine) 
		ok();
	else
		ko();
	free(dest);
}

static void strcmpcmp(char *s1, char *s2)
{
	int expected = strcmp(s1, s2);
	int actual = ft_strcmp(s1, s2);
	if ( (actual == 0 && expected == 0 ) || (actual > 0 && expected > 0 ) || (actual < 0 && expected < 0 )) 
		ok();
	else
	{
		ko();
	}
}

static void writecmp(int fd, char *str, int strlen)
{
	char *actual_buff = calloc(1024, 1);
	int actual_ret = ft_write(fd, str, strlen);
	int actual_errno = errno;
	int readret= read(fd, actual_buff, strlen);

	char *expected_buff = calloc(1024, 1);
	int expected_ret = write(fd, str, strlen);
	int expected_errno = errno;
	read(fd, expected_buff, strlen);

	if ( (strcmp(actual_buff, expected_buff) == 0) && actual_ret == expected_ret && actual_errno == expected_errno) 
	{
		ok();
	}
	else
	{
		ko();
		printf("actual %d, expected %d\n", actual_ret, expected_ret);
	}
	free(actual_buff);
	free(expected_buff);
}

static void readcmp (int fd, int strlen)
{
	lseek(fd, 0, SEEK_SET);
	char *expected_buff = calloc(1024, 1);
	int expected_ret = read(fd, expected_buff, strlen);
	int expected_errno = errno;

	lseek(fd, 0, SEEK_SET);
	char *actual_buff = calloc(1024, 1);
	int actual_ret = ft_read(fd, actual_buff, strlen);
	int actual_errno = errno;


	if ( (strcmp(actual_buff, expected_buff) == 0) && actual_ret == expected_ret && actual_errno == expected_errno) 
	{
		ok();
	}
	else
	{
		ko();
		printf("%s, %s \n", expected_buff, actual_buff);
	}
	free(actual_buff);
	free(expected_buff);
}

static void strdupcmp(char *src)
{
	char *ret_mine = ft_strdup(src);
	char *ret_theirs = strdup(src);
	if (!strcmp(ret_mine, ret_theirs)) 
		ok();
	else
		ko();
	free(ret_mine);
	free(ret_theirs);
}

int	main(int argc, char **argv)
{
	printf("%s=========ft_strlen=======%s\n", GREEN, NC);
	strlencmp("hello");
	strlencmp("HMMMMHMMMMHMMMMHMMMMHMMMMHMMMM");
	strlencmp("");
	strlencmp("\n\n");
	strlencmp("你好");


	printf("%s=========ft_strcpy=======%s\n", GREEN, NC);
	strcpycmp("hello");
	strcpycmp("HMMMMHMMMMHMMMMHMMMMHMMMMHMMMM");
	strcpycmp("");
	strcpycmp("\n\n");
	strcpycmp("你好");

	printf("%s=========ft_strcmp=======%s\n", GREEN, NC);
	strcmpcmp("hello", "hello");
	strcmpcmp("hello", "helloo");
	strcmpcmp("hellooo", "hello");
	strcmpcmp("hellooo", "");
	strcmpcmp("", "hello");
	strcmpcmp("你好", "asdf");

	printf("%s=========ft_write=======%s\n", GREEN, NC);
	writecmp(1, "This is test write to stdout.. press Enter..", 45);
	int tmpfile = open("test_srcs/tmp/io.tmp", O_RDWR | O_CREAT,  0644);
	writecmp(tmpfile, "hellollollollollollollollo", 5);
	writecmp(tmpfile, "", 1);
	writecmp(tmpfile, "你好", 2);
	writecmp(5, "asdasdasd", 10);
	close(tmpfile);

	printf("%s=========ft_read=======%s\n", GREEN, NC);
	tmpfile = open("test_srcs/tmp/io.tmp", O_RDONLY);
	readcmp(0, 1024);
	readcmp(tmpfile, 5);
	readcmp(tmpfile, 1);
	readcmp(tmpfile, 2);
	readcmp(5, 10);
	close(tmpfile);
	remove("test_srcs/tmp/io.tmp");

	printf("%s=========ft_strdup=======%s\n", GREEN, NC);
	strdupcmp("hello");
	strdupcmp("HMMMMHMMMMHMMMMHMMMMHMMMMHMMMM");
	strdupcmp("");
	strdupcmp("\n\n");
	strdupcmp("你好");



	return 0;
}

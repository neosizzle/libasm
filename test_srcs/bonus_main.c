#include "main.h"

static void free_fct (void * ptr){  }

static char * list_to_str(t_list *head) {
	char *res = calloc(2048, 1);

	while (head)
	{
		strcat(res, (char *)head->data);
		strcat(res, "\n");
		head = head->next;
	}
	return res;
}

static void	ft_list_clear(t_list *begin_list, void (*free_fct)(void *))
{
	if (!begin_list)
		return ;
	ft_list_clear(begin_list->next, free_fct);
	free_fct(begin_list->data);
	free(begin_list);
	return ;
}

static void atoibasecmp(char *str, char *base)
{
	if (ft_atoi_base(str, base) == ref_ft_atoi_base(str, base))
		ok();
	else
	{
		ko();
		printf("expected %d, actual %d\n", ref_ft_atoi_base(str, base),ft_atoi_base(str, base));
	}
}

static void listcmp(t_list *actual, t_list *expected)
{
	char *act_str =  list_to_str(actual);
	char *exp_str =  list_to_str(expected);
	if (!strcmp(act_str,exp_str))
		ok();
	else
	{
		ko();
	}
	free(act_str);
	free(exp_str);
}

static void listsizecmp(t_list *actual, t_list *expected)
{
	int act =  ft_list_size(actual);
	int exp = ref_ft_list_size(expected);
	if (act == exp)
		ok();
	else
	{
		ko();
		printf("actual %d, expected %d\n", act, exp);
	}
}


int	main(int argc, char **argv)
{
	printf("%s=========ft_atoi_base=======%s\n", GREEN, NC);
	atoibasecmp("123", "0123456789");
	atoibasecmp("+123", "0123456789");
	atoibasecmp("-123", "0123456789");
	atoibasecmp("  123", "0123456789");
	atoibasecmp("++123", "0123456789");
	atoibasecmp("--123", "0123456789");
	atoibasecmp("-+123", "0123456789");
	atoibasecmp("+-123", "0123456789");
	atoibasecmp("+-    123", "0123456789");
	atoibasecmp("    12-3", "0123456789");
	atoibasecmp("haha", "0123456789");
	atoibasecmp("101010100101", "01");
	atoibasecmp("112", "01");
	atoibasecmp("112", "0112");
	atoibasecmp("qowuyereeee", "qwertyuiop");
	atoibasecmp("69", "420");


	printf("%s=========ft_list_push_front=======%s\n", GREEN, NC);
	t_list *actual = NULL;
	t_list *expected = NULL;

	ft_list_push_front(&actual, "first");
	ref_ft_list_push_front(&expected, "first");

	listcmp(actual, expected);

	ft_list_push_front(&actual, "first");
	ref_ft_list_push_front(&expected, "first");

	listcmp(actual, expected);

	ft_list_push_front(&actual, "actuallyfirst");
	ref_ft_list_push_front(&expected, "actuallyfirst");

	listcmp(actual, expected);

	ft_list_push_front(&actual, "siuu");
	ref_ft_list_push_front(&expected, "siuu");

	listcmp(actual, expected);

	printf("%s=========ft_list_size=======%s\n", GREEN, NC);
	listsizecmp(actual, expected);

	ft_list_push_front(&actual, "first");
	ft_list_push_front(&expected, "first");

	listsizecmp(actual, expected);
	listsizecmp(0, 0);

	printf("%s=========ft_list_sort=======%s\n", GREEN, NC);

	ft_list_sort(&actual, strcmp);
	ref_ft_list_sort(&expected, strcmp);

	listcmp(actual, expected);

	printf("%s=========ft_list_remove_if=======%s\n", GREEN, NC);

	ft_list_remove_if(&actual, "first", strcmp, free_fct);
	ref_ft_list_remove_if(&expected, "first", strcmp, free_fct);

	listcmp(actual, expected);

	ft_list_remove_if(&actual, "first", strcmp, free_fct);
	ref_ft_list_remove_if(&expected, "first", strcmp, free_fct);

	listcmp(actual, expected);

	ft_list_remove_if(&actual, "siuu", strcmp, free_fct);
	ref_ft_list_remove_if(&expected, "siuu", strcmp, free_fct);

	listcmp(actual, expected);

	ft_list_remove_if(&actual, "siudu", strcmp, free_fct);
	ref_ft_list_remove_if(&expected, "siudu", strcmp, free_fct);

	listcmp(actual, expected);
	ft_list_clear(actual, free_fct);
	ft_list_clear(expected, free_fct);
	return 0;
}

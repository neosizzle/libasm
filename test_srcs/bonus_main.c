# include <stdio.h>
# include <string.h>
# include <unistd.h>
# include <errno.h>
# include <stdlib.h>

typedef struct		s_list
{
	void			*data;
	struct s_list	*next;
}					t_list;

extern	int	ft_atoi_base(char *str, char *base);
extern void ft_list_push_front(t_list **begin_list, void *data);
extern int 	ft_list_size(t_list *begin_list);
extern int ft_list_sort(t_list **begin_list, int (*cmp)());
// extern int ref_ft_list_sort(t_list **begin_list, int (*cmp)());

static void	ref_ft_list_sort(t_list **begin_list, int (*cmp)())
{
	void	*temp;
	t_list	*curr;

	if (!begin_list || !*begin_list)
		return ;
	curr = *begin_list;
	while (curr->next)
	{
		if (cmp(curr->data, curr->next->data) > 0)
			{
				temp = curr->data;
				curr->data = curr->next->data;
				curr->next->data = temp;
				curr = *begin_list;
			}
		else
			curr = curr->next;
	}
}


static void print_list(t_list *head) {
	while (head)
	{
		printf("%s\n", (char *)head->data);
		head = head->next;
	}
	printf("\n");
}

int	main(int argc, char **argv)
{
	// t_list * list = malloc(sizeof (t_list));
	// list->data = strdup("second");
	// list->next = NULL;
	t_list *list = NULL;

	t_list **head = &list;

	ft_list_push_front(&list, strdup("first"));
	ft_list_push_front(&list, strdup("sec"));
	ft_list_push_front(&list, strdup("thirds"));
	ft_list_push_front(&list, strdup("thirds"));
	print_list(list);

	ft_list_sort(&list, strcmp);
	print_list(list);
	return 0;
}

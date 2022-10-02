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


int	main(int argc, char **argv)
{
	t_list * list = malloc(sizeof (t_list));
	list->data = strdup("second");
	list->next = NULL;

	t_list **head = &list;
	// list->num = 696969;
	// list->somechar = 'P';
	// printf("first data b4 |%s| \n", (char *)(*head)->data);

	ft_list_push_front(head, strdup("asdf"));
	printf("first data |%s| \n", (char *)(*head)->data);
	printf("2nd data |%s| \n", (char *)(*head)->next->data);
	ft_list_push_front(head, strdup("asdf"));
	ft_list_push_front(head, strdup("asdf"));
	ft_list_push_front(head, strdup("asdf"));
	printf("size %d\n", ft_list_size(*head));
	return 0;
}

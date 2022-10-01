# include <stdio.h>
# include <string.h>
# include <unistd.h>
# include <errno.h>
# include <stdlib.h>

typedef struct		s_list
{
	int				num;
	char			somechar;
	void			*data;
	struct s_list	*next;
}					t_list;

extern	int	ft_atoi_base(char *str, char *base);
extern void ft_list_push_front(t_list **begin_list, void *data);


int	main(int argc, char **argv)
{
	t_list * list = malloc(sizeof (t_list));
	list->data = strdup("test");
	list->next = NULL;
	list->num = 696969;
	list->somechar = 'P';
	ft_list_push_front(&list, "asdf");
	return 0;
}

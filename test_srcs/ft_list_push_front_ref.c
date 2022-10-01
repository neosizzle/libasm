# include <stdio.h>
# include <string.h>
# include <unistd.h>
# include <errno.h>
# include <fcntl.h>

typedef struct		s_list
{
	void			*data;
	struct s_list	*next;
}					t_list;

void ref_ft_list_push_front(t_list **begin_list, void *data)
{
	if (begin_list == NULL)
		return ;
	t_list *new = malloc(sizeof(t_list));
	if (new == NULL)
		return ;
	new->data = data;
	new->next = *begin_list;
	*begin_list = new;
}
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
extern void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)()
, void (*free_fct)(void *));

//GLOBAL VARS
//g_prev keeps track of the previouse node
//g_curr keeps track of the current node
t_list	*g_prev;
t_list	*g_curr;

//helper func to free current node and curr node data
static	void	free_curr(void (*free_fct)(void *))
{
	free_fct(g_curr->data);
	free(g_curr);
}

//helper function to move curr node forwars
//and set prev node
static void	move_forward(void)
{
	g_prev = g_curr;
	g_curr = g_curr->next;
}


void	ref_ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)()
, void (*free_fct)(void *))
{
	t_list	*temp;

	g_curr = *begin_list;
	while (g_curr && cmp(g_curr->data, data_ref) == 0)
	{
		*begin_list = g_curr->next;
		free_curr(free_fct);
		g_curr = *begin_list;
	}
	if (!g_curr || !g_curr->next)
		return ;
	move_forward();
	while (g_curr)
	{
		if (cmp(g_curr->data, data_ref) == 0)
		{
			temp = g_curr->next;
			free_curr(free_fct);
			g_prev->next = temp;
			g_curr = temp;
		}
		else
			move_forward();
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

static void free_fct (void * ptr){ free(ptr); }

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

	// ft_list_remove_if(&list, "sec", strcmp, free_fct);
	ft_list_remove_if(&list, "thirds", strcmp, free_fct);


	print_list(list);
	return 0;
}

#include "main.h"

//helper function to check if base valid
static int	is_valid_base(char *base)
{
	int	i;
	int	j;

	i = 0;
	if (ft_strlen(base) < 2)
		return (0);
	while (base[i] != '\0')
	{
		j = i + 1;
		while (base[j] != '\0')
		{
			if (base[i] == base[j] || base[j] <= 32
			|| base[j] == '+' || base[j] == '-')
				return (0);
			j++;
		}
		i++;
	}
	return (1);
}

//helper function to determine if the char given
//is found in the base string
//if yes, return the pointer to the position
static char*	char_in_base(char *base, char *c)
{
	int	i;

	i = 0;
	while (base[i] != '\0')
	{
		if (base[i] == *c)
		{
			return (base + i);
		}
		i++;
	}
	return (0);
}

int	ref_ft_atoi_base(char *str, char *base)
{
	char*curr_ptr;
	int	polarity;
	int	res;

	if (is_valid_base(base) == 0) return (0);
	curr_ptr = str;
	polarity = 1;
	res = 0;
	while (*curr_ptr == ' ' || (*curr_ptr >= 9 && *curr_ptr <= 13))
		curr_ptr++;
	while (*curr_ptr == '+' || *curr_ptr == '-')
	{
		if (*curr_ptr == '-')
			polarity *= -1;
		curr_ptr++;
	}
	while (char_in_base(base, curr_ptr) != 0)
	{
		res *= strlen(base);
		res += (int)(char_in_base(base, curr_ptr) - base);
		curr_ptr++;
	}
	return (res * polarity);
}

void	ref_ft_list_push_front(t_list **begin_list, void *data)
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

int 	ref_ft_list_size(t_list *begin_list)
{
	int counter;

	counter = 0;
	while (begin_list != NULL)
	{
		counter++;
		begin_list = begin_list->next;
	}
	return counter;
}

void	ref_ft_list_sort(t_list **begin_list, int (*cmp)())
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
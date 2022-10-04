# include <stdio.h>
# include <string.h>
# include <unistd.h>
# include <errno.h>
# include <fcntl.h>
# include <stdlib.h>

void ok();
void ko();


extern size_t ft_strlen(char *str);
extern  char *ft_strcpy(char * dest, const char *src);
extern	int ft_strcmp(const char *s1, const char *s2);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern ssize_t ft_read(int fd, const void *buf, size_t count);
extern	char *ft_strdup(const char *s);


typedef struct		s_list
{
	void			*data;
	struct s_list	*next;
}					t_list;


extern	int	ft_atoi_base(char *str, char *base);
extern void ft_list_push_front(t_list **begin_list, void *data);
extern int 	ft_list_size(t_list *begin_list);
extern void ft_list_sort(t_list **begin_list, int (*cmp)());
extern void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)()
, void (*free_fct)(void *));

int	ref_ft_atoi_base(char *str, char *base);
void ref_ft_list_push_front(t_list **begin_list, void *data);
int 	ref_ft_list_size(t_list *begin_list);
void ref_ft_list_sort(t_list **begin_list, int (*cmp)());
void	ref_ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)()
, void (*free_fct)(void *));

#define RED "\033[0;31m" 
#define GREEN "\033[0;32m" 
#define YELLOW "\033[0;33m" 
#define BLUE "\033[0;34m" 
#define PURPLE "\033[0;35m" 
#define CYAN "\033[0;36m" 
#define NC "\033[0m"
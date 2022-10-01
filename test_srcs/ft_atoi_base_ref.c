//helper function to get string length
int	ft_strlen(char *str)
{
	int	res;

	res = 0;
	while (str[res] != '\0')
		res++;
	return (res);
}

//helper function to check if base valid
int	is_valid_base(char *base)
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
char*	char_in_base(char *base, char *c)
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

int	ft_atoi_base(char *str, char *base)
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
		res *= ft_strlen(base);
		res += (int)(char_in_base(base, curr_ptr) - base);
		curr_ptr++;
	}
	return (res * polarity);
}

int main(int argc, char const *argv[])
{
	ft_atoi_base("-12", "0123456789");
	return 0;
}

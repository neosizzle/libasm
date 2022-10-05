SRCS = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
OBJS= ${SRCS:.s=.o}
SRCS_BONUS = ${SRCS} ft_atoi_base_bonus.s ft_list_push_front_bonus.s ft_list_size_bonus.s ft_list_sort_bonus.s ft_list_remove_if.s
OBJS_BONUS= ${SRCS_BONUS:.s=.o}
NASM = nasm
# NASM_FLAGS = -f elf64
NASM_FLAGS = -f macho64
ARRCS = ar rcs
NAME = libasm.a
TEST_EXEC = main

# Style constants
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
PURPLE=\033[0;35m
CYAN=\033[0;36m
NC=\033[0m # No Color

all : ${NAME}
	@echo "${RED}[FT_WARNING] For macOS, assemble with macho and remove .plt from source, add underscores in func names, the list goes on... should I make a macos ver?${NC}"

bonus : ${NAME} ${OBJS_BONUS}
	@echo "${GREEN}🔗  Linking library Bonus...${NC}"
	@${ARRCS} ${NAME} ${OBJS_BONUS}

${NAME}: ${OBJS}
	@echo "${GREEN}🔗  Linking library...${NC}"
	@${ARRCS} ${NAME} ${OBJS}

.s.o : 
	@echo "${GREEN}📇  Compiling $<..${NC}"
	@${NASM} ${NASM_FLAGS} $< -o ${<:.s=.o}

clean : 
	@echo "${YELLOW}🗑️  Removing ${OBJS}..${NC}"
	@rm -rf ${OBJS} ${OBJS_BONUS}

fclean : clean
	@echo "${YELLOW}🗑️  Removing ${NAME}..${NC}"
	@rm -rf ${NAME}
	@echo "${YELLOW}🗑️  Removing main..${NC}"
	@rm -rf ${TEST_EXEC}

test : ${NAME}
	@echo "${GREEN}📇  Compiling Test main..${NC}"
	@gcc test_srcs/main.c test_srcs/utils/*.c ./libasm.a -fsanitize=address -g3 -Itest_srcs/incs -L. -o  ${TEST_EXEC} && ./main 


test_bonus : bonus 
	@echo "${GREEN}📇  Compiling Test main bonus..${NC}"
	@gcc test_srcs/bonus_main.c test_srcs/bonus_funcs.c test_srcs/utils/*.c -Itest_srcs/incs -L. -lasm -o  ${TEST_EXEC} && ./main 

assemble :
	nasm -f elf64 -o data.o data.s

re : fclean all

.PHONY : re clean fclean all
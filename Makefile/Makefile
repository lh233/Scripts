#PWD = "shell pwd"

CC := arm-himix200-linux-gcc		
#shell pwd是比较好一点的
INC_DIR := $(shell pwd)/inc/
SRC_DIR := $(shell pwd)/
OBJ_DIR := $(shell pwd)/obj/
BIN_DIR := $(shell pwd)/bin/
LIB_DIR := $(shell pwd)/lib/

#目标文件名
TARGET  := $(BIN_DIR)/hifb


CFLAGS := -g
CFLAGS += -Wall
CFLAGS += -D_FORTIFY_SOURCE=2


#patsubst 是替换通配符，会把第一个%.c替换成第二个参数的%.c，
#wildcard 是把指定目录 $(SRC_DIR)下面的.c文件全部展开
#notdir 是把展开的文件去掉路径信息
SOURCES := $(patsubst %.c,%.c,$(notdir $(wildcard $(SRC_DIR)/*.c))) \

OBJECTS := $(addprefix $(OBJ_DIR)/, $(SOURCES:.c=.o))


.PHONY : clean all $(TARGET)  $(OBJECTS)

INCPATHS := \
	-I $(shell pwd)/../../inc \

LIBDIRS :=  \
    -L. \
    
LIBS := \
	-lpthread \

$(TARGET) : $(OBJECTS)
	@mkdir -p  $(BIN_DIR) 2> /dev/null
	$(CC)  -o $@ $(OBJECTS)
$(OBJECTS) : $(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR) 2> /dev/null
	$(CC) -c $(INCPATHS) $< -o $@

all: $(OBJECTS) $(TARGET)

clean:
	find ./ -name '*.*.swp' | xargs -I{} rm -f {}
	rm -f $(OBJECTS) $(TARGET) 
	rm -rf ${BIN_DIR} ${OBJ_DIR}

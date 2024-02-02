
CC = /root/tinalinux/prebuilt/gcc/linux-x86/aarch64/toolchain-sunxi-glibc/toolchain/bin/aarch64-openwrt-linux-g++

CFLAG += -I./include 

SOURCE = $(wildcard ./*.c)

APPOBJS = $(patsubst %.c,%.o,$(SOURCE))

APP = uart_test


$(APP): $(APPOBJS)
	$(CC) $^ -o $@

%.o : %.c
	$(CC) $(CFLAG) -c $^ -o $@

.PHONY : clean

clean:
	rm -f $(APP) $(APPOBJS)

exe := ass3

file1 := ass3
file2 := coroutines
file3 := scheduler
file4 := printer
file1_c := $(file1).c
file1_o := $(file1).o
file2_s := $(file2).s
file2_o := $(file2).o
file3_s := $(file3).s
file3_o := $(file3).o
file4_s := $(file4).s
file4_o := $(file4).o

#valgrind --leak-check=full myprog arg1 arg2


all: task1 task2 task3 task4 task5

task1:	
	nasm -f elf   $(file4_s) -o $(file4_o)

task2:	
	nasm -f elf   $(file3_s) -o $(file3_o)

task3:	
	nasm -f elf  $(file2_s) -o $(file2_o)
	


task4:	
	gcc -m32 -c -w $(file1_c) -o $(file1_o)
	
	
task5:	
	gcc -m32 $(file1_o)  $(file2_o) $(file3_o) $(file4_o) -o $(exe)
	

clean:
	rm *.o
	rm $(exe)
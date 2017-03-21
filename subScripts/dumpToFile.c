#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>


/*from http://www.informit.com/articles/article.aspx?p=23618&seqNum=10 
with further notes and links for future use at bottom*/
//now expanded to write to and display contents of mapped page in HEX


static int alloc_size;
static char* memory;

void segv_handler(int signal_number)
{
	printf("You don't have access to this file. SIGSEGV being thrown.\n");
	mprotect (memory, alloc_size, PROT_READ | PROT_WRITE);
}

int main ()
{
int fd;
struct sigaction sa;
char userInput;
char userFileInput;

/* Install segv_handler as the handler for SIGSEGV. */
	memset(&sa, 0, sizeof (sa));
	sa.sa_handler = &segv_handler;
	sigaction(SIGSEGV, &sa, NULL);

/* Allocate one page of memory by mapping /dev/zero. Map the memory
   as write-only, initially. */
	printf("enter the name of the file you want to map, flag change, or dump:\n");
    scanf("%c", &userInput);
   
   
	alloc_size = getpagesize ();
	//fd = open("/home/ae123/testFile", O_RDONLY);
	fd = open(userFileInput, O_RDONLY);
	memory = mmap(NULL, alloc_size, PROT_WRITE, MAP_PRIVATE, fd, 0);
	close (fd);

	FILE *f = fopen("pageDump.txt", "w");
	if (f == NULL)
	{
		printf("error opening file!\n");
		exit(3);
	}


	//mprotect(memory, alloc_size, PROT_READ | PROT_WRITE);

/* Write to the page to obtain a private copy. */
	printf("%p\n", (void *)&memory);

	//	memory[0] = 'c'; //displays in ascii (99) converted to hex when displayed
	//memory[100] = 100;
	//memory[4094] =  255;
	/*printf("%x\n", (unsigned long long)memory[0]);
	printf("%p\n", (void *)&memory[0]);
	printf("%p\n", (void *)&memory[1]);
	printf("%p\n", (void *)&memory[4095]);
	*/
	int i;
	char val = 0;
	char* pt = &val;


	for(i = 0; i < alloc_size; i++){
//	*pt = (intptr_t)memory[i];
		if ( i % 5 == 0 && i != 0){
		fprintf(f, "\n");
		printf("\n");
		}
		printf("[%8x] ", (unsigned long long)memory[i]);
		fprintf(f, "[%8x] ",(unsigned long long)memory[i]);

	//printf("%x\n", *pt);
	//*printmemory = &memory[i];
	//printf("%x\n", (char *)&memory[i]);
}

//printf("%p\n", (void *)&memory[800000000000000000000000000]);

	//printf("this is where we broke\n");
	//memory[0] = 25;

/* Make the memory unwritable. */


	printf("\nEnter y to change flag to PROT_NONE and cause sigsegv\n", userInput);
	scanf("%c", &userInput);
	if(userInput == 'y') {

	mprotect(memory, alloc_size, PROT_NONE);

/* Write to the allocated memory region. */
	memory[0] = 1;
	//printf("we actually broke at part 2!\n");
	}

/* All done; unmap the memory. */
	printf("all done\n");
	/*printf(memory[0])*/

	fprintf(f, "\n");
	fclose(f);
	munmap(memory, alloc_size);
	return 0;
}

/*list of c functions/sys calls being used and their docks

segv_handler - http://stackoverflow.com/questions/2663456/how-to-write-a-signal-handler-to-catch-sigsegv
			 ---falls under sigaction

mprotect - http://man7.org/linux/man-pages/man2/mprotect.2.html
		 ---  On success, mprotect() and pkey_mprotect() return zero.  On error,
       these system calls return -1, and errno is set appropriately.

open -  http://codewiki.wikidot.com/c:system-calls:open
		---open is a system call that is used to open a new file and obtain its file descriptor.

memset - http://www.cplusplus.com/reference/cstring/memset/
	   ---changes specified memeory location to new input

sigaction - http://pubs.opengroup.org/onlinepubs/009695399/functions/sigaction.html
			http://docs.oracle.com/cd/E19253-01/816-5167/sigaction-2/index.html
			---action associated with a specific siganl, eg SIGSEGV

fd - stackoverflow.com/questions/5256599/what-are-file-descriptors-explained-in-simple-terms
   ---file descriptors

mmap - http://man7.org/linux/man-pages/man2/mmap.2.html
	 ---map or unmap files or devices into memory

munmap - https://linux.die.net/man/2/munmap
	 ---see above

*/

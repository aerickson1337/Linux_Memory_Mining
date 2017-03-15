#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

// rtest
/*from http://www.informit.com/articles/article.aspx?p=23618&seqNum=10 
with further notes and links for future use at bottom*/


static int alloc_size;
static char* memory;

void segv_handler(int signal_number)
{
	printf("memory accessed!\n");
	mprotect (memory, alloc_size, PROT_READ | PROT_WRITE);

}

int main ()
{
int fd;
struct sigaction sa;

/* Install segv_handler as the handler for SIGSEGV. */
	memset(&sa, 0, sizeof (sa));
	sa.sa_handler = &segv_handler;
	sigaction(SIGSEGV, &sa, NULL);

/* Allocate one page of memory by mapping /dev/zero. Map the memory
   as write-only, initially. */
	alloc_size = getpagesize ();
	fd = open("/home/dummbyac/testfile", O_RDONLY);
	memory = mmap(NULL, alloc_size, PROT_WRITE, MAP_PRIVATE, fd, 0);
	close (fd);

	//mprotect(memory, alloc_size, PROT_READ | PROT_WRITE);

/* Write to the page to obtain a private copy. */
	memory[0] = 0;
	//printf("this is where we broke\n");
	//memory[0] = 25;

/* Make the memory unwritable. */
	mprotect(memory, alloc_size, PROT_NONE);

/* Write to the allocated memory region. */
	memory[0] = 1;
	//printf("we actually broke at part 2!\n");

/* All done; unmap the memory. */
	printf("all done\n");
	/*printf(memory[0])*/
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


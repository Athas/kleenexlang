#include <string.h>
#include <stdio.h>
#include <sys/time.h>
#include <stdint.h>
#include <inttypes.h>

#define BUFFER_SIZE (200*1024*1024)
char buffer[BUFFER_SIZE] = {0};

#define PRE                                     \
  int cs;                                       \
  char *eof;                                    \
  uint64_t start = getTimeMs();

#define POST                                                \
  uint64_t stop = getTimeMs();                              \
  fprintf(stderr, "\nmatching (ms): %" PRIu64 "\n", stop - start);

#define FAIL                                            \
  fprintf(stderr, "matching failed (%p %p)!\n", p, pe); \
  return 1;                                                            

#define INIT_LINE                               \
  char *p = &buffer[0];                         \
  char *pe = p + strlen(buffer);


uint64_t getTimeMs() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_usec / 1000 + tv.tv_sec * 1000;
}

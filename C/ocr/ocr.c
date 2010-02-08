/* ======================================================================
 *
 * Author: Edward Patel, Memention AB
 *
 * ====================================================================== */

#include <stdio.h>
#include <string.h>

// ----------------------------------------------------------------------

int ocr_cc(const char *str) {
  int c;
  int v = 0;
  int m = (strlen(str)%2);
  
  while (*str) {
    c = (*str - '0')*(m+1);
    while (c>9)
      c-=9;
    v += c;
    m = !m;
    str++;
  }

  if (v%10)
    return 10-(v%10);
  return 0;
}

int ocr_ccl(const char *str) {
  char buf[256];
  char lc[2];
  
  strcpy(buf, str);

  lc[0] = '0' + ((strlen(str)+2)%10);
  lc[1] = '\0';

  strcat(buf, lc);

  return ocr_cc(buf);
}

// ----------------------------------------------------------------------

int main(int argc, char *argv[]) {

  if (argc!=2)
    return -1;

  printf("    Only cc: %s%d\n", argv[1], ocr_cc(argv[1]));
  printf("With len+cc: %s%d%d\n", argv[1], (int)(strlen(argv[1])+2)%10, ocr_ccl(argv[1]));

  return 0;
}

/******
*
* eth-enable.c - Enable the two gigabit ethernet ports on a freshly
* booted Barracuda Web Filter 410.
*
******/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/io.h>

#define base 0x0378   /* printer port base address */
#define value 255     /* numeric value to send to printer port */

int main(int argc, char **argv)
{
  /* If we don't have permission, fail now. */
  if (ioperm(base,1,1)) {
    fprintf(stderr, "Could not open the parallel port at %x\n. Do you have permission?", base);
    exit(1);
  }

  /* Turns off all three LEDs while turning on ethernet ports */
  outb(value, base);
  return(0);
}

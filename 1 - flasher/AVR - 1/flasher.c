#include <mega8.h>
#include <delay.h>
#define xtal 1000000

void main (void)
{
    int i;
    DDRD = 0xFF;
    while(1)
    {
        int binaryobj = 1;
        PORTD = 0;
        delay_ms(100);
        for(i = 1; i<= 8; i = i + 1)
        {
            PORTD = binaryobj * 2 - 1;
            binaryobj = binaryobj * 2;
            delay_ms(100);
        }
        
        for(i = 1; i <= 7; i = i + 1)
        {
            PORTD = binaryobj / 2 - 1;
            binaryobj = binaryobj/2;
            delay_ms(100);
        }
    }
}



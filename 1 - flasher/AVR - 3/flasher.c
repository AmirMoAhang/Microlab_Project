#include <mega8.h>
#include <delay.h>
#define xtal 1000000

void main(void)
{
    int i;
    DDRD = 0xFF;
    while (1)
    {  
        for(i = 1; i<= 128; i = i * 2)
        {
            PORTD = i;
            delay_ms(100);
        }
        
        for(i = 64; i > 1; i = i / 2)
        {
            PORTD = i;
            delay_ms(100);
        }

    }
}




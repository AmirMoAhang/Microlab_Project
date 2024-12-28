#include <io.h>
#include <delay.h>
void main(void)
{
    DDRD = 0xFF;
    while (1)
    {
        PORTD = 0;
        delay_ms(200);
        PORTD = 24;
        delay_ms(200);
        PORTD = 60;
        delay_ms(200);
        PORTD = 126;
        delay_ms(200);
        PORTD = 255;
        delay_ms(200);
        PORTD = 126;
        delay_ms(200);
        PORTD = 60;
        delay_ms(200);
        PORTD = 24;
        delay_ms(200);
   }
}



#include <io.h>
#include <delay.h>

interrupt [2] void LED_ON(void)
{
    PORTB = 0x01;
    delay_ms(1000);
    PORTB = 0x00;
}

void main(void)
{
    DDRB = 0xFF;
    PORTB = 0x00;

    DDRD = 0x00;
    PORTD = 0xFF;

    GICR = 0b01000000;
    MCUCR = 0b00000010;

    #asm("sei")

    while (1)
    {
        PORTB = 0x02;
        delay_ms(500);
        PORTB = 0x00;
        delay_ms(500);

    }
}

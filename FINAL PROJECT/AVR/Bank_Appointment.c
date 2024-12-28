#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>

int GetKey();

unsigned int allOfDay = 0;
unsigned int current = 0;
unsigned int remaining = 0;
unsigned int teller = 0;
unsigned char change = 1;

unsigned char buffer1[16];
unsigned char buffer2[16];

interrupt [2] void Test0(void)
{
    if((allOfDay - current) > 0)
    {
        current++;
        remaining--;

        delay_ms(100);
        teller = GetKey();
    }

    change = 1;

    GICR |= (1 << INTF0);
}

interrupt [3] void Test1(void)
{
    allOfDay++;
    remaining++;

    lcd_clear();
    lcd_gotoxy(0, 1);
    sprintf(buffer2, "Your NO. %03d", allOfDay);
    lcd_puts(buffer2);

    change = 1;

    delay_ms(1000);

    GICR |= (1 << INTF1);
}

void main(void)
{
    DDRD = 0x00;
    PORTD = 0xFF;

    DDRC = 0x00;
    PORTC = 0xFF;

    GICR = 0b11000000;
    MCUCR = 0b00001010;

    lcd_init(16);
    lcd_clear();

    #asm("sei")
    
    while (1)
    {
        if(change)
        {
            lcd_clear();
            lcd_gotoxy(0, 0);
            sprintf(buffer1, "AOD:%03d  R:%03d", allOfDay, remaining);
            lcd_puts(buffer1);

            lcd_gotoxy(0, 1);
            sprintf(buffer2, "No. %03d to %d", current, teller);
            lcd_puts(buffer2);

            change = 0;
        }
    }
}


int GetKey()
{
    if(PINC.0 == 0)
        return 1;
    else if(PINC.1 == 0)
        return 2;
    else if(PINC.2 == 0)
        return 3;
}

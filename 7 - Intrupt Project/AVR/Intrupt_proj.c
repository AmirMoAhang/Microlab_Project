#include <io.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>

unsigned int milisec;
unsigned int sec;
unsigned int min;
unsigned int hour;

unsigned char stop;
unsigned char buffer[16];

interrupt [2] void stopStart(void)
{
    stop = !stop;
    GICR |= (1 << INTF0); 
}

interrupt [3] void reset(void)
{
    if(stop == 1)
    {
        hour = milisec = sec = min = 0; 
        sprintf(buffer, "%02d : %02d : %02d . %d", hour, min, sec, milisec/100);  
        //"00 : 00 : 00 . 0"
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts(buffer);
    }
    GICR |= (1 << INTF1);
}

void main() {
    
    
    DDRD = 0x00;
    PORTD = 0xFF;

    GICR = 0b11000000;
    MCUCR = 0b00001010;

    #asm("sei")

    lcd_init(16);
    lcd_clear();

    while(1)
    {
        while(stop == 1);

        if (stop != 1)
        {
            delay_ms(100);

            if(milisec == 900)
            {
                milisec = 0;
                if(sec == 59)
                {
                    sec = 0;
                    if(min == 60)
                    {
                        min = 0;
                        if(hour == 99)
                        {
                            hour = 0;
                        }
                        else
                        {
                            hour++;
                        }
                    }
                    else
                    {
                        min++;
                    }
                }
                else
                {
                    sec++;
                }
            }
            else
            {
                milisec += 100;
            }
        }
         
        //"00 : 00 : 00 . 0"
        sprintf(buffer, "%02d : %02d : %02d . %d", hour, min, sec, milisec/100);
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts(buffer);
    }
    
}

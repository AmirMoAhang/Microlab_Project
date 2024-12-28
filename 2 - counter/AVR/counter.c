#include <io.h>
#include <delay.h>

void main(void)
{
char counter1 = 0;
char counter2 = 0;
const char Segments[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};

DDRB = 0xFF;
PORTB = Segments[0];

DDRD = 0xFF;
PORTD = Segments[0];

DDRC.0 = 0;
PORTC.0 = 1;
DDRC.1 = 0;
PORTC.1 = 1;

while (1)
    {   
        if(!PINC.0)
        {
        delay_ms(300);
        if(counter1 == 9)
        {
            if(counter2 == 9)
            {
                counter1 = counter2 = 0;
            }
            else
            {
                counter1 = 0;
                counter2++;
            }
        }
        else
        {
            counter1++;
        }              
        while(!PINC.0);
        delay_ms(300);
        PORTD = Segments[counter1];
        PORTB = Segments[counter2];    
        }
        
        if(!PINC.1)
        {
            delay_ms(300);
            if(counter1 == 0)
            {
                if(counter2 == 0)
                {
                    counter1 = counter2 = 9;
                }
                else
                {
                    counter1 = 9;
                    counter2--;
                }
                   
            }
            else
            {
                counter1--;
            } 
            while(!PINC.1);
            delay_ms(300);
            PORTD = Segments[counter1];
            PORTB = Segments[counter2];
        }
         
        
                        
    }
}

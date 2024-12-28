#include <io.h>
#include <delay.h>
#define xtal 4000000

flash char digits[16] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};

unsigned char p_state;
unsigned char key;
unsigned char i;

void main(void)
{

DDRD = 0xFF;
PORTD = digits[0];
DDRC = 0x00;
PORTC = 0xFF;

while (1)
    {    
        key = PINC & 0b00000001;
        delay_ms(10);
        
        if(key == 0)
        {
            if(key != p_state)
            {
                if(i == 9)
                {
                    i = 0;
                    PORTD = digits[i];
                }
                else
                {
                    i++;
                }       
                
                PORTD = digits[i];
                p_state = 0;
            }
        }
        else
        {
            p_state = 1;
        }
    }
}

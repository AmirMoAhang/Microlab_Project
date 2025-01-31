#include <io.h>
#include <stdio.h>
#include <delay.h>
//#include <alcd.h>

//#asm
//    .equ __lcd_port=0x1B ;PORTA
//#endasm


void main(void)
{
//    char buffer[10];
//    unsigned char w;
    
    unsigned char key, butnum;
    unsigned char keytbl[16] = {0xEE, 0xED, 0xEB, 0xE7, 0xDE, 0xDD, 0xDB, 0xD7, 0xBE, 0xBD, 0xBB, 0xB7, 0x7E, 0x7D, 0x7B, 0x77};
    DDRB = 0xFF;
    PORTB = 0xFF;
    
    while (1)
        {
            DDRC = 0x0F;
            PORTC = 0xF0;
            delay_us(5);
            key = PINC;
            
            DDRC = 0xF0;
            PORTC = 0x0F;
            delay_us(5);
            key = key | PINC;
            
            delay_ms(50);
            if(key != 0xFF)
            {
                for(butnum = 0; butnum < 16; butnum++)
                {
                    if(keytbl[butnum] == key) break;
                }                                   
                if(butnum == 16) butnum = 0;
                else butnum++;
            }   
            else butnum = 0;
            PORTB = ~butnum;
        }
}

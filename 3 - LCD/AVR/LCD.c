#include <io.h>
#include <stdio.h>
#include <delay.h>
#include <lcd.h>

#asm
    .equ __lcd_port=0x1B; PORTA
#endasm

void main(void)
{
    char buffer[10];
    unsigned char w;
    
    DDRB = 0x00;
    PORTB = 0xFF;
                
    lcd_init(16);   
    lcd_clear();
    
    while (1)
        {
         w = ~PINB;
         
         if(w!=0x00)
         {
            lcd_clear();
            lcd_gotoxy(0,0);
            sprintf(buffer, "Number=%d",w);
            lcd_puts(buffer);
            delay_ms(100);
         }                
         else
         {
            lcd_clear();
            lcd_putsf("Number=0");
            delay_ms(100);
         }
         
        }
}

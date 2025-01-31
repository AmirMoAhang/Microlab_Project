#include <io.h>
#include <stdio.h>
#include <delay.h>
#include <alcd.h>

char GetKey();
void main(void)
{
    char k; 
    unsigned char buffer[10];

    DDRD = 0xF0;
    PORTD = 0x0F;
    
    lcd_init(16);
    lcd_clear();

    while (1)
        {
            while(1)
            {
                k = GetKey();
                if(k != 16) break;
            }
            lcd_clear();
            lcd_gotoxy(0,0);
            sprintf(buffer, "%d", k);
            lcd_puts(buffer);    
        }
}

char GetKey()
{
    unsigned char key = 16;
    unsigned char row;
   
//D ROW 
    PORTD.7 = 0;
    row = PIND & 0x07;
    if(row != 0x07)
    {
        switch(row)
        {
            case 0b110 : key = 10; break;
            case 0b101 : key = 0; break;
            case 0b011 : key = 11; break;
        }
    }
    PORTD.7 = 1;
    
    
//C ROW
    PORTD.6 = 0;
    row = PIND & 0x07;
    if(row != 0x07)
    {
        switch(row)
        {
            case 0b110 : key = 9; break;
            case 0b101 : key = 8; break;
            case 0b011 : key = 7; break;
        }
    }
    PORTD.6 = 1;  
   

 
//B ROW
    PORTD.5 = 0;
    row = PIND & 0x7;
    if(row != 0x07)
    {
        switch(row)
        {
            case 0b110 : key = 6; break;
            case 0b101 : key = 5; break;
            case 0b011 : key = 4; break;
        }
    }
    PORTD.5 = 1;
                
    
    
//A ROW
    PORTD.4 = 0;
    row = PIND & 0x07;
    if(row != 0x07)
    {
        switch(row)
        {
            case 0b110 : key = 3; break;
            case 0b101 : key = 2; break;
            case 0b011 : key = 1; break;
        }
    }
    PORTD.4 = 1;
    
     if(key != 16)
     {
        delay_ms(200);
     }
    PORTD = 0x07;
    return key; 
}

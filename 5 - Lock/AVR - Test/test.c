#include <io.h>
#include <eeprom.h>


char check();

void main(void)
{

    DDRD = 0xFF;
    PORTD = 0x00;

    DDRB = 0xFF;
    PORTB = 0x00;

    PORTD = check();
    eeprom_write_byte(0, 128);
    PORTB = check();

    while(1)
    {

    }
    
}

char check()
{
    char test;
    test = eeprom_read_byte(0);
    return test;
}

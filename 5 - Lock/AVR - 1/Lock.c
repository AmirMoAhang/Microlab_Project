#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>
#include <eeprom.h>

char GetKey();
void changePass();
void checkPassFromEEPROM();

char Password[] = "11111";


void main(void)
{
    char inputPass[6] = "";
    char passIndex = 0;
    char locked = 1;
    char k;
    
    lcd_init(16);
    lcd_clear();
    
    DDRD = 0xF0;
    PORTD = 0xFF;
    DDRC = 0x03;
    PORTC = 0x02;
    
    checkPassFromEEPROM();
    while (1)
        {
            lcd_gotoxy(0,0);
            lcd_puts("-----LOCKED-----");    
        
            while(1)
            {
                k = GetKey();
                if(k != 16) break;
            }
            
            if(k == 10)
            {
                while(GetKey() != 16);
                strcpyf(inputPass,"");
                passIndex = 0;
            }
            else if(k == 11)
            {
                while(GetKey() != 16);
                inputPass[passIndex] = '\0';
                if(strcmp(inputPass, Password) == 0)
                {
                    locked = 0;
                    PORTC = 0x01;
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    lcd_putsf("----UNLOCKED----");
                    while(1)
                    {
                        k = GetKey();
                        if(k == 16) continue;
                        else if (k == 10)
                        {
                            // new pass
                            changePass();
                            PORTC = 0x02;
                            break;
                        }
                        else if(k == 11)
                        {
                            PORTC = 0x02;
                            break;
                        }
                    }
                    
                }
                else
                {
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    lcd_putsf("-----WRONG------");
                    delay_ms(2000);

                }
                strcpyf(inputPass, "");
                passIndex = 0;
            }
            else
            {
                while(GetKey()!= 16);
                if(passIndex < sizeof(inputPass) - 1)
                {
                    inputPass[passIndex] = k + 0x30;
                    passIndex++;
                    lcd_gotoxy(4+passIndex,1);
                    lcd_putchar('*');
                } 
            }
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
            case 0b110 : key = 11; break;
            case 0b101 : key = 0; break;
            case 0b011 : key = 10; break;
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
    PORTD = 0xFF;
    return key; 
}

void changePass()
{

//Needed variables
    char inputPass[6] = "";
    char passIndex = 0;   

    char newPass[6]= "";
    char newPassIndex = 0;

    char ReNewPass[6]= "";
    char ReNewPassIndex = 0;

    char k;

//stage 1 (current password)
    
    lcd_clear();

    while(1)
    {
        lcd_gotoxy(0,0);
        lcd_putsf("--current pass--");
        
        while(1)
        {
            k = GetKey();
            if(k != 16) break;
        }

        if(k == 10)
        {
            while(GetKey() != 16);
            strcpyf(inputPass,"");
            passIndex = 0;
        }
        else if(k == 11)
        {
            while(GetKey() != 16);
            inputPass[passIndex] = '\0';

            if(strcmp(inputPass, Password) == 0)
                break;                
            
            else
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("-----WRONG------");
                delay_ms(2000);

            }
            strcpyf(inputPass, "");
            passIndex = 0;
        }
        else
        {
            while(GetKey()!= 16);

            if(passIndex < sizeof(inputPass) - 1)
            {
                inputPass[passIndex] = k + 0x30;
                passIndex++;
                lcd_gotoxy(4+passIndex,1);
                lcd_putchar('*');
            }    
        }
    }

//stage 2 (new pass)

    lcd_clear();
    while(1)
    {
        lcd_gotoxy(0,0);
        lcd_putsf("----New Pass----");
        while(1)
        {
            k = GetKey();
            if(k != 16) break;
        }

        if(k == 10)
        {
            while(GetKey() != 16);

            strcpyf(newPass,"");
            passIndex = 0;
        }
        else if(k == 11)
        {
            while(GetKey() != 16);
            newPass[passIndex] = '\0';

            if(newPassIndex == 5)
                break;
            else
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("-Enter 5 Digits-");
                delay_ms(1000);
            }
        }
        else
        {
            while(GetKey()!= 16);

            if(newPassIndex < sizeof(newPass) - 1)
            {
                newPass[newPassIndex] = k + 0x30;
                newPassIndex++;
                lcd_gotoxy(4+newPassIndex,1);
                lcd_putchar(k + 0x30);
            }    
        }
    }


//stage 3 (repeat new pass)
    lcd_clear();

    while(1)
    {
        lcd_gotoxy(0,0);
        lcd_putsf("REenter new pass");
        while(1)
        {
            k = GetKey();
            if(k != 16) break;
        }

        if(k == 10)
        {
            while(GetKey() != 16);

            strcpyf(ReNewPass,"");
            ReNewPassIndex = 0;
        }
        else if(k == 11)
        {
            while(GetKey() != 16);

            ReNewPass[ReNewPassIndex] = '\0';

            if(strcmp(ReNewPass, newPass) == 0)
            {
                strcpy(Password, newPass);

                //TODO: add to eeprom storage
                eeprom_write_byte(0, Password[0]);
                eeprom_write_byte(1, Password[1]);
                eeprom_write_byte(2, Password[2]);
                eeprom_write_byte(3, Password[3]);
                eeprom_write_byte(4, Password[4]);

                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("--Pass changed--");
                break;
            }                
            else
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("-----WRONG------");
                delay_ms(2000);

            }
            strcpyf(ReNewPass, "");
            ReNewPassIndex = 0;
        }
        else
        {
            while(GetKey()!= 16);

            if(ReNewPassIndex < sizeof(ReNewPass) - 1)
            {
                ReNewPass[ReNewPassIndex] = k + 0x30;
                ReNewPassIndex++;
                lcd_gotoxy(4 + ReNewPassIndex,1);
                lcd_putchar(k + 0x30);
            }    
        }
    }

    
}

void checkPassFromEEPROM()
{
    char emptyFlag = 1;

    //TODO: check if eeprom is empty or what?
    char test = eeprom_read_byte(0);
    if (test != 0xFF)
    {
        emptyFlag = 0;
    }

    //TODO: if eeprom is full cpy it to password
    if(!emptyFlag)
    {
        Password[0] = eeprom_read_byte(0);
        Password[1] = eeprom_read_byte(1);
        Password[2] = eeprom_read_byte(2);
        Password[3] = eeprom_read_byte(3);
        Password[4] = eeprom_read_byte(4);
    }
}
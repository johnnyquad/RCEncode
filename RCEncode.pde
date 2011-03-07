/* sketch to test RCEncoder  */
// Sends a pulse stream on pin 2 proportional to the values of pots connected to the analog pins
//MODDED JDH

// Channel order ROLL PITCH THROTHLE YAW CH5(Aux1) CH6(Aux2) CH7(Cam1) CH8(Cam2)

#include <LiquidCrystal.h>
#include "RCEncoder.h"
//#include <string.h>
//#include <stdlib.h>

LiquidCrystal lcd(12, 11, 7, 6, 5, 4);

#define OUTPUT_PIN 2
#define TONE_PIN 3
#define TRIM_MIN -60
#define TRIM_MAX 60
#define THROTTLELOOPTIME 50000  // in uS .. 50ms, 20Hz

bool StateCH5;
bool StateCH6;
bool throttleLock;
bool beepOnce;
unsigned long currentTime; //in uS
unsigned long lastTime;
unsigned long loopTime;
unsigned long throttleTime;
int currentThrottle;



void setup ()
{
  lcd.begin(20, 4);
  encoderBegin(OUTPUT_PIN);
  Serial.begin(115200);
  pinMode(ledTest1,OUTPUT);
  
  lcd.setCursor(0,1);
  lcd.print("  Futaba PPM Buddy  ");
  lcd.setCursor(0,2);
  lcd.print("JDH 06/03/2011 V 0.1");
  delay(300);
  lcd.clear();
  
//  Serial.println(FRAME_RATE);
//  Serial.println(" ");
//  Serial.println(FRAME_RATE_TICKS); 
//  Serial.println(" ");
  for(int i=22; i < 41; i++) //setup 22 ~ 40 as IP
  {
    pinMode(i,INPUT);
    digitalWrite(i, HIGH); //turn on pullup resistors
  }

StateCH5 = 0;
StateCH6 = 0;
throttleLock = 0;
beepOnce = 0;

}

void loop ()
{
  currentTime = micros();
  int trim1 = analogRead(5); //read trim pots
  trim1= map(trim1, 0,1023,TRIM_MIN,TRIM_MAX);
  int trim2 = analogRead(6);
  trim2= map(trim2, 0,1023,TRIM_MIN,TRIM_MAX);
  int trim3 = analogRead(7);
  trim3= map(trim3, 0,1023,1,20);// now used for throttle step TRIM_MIN,TRIM_MAX);
  int trim4 = analogRead(8);
  trim4= map(trim4, 0,1023,TRIM_MIN,TRIM_MAX);
  
// Channel order ROLL(0) PITCH(1) THROTHLE(2) YAW CH5(Aux1) CH6(Aux2) CH7(Cam1) CH8(Cam2)
  
  for(int i=0; i < NBR_OF_CHANNELS-4; i++)
  {
    int value = analogRead(i);
    int pulseWidth = map(value, 0,1023, 1000, 2000);
    if (i == 0)
    {
      pulseWidth = pulseWidth + trim1;
      encoderWrite(i, pulseWidth);
      lcd.setCursor(0,1);
      lcd.print("    ");
      lcd.setCursor(0,1);
      lcd.print(pulseWidth);
      lcd.setCursor(0,2);
      lcd.print("    ");
      if (trim1 >= 0)
      {
        lcd.setCursor(1,2);
        lcd.print(int(trim1));
      }else
      {
        lcd.setCursor(0,2);
        lcd.print(int(trim1));
      }
    }
    if (i == 1)
    {
      pulseWidth = pulseWidth + trim2;
      encoderWrite(i, pulseWidth);
      lcd.setCursor(5,1);
      lcd.print("    ");
      lcd.setCursor(5,1);
      lcd.print(pulseWidth);
      lcd.setCursor(5,2);
      lcd.print("    ");
      if (trim2 >= 0)
      {
        lcd.setCursor(6,2);
        lcd.print(int(trim2));
      }else
      {
        lcd.setCursor(5,2);
        lcd.print(int(trim2));
      }
    }
    if (i == 2)//THROTTLE
    {
      if(throttleLock == 0)// no locking just use stick input
      {
        pulseWidth = pulseWidth ;//+ trim3;
        currentThrottle = pulseWidth;
        encoderWrite(i, pulseWidth);
        lcd.setCursor(10,1);
        lcd.print("    ");
        lcd.setCursor(10,1);
        lcd.print(pulseWidth);
        lcd.setCursor(10,2);
        lcd.print("    ");
        if (trim3 >= 0)
        {
          lcd.setCursor(11,2);
          lcd.print(int(trim3));
        }else
        {
          lcd.setCursor(10,2);
          lcd.print(int(trim3));
        }
      }
      
      if(throttleLock == 1) //lock throttle and use trigger & thumb button to inc/dec throttle
      {

      if (currentTime > throttleTime) // do throt inc/dec
      {
        if (digitalRead(29) == 0)//active low
        {
          currentThrottle = currentThrottle + trim3;
          if (currentThrottle > MAX_CHANNEL_PULSE)
          {
            currentThrottle = MAX_CHANNEL_PULSE;
          }          
          tone(TONE_PIN,2090,1);//2038 res
        }
        if (digitalRead(30) == 0)//active low
        {
          currentThrottle = currentThrottle - trim3;
          if (currentThrottle < MIN_CHANNEL_PULSE)
          {
            currentThrottle = MIN_CHANNEL_PULSE;
          }
          tone(TONE_PIN,2000,1);
        }
          
        throttleTime = currentTime + THROTTLELOOPTIME;
      }
      

        lcd.setCursor(10,1);
        lcd.print("    ");
        lcd.setCursor(10,1);
        lcd.print(currentThrottle);
        lcd.setCursor(10,2);
        lcd.print("    ");
        if (trim3 >= 0)
        {
          lcd.setCursor(11,2);
          lcd.print(int(trim3));
        }else
        {
          lcd.setCursor(10,2);
          lcd.print(int(trim3));
        }
      encoderWrite(i,currentThrottle);   
      } 
     } 
    
    if (i == 3)
    {
      pulseWidth = pulseWidth + trim4;
      encoderWrite(i, pulseWidth);
      lcd.setCursor(15,1);
      lcd.print("    ");
      lcd.setCursor(15,1);
      lcd.print(pulseWidth);
      lcd.setCursor(15,2);
      lcd.print("    ");
      if (trim4 >= 0)
      {
        lcd.setCursor(16,2);
        lcd.print(int(trim4));
      }else
      {
        lcd.setCursor(15,2);
        lcd.print(int(trim4));
      }
    }
    
  }
  
//Channel 5 stuff
  int ch5a = digitalRead(22);
  if (ch5a == 0)
  {    
    StateCH5 = true;
  }
  int ch5b = digitalRead(23);
  if (ch5b == 0)
  {    
    StateCH5 = false;
  }
  if (StateCH5 == true)
  {
    encoderWrite(4, 2000);
  }else
  {
    encoderWrite(4, 1000);
  }
  
  lcd.setCursor(0,0); 
  lcd.print("ROLL PITH THROT YAW ");
  
  lcd.setCursor(0,3);
  lcd.print(StateCH5);
   
//Channel 6 stuff  
  int ch6a = digitalRead(24);
  if (ch6a == 0) //active low
  {
    StateCH6 = 0;
  }
  int ch6b = digitalRead(25);
  if (ch6b == 0) //active low
  {
    StateCH6 = 1;
  }
  int ch6c = digitalRead(26);
  if (ch6c == 0) //active low
  {
    StateCH6 = 2;
  }
  
  if (StateCH6 == 0)
  {
    encoderWrite(5, 1000);
  }
  if (StateCH6 == 1)
  {
    encoderWrite(5, 1500);
  }
  if (StateCH6 == 2)
  {
    encoderWrite(5, 2000);
  }
  lcd.setCursor(2,3);
  lcd.print(StateCH6);  
  

  int tl0 = digitalRead(27);//TL zero = Throttle lock off
  if (tl0 == 0) //active low
  {
    if (throttleLock == 1)
    {
      throttleLock = 0;
    }
  }  
  int tl1 = digitalRead(28);//TL one = Throttle lock on
  if (tl1 == 0) //active low
  {
    if (throttleLock == 0)
    {
      throttleLock = 1;
    }
  }  
  lcd.setCursor(4,3);
  lcd.print(throttleLock);
 loopTime = micros() - currentTime;
//Serial.println(loopTime); 
 
//  lcd.print(ch6a);
//  lcd.print(" ");
//  lcd.print(ch6b);
//  lcd.print(" ");
//  lcd.print(ch6c);
//  lcd.print(" ");  


/*  Serial.print(ch6a);
  Serial.print(" ");
  Serial.print(ch6b);
  Serial.print(" ");
  Serial.print(ch6c);
  Serial.print(" ");
  Serial.println(StateCH6);
*/  
  
}

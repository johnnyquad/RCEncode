/* sketch to test RCEncoder  */
// Sends a pulse stream on pin 2 proportional to the values of pots connected to the analog pins
//MODDED JDH
#include "RCEncoder.h"

#define OUTPUT_PIN 2



void setup ()
{
  encoderBegin(OUTPUT_PIN);
  Serial.begin(115200);
  pinMode(ledTest1,OUTPUT);
  Serial.println(FRAME_RATE);
  Serial.println(" ");
  Serial.println(FRAME_RATE_TICKS); 
  Serial.println(" ");
}

void loop ()
{
  for(int i=0; i < NBR_OF_CHANNELS; i++)
  {
    int value = analogRead(i);
    int pulseWidth = map(value, 0,1023, 1000, 2000);
    encoderWrite(i, pulseWidth);
  }  
/*   for (int i =0; i < NBR_OF_CHANNELS; i++)
   {
     Serial.print(i,DEC);
     Serial.print("=\t");
     Serial.print(Channels[i].ticks,DEC);
   }
   /*Serial.print(" RunningPulseWidth= ");
   Serial.print(RunningPulseWidth);
   Serial.print("\r\n");*/
  delay(20);
}

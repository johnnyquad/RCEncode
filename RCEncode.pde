/* sketch to test RCEncoder  */
// Sends a pulse stream on pin 2 proportional to the values of pots connected to the analog pins

#include "RCEncoder.h"

#define OUTPUT_PIN 2


void setup ()
{
  encoderBegin(OUTPUT_PIN);
  Serial.begin(115200);
  pinMode(ledTest1,OUTPUT);
}

void loop ()
{
  for(int i=0; i < 6; i++)
  {
    int value = analogRead(i);
    int pulseWidth = map(value, 0,1023, 1000, 2000);
    encoderWrite(i, pulseWidth);
  }  
  delay(10);
}

// RCEncoder.H
#ifndef RCEncoder_h
#define RCEncoder_h
#include "WProgram.h"

#ifdef __cplusplus
extern "C"{
#endif

#define ledTest1 8
#define ledTest2 9


#define MS_TO_TICKS(_ms)  ((_ms) * 2)  // todo, use macro here

#define NBR_OF_CHANNELS  8
#define MIN_CHANNEL_PULSE 1000  // 1ms
#define MID_CHANNEL_PULSE 1500  // 1.5ms
#define MAX_CHANNEL_PULSE 2000  // 2 ms
#define INTER_CHAN_DELAY  200   // 200 microseconds
#define INTER_CHAN_DELAY_TICKS (unsigned int)(MS_TO_TICKS(INTER_CHAN_DELAY));
#define FRAME_RATE	  20000 // 20 ms
#define FRAME_RATE_TICKS  (unsigned int)(MS_TO_TICKS(FRAME_RATE))
#define SYNC_PULSE_WIDTH (FRAME_RATE - (NBR_OF_CHANNELS * (MID_CHANNEL_PULSE + INTER_CHAN_DELAY)))


void encoderBegin(byte pin);
void encoderWrite(byte channel, int microseconds);

#ifdef __cplusplus
} // extern "C"
#endif

#endif 


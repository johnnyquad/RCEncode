PPM encoding software to provide buddy input to Futaba TX v0.1 Beta
========================================
[https://github.com/johnnyquad/RCEncode](https://github.com/johnnyquad/RCEncode)

This was inspired by www.ianjohnston.com and another guy on the Arduino forums http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1243998214 but the Arduino guy's code didn't give consistent framing pulse length a his sync pulse was staticly compiled in. This rework now calculates a running pulse width which is an accumulation of the channel widths and the inter channel gap widths and then calculates a correct sync pulse width every time during the ISR. The ISR is responsible for all pulse widths (channel, interchannel and the final sync pulse) using Timer1 so you can now do what you like in your normal program loop.
My testing has been done with a mega and all seems good so far. 
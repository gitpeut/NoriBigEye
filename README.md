# NoriBigEye
 UncannyEyesExample of tft_eSPI library reworked
 
 Now works on 2 screens, which was not supported by the tft_eSPI
 unfortunately. Now, the Adafruit GFX lib is used.

 The left eye ( seen from the front) is mirrored by telling the left display
 to have the X coordinate start at the right side.
   
   madctl = ST77XX_MADCTL_MX|ST77XX_MADCTL_RGB;    
    eye[0].tft.sendCommand( ST77XX_MADCTL,&madctl,1 ); 
 
 Also ported pixel doubling from https://learn.adafruit.com/animated-electronic-eyes/overview
 This gives a scarier effect, which is the point I think.
 Unfortunately the graphics files from that project are not compatible for
 reasons unknown to me.
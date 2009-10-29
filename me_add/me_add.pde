#include <LiquidCrystal.h>

int resetPin = 3; // pin 3 resets the time
unsigned int rpm;
unsigned long timeold;

//create object to control an LCD GMD1602K.
LiquidCrystal lcd(12, 11, 2, 7, 8, 9, 10);

void setup() {
 digitalWrite(resetPin,HIGH);    // this line enables pull-up 
 pinMode(13, OUTPUT);             // flash the LED each second
 pinMode(resetPin, INPUT);       // a button on this pin resets the time
 lcd.setCursor(0,0);
 lcd.print("Me Add");
 lcd.print(" ");
 lcd.setCursor(4,0);
 lcd.print(1); 
}

void loop() {
  
}

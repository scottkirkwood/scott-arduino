/* POV Hat
I've measure the radio at 13 cm so about 81cm is the circumference
I've clocked it at about 150 rpm  (2.5 revs per second)
400 ms for one revolution
3.8 ms per character 3800 usec

*/
// Prints out the message "ME ADD! ME ADD"
// Created with text2pixels.py
// 8 bits per line, 104 lines long
const byte image[] = {
    B11111111,
    B11111111,
    B11100000,
    B01111000,
    B00001100,
    B00111100,
    B11110000,
    B11111111,
    B11111111,
    B00000000,
    B00000000,
    B11111111,
    B11111111,
    B11011011,
    B11011011,
    B11011011,
    B10010001,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000111,
    B00111111,
    B11111100,
    B11100100,
    B11111100,
    B00111111,
    B00000111,
    B00000000,
    B11111111,
    B11111111,
    B11000011,
    B11000011,
    B11000011,
    B11111111,
    B01111110,
    B00011000,
    B00000000,
    B11111111,
    B11111111,
    B11000011,
    B11000011,
    B11000011,
    B11111111,
    B01111110,
    B00011000,
    B00000000,
    B00000000,
    B11111011,
    B11111011,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B11111111,
    B11111111,
    B11100000,
    B01111000,
    B00001100,
    B00111100,
    B11110000,
    B11111111,
    B11111111,
    B00000000,
    B00000000,
    B11111111,
    B11111111,
    B11011011,
    B11011011,
    B11011011,
    B10010001,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000111,
    B00111111,
    B11111100,
    B11100100,
    B11111100,
    B00111111,
    B00000111,
    B00000000,
    B11111111,
    B11111111,
    B11000011,
    B11000011,
    B11000011,
    B11111111,
    B01111110,
    B00011000,
    B00000000,
    B11111111,
    B11111111,
    B11000011,
    B11000011,
    B11000011,
    B11111111,
    B01111110,
    B00011000,
 };

int index = 0;
int intercolumn_usec = 3800;
int end_delay_usec = 0;

// In case we get the order wrong
int led_pins[] = { 0, 1, 2, 3, 4, 5, 6, 7 };

void allOff() {
  for (int i = 0; i < sizeof(led_pins) / sizeof(int); i++) {
    pinMode(led_pins[i], OUTPUT);
    digitalWrite(led_pins[i], LOW);
  }
}

void ledWarmup() {
  allOff();
  for (int i = 0; i < sizeof(led_pins) / sizeof(int); i++) {
    digitalWrite(led_pins[i], HIGH);
    delay(500);
    digitalWrite(led_pins[i], LOW);
  }
  allOff();
}
void setup() {
   ledWarmup();
   index = 0;
}

void loop() {
  display(image[index]);
  index += 1;
  if (index >= sizeof(image)) {
    if (end_delay_usec > 0) {
      delayMicroseconds(end_delay_usec);
    }
    index = 0;
  } else {
    delayMicroseconds(intercolumn_usec);
  }
}

void display(byte toshow) {
  for (int i = 0; i < 8; i++) {
    if (toshow & B00000001) {
      digitalWrite(led_pins[7 - i], HIGH);
    } else {
      digitalWrite(led_pins[7 - i], LOW);
    }
    toshow = toshow >> 1;
  }
}

/* POV Hat
I've measure the radio at 13 cm so about 81cm is the circumference
I've clocked it at about 150 rpm  (2.5 revs per second)
400 ms for one revolution
3.8 ms per character 3800 usec

*/
  // Prints out the message "HAPPY HALLOWEEN"
  // 8 bits per line, 105 lines long
const byte image[] = {
    B11111111,
    B00010000,
    B00010000,
    B00010000,
    B00010000,
    B11111111,
    B00000000,
    B00000001,
    B00001110,
    B01110100,
    B11000100,
    B01110100,
    B00001110,
    B00000001,
    B00000000,
    B11111111,
    B10001000,
    B10001000,
    B10001000,
    B01110000,
    B00000000,
    B00000000,
    B11111111,
    B10001000,
    B10001000,
    B10001000,
    B01110000,
    B00000000,
    B10000000,
    B01000000,
    B00100000,
    B00011111,
    B00100000,
    B01000000,
    B10000000,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B00000000,
    B11111111,
    B00010000,
    B00010000,
    B00010000,
    B00010000,
    B11111111,
    B00000000,
    B00000001,
    B00001110,
    B01110100,
    B11000100,
    B01110100,
    B00001110,
    B00000001,
    B00000000,
    B11111111,
    B00000001,
    B00000001,
    B00000001,
    B00000001,
    B00000000,
    B11111111,
    B00000001,
    B00000001,
    B00000001,
    B00000001,
    B00000000,
    B00111100,
    B01000010,
    B10000001,
    B10000001,
    B10000001,
    B01000010,
    B00111100,
    B00000000,
    B11000000,
    B00111100,
    B00000011,
    B00011100,
    B11100000,
    B00011100,
    B00000111,
    B00111100,
    B11000000,
    B00000000,
    B11111111,
    B10010001,
    B10010001,
    B10010001,
    B10010001,
    B00000000,
    B00000000,
    B11111111,
    B10010001,
    B10010001,
    B10010001,
    B10010001,
    B00000000,
    B00000000,
    B11111111,
    B11000000,
    B00110000,
    B00001100,
    B00000011,
    B11111111,
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

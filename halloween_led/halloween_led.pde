/* 
Handle SparkFun LED matrix with scrolling.
Updated by Scott Kirkwood,
Belo Horizonte, Brazil

SPI by Hand part,
Originally by by Sebastian Tomczak, 20 July 2007
Adelaide, Australia
*/

const int CLK = 3; // set clock pin
const int MOSI = 4; // set master out, slave in (aka DI)
const int DO = 5;
const int CS1 = 6; // Chip select
const byte OFF = B00; // command byte LED off
const byte RED = B01; // command byte LED red on
const byte GRE = B10; // command byte LED green on
const byte ORA = B11; // BOTH red and green, orage.
int max_width = 8; // Width of image.

const int WIDTH = 8;
const int HEIGHT = 8;
byte message[HEIGHT * WIDTH];
int scroll_x = 0;
boolean in_scroll = false;
int index = 0;
char messages[] = {
  " GG  GG "
  " GG  GG "
  "        "
  "   GG   "
  "G  GG  G"
  "GG    GG"
  "GGGGGGGG"
  "  GGGG  "

  " OO  OO "
  " OO  OO "
  "        "
  "   OO   "
  "   OO   "
  "        "
  " OOOOOO "
  " OOOOOO "  

  "  GGGGGG"
  "  GGGGGG"
  "  GGGGGG"
  "  G    G"
  "  G    G"
  "  G    G"
  "GGG  GGG"
  "GGG  GGG"
  
  "        "
  "  RR RR "
  " RRRRRRR"
  " RRRRRRR"
  "  RRRRR "
  "   RRR  "
  "    R   "
  "        "
  "OO    OO"
  "OO    OO"
  " OO  OO "
  " OO  OO "
  "  O  O  "
  "  OOOO  "
  "  OOOO  "
  "   OO   "
  
  "GG    GG"
  "GG    GG"
  "GG    GG"
  "GGGGGGGG"
  "GGGGGGGG"
  "GG    GG"
  "GG    GG"
  "GG    GG"
  
};
void writeMessage(int pin, int offset_x, byte message[]) {
  start(pin);
  for (int y = 0; y < 8; y++) {
    for (int x = 0; x < 8; x++) {  
      byte b = getXY(x + offset_x, y);
      spi_transfer(b);
    }
  }
  stop(pin);
}

void start(int pin) {
  digitalWrite(pin, LOW);
  delay(1);
}

void stop(int pin) {
  delay(1);
  digitalWrite(pin, HIGH);
}

/* 
 * Transfer one byte to MOSI port.
 */
void spi_transfer(byte working) {
  for(int i = 0; i < 8; i++) { // setup a loop of 8 iterations, one for each bit
    delayMicroseconds(10);
    if (working > 127) { // test the most significant bit 
      digitalWrite(MOSI, HIGH); // if it is a 1 (ie. B1XXXXXXX), set the master out pin high
    }
    else {
      digitalWrite(MOSI, LOW); // if it is not 1 (ie. B0XXXXXXX), set the master out pin low
    }
    delayMicroseconds(10);
    digitalWrite(CLK,HIGH); // set clock high, the pot IC will read the bit into its register
    delayMicroseconds(10);
    digitalWrite(CLK,LOW); // set clock low, the pot IC will stop reading and prepare for the next iteration
    working = working << 1;
  }
}

void setup() {
  pinMode(CS1, OUTPUT);
  pinMode(CLK, OUTPUT);
  pinMode(MOSI, OUTPUT);
  pinMode(DO, INPUT);
  reset();
  startupSequence();
}

void startupSequence() {
  fillImage(GRE);
  writeMessage(CS1, 0, message);
  delay(200);
  fillImage(RED);
  writeMessage(CS1, 0, message);
  delay(200);
  fillImage(OFF);
  writeMessage(CS1, 0, message);
  reset();
}

void reset() {
  Serial.print("Reset\n");
  digitalWrite(CS1, HIGH); // High means ignore input
  max_width = 8;
  fillImage(OFF);
  index = 0;
}

void fillImage(byte color) {
  for (int i = 0; i < sizeof(message); i++) {
    message[i] = color;
  }
}

void startScroll() {
  writeMessage(CS1, 0, message);
}

void storeXY(int x, int y, byte ch) {
  if (x >= WIDTH) {
    x = WIDTH - 1;
  }
  if (y >= HEIGHT) {
    y = HEIGHT - 1;
  }
  message[y * WIDTH + x] = ch;
}

byte getXY(int x, int y) {
  if (x >= max_width || y >= HEIGHT || x < 0 || y < 0) {
    return OFF;
  }
  return message[y * WIDTH + x];
}

void loop() {
  byte chr;
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      chr = messages[index++];
      byte b = OFF;
      switch (chr) {
        case 'R':
          b = RED;
          break;
        case 'G':
          b = GRE;
          break;
        case 'O':
          b = ORA;
          break;
      }
      storeXY(col, row, b);
    }
  }
  startScroll();
  if (index > sizeof(messages)) {
    index = 0;
  }
  delay(1000);
}

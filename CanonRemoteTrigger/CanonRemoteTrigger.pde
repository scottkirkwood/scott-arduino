
// Original code from Bruce Allen 23/Jul/09

const int pwPin = 7;  // define pw pin for LV-MaxSonar-EZ1
const int camPin = 13; //define a pin for Camera

//variables needed to store values
long pulse, inches, cm;

void setup() {
  Serial.begin(9600); //Begin serial communcation
  all_output();
  pinMode(camPin, OUTPUT); // sets the digital pin as output
  pinMode(pwPin, INPUT);
  delay(1000); // Wait for MaxSonar to calibrate.
}

// This should lower the juice used on the board
void all_output() {
  for (int i = 0; i < 16; i++) {
    pinMode(i, OUTPUT);
  }
}

void shoot() {
  digitalWrite(camPin, HIGH);
  delay(500);
  digitalWrite(camPin, LOW);
}

int distance_cm() {
  //Used to read in the pulse that is being sent by the MaxSonar device.
  //Pulse Width representation with a scale factor of 147 uS per Inch.
  pulse = pulseIn(pwPin, HIGH);
  //147uS per inch
  inches = pulse/147;
  //change inches to centimetres
  return inches * 2.54;
}

void loop() {
  cm = distance_cm();
  if (cm < 35) {
    shoot();
    delay(10000);
  }
  delay(50);
}

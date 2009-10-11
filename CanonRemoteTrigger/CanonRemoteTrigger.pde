// Scott Kirkwood 
// Original code from Bruce Allen 23/Jul/09

const int pwPin = 7;  // define pw pin for LV-MaxSonar-EZ1
const int camPin = 13; //define a pin for Camera
const int distance = 20;  // cm
//variables needed to store values
long pulse, inches, cm;
int low_count = 0;
#define BATTERY 0
void setup() {
  if (!BATTERY) {
    Serial.begin(9600); //Begin serial communcation
    Serial.println("Ready for Canon Remote Trigger");
  }
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
  if (!BATTERY) {
    Serial.println("Shooting");
  }
  digitalWrite(camPin, HIGH);
  delay(800);
  digitalWrite(camPin, LOW);
  delay(100);
  digitalWrite(camPin, HIGH);
  delay(500);
  digitalWrite(camPin, LOW);
  delay(50);
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
  if (!BATTERY) {
    Serial.print("Distance ");
    Serial.println(cm);
  }
  if (cm < distance) {
    low_count++;
    if (low_count > 2) {
      shoot();
      delay(3000);
      low_count = 0;
    }
  }
  delay(500);
}

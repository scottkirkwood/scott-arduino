// Scott Kirkwood 
const int focusPin = 13;
const int triggerPin = 12;
const int everyMs = 5000;

void setup() {
  pinMode(focusPin, OUTPUT);
  pinMode(triggerPin, OUTPUT);
}

int shoot() {
  digitalWrite(triggerPin, HIGH);
  delay(500);
  digitalWrite(triggerPin, LOW);
  return 500;
}

void loop() {
  delay(everyMs - shoot());
}

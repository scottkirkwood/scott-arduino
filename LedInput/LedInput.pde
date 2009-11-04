// Taken from http://www.thebox.myzen.co.uk/Workshop/LED_Sensing.html
//
// This example shows one way of creating an optoswitch
// using an IR LED as emiter and an IR LED receiver as
// light sensor.
//
//           + GROUND                                 + analog pin 0
//           |                                        |  
//           <                                        < 
//           > 220 ohm resistor                       > 220 omh resistor
//           <                                        <      
//           |                                        |  
//           |                                        | cathode
//         -----                                    -----
//          / \    >>IR LED emiter >>>>>>>>>>>>>>>>  / \   IR LED receiver
//         -----                                    -----
//           |                                        | anode 
//           |                                        |
//           + +5VCD                                  +  Digital pin 7
//

#define numSensors 1

byte anodePin[] = { 7 }; 
byte cathodePin[] = { 0 };
int results[numSensors];
int refLevel[numSensors];
  
void setup() {
  _SFR_IO8(0x35) |= 0x10;   // global disable pull up resistors
  for (int i = 0; i < numSensors; i++) {
    digitalWrite(anodePin[i], LOW); // ensure pins go low immediatly after initilising them to outputs
    pinMode(anodePin[i], OUTPUT);   // declare the anode pins as outputs
    pinMode(cathodePin[i], INPUT); // declare the cathode pins as inputs
  }
  Serial.begin(115200);
}

void loop() {
  // turn all LEDs on
  for (int i = 0; i < numSensors; i++) {
    digitalWrite(anodePin[i], HIGH);
    pinMode(cathodePin[i], OUTPUT);    // Enable cathode pins as outputs
    digitalWrite(cathodePin[i], LOW);  // Turn ON LED
  } 
  
  // charge up LEDs cathode = HIGH, anode = LOW
  for (int i = 0; i < numSensors; i++) {
    digitalWrite(cathodePin[i], HIGH); 
    digitalWrite(anodePin[i], LOW);    
  }
  
  // Put cathode pins into measuring state (analogue input)
  for (int i = 0; i < numSensors; i++){
    pinMode(cathodePin[i], INPUT);
  }

  // Take a reading of the voltage level on the inputs to get a referance level before discharge
  for (int i = 0; i < numSensors; i++) {
    results[i] = analogRead(i);
  }
  
  //**********************************************************
  // LED discharge time or photon intergration time
  // The larger this is, the more sensitive is the system
  delay(40);  
  //**********************************************************

  // Read the sensors after discharge to measure the incedent light
  for (int i=numSensors-1; i>-1; i--) {  // reverse order reduces start to finish cross talk
     results[i] -= analogRead(i);     // subtract current reading from the referance to give the drop
     pinMode(cathodePin[i],OUTPUT);   // by discharging the LED immediatly the charge on the A/D input is removed and
     digitalWrite(cathodePin[i],LOW); // the cross talk between sensors is reduce
  }

  // print out the results or send it to Processing
  for (int i = 0; i<numSensors; i++) {
    Serial.print(results[i],DEC);
    Serial.print(" ");
  } 
  Serial.println(" ");
  delay(100);
}

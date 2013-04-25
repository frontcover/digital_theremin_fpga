/*
  Analog input, analog output, serial output
 
 Reads an analog input pin, maps the result to a range from 0 to 255
 and uses the result to set the pulsewidth modulation (PWM) of an output pin.
 Also prints the results to the serial monitor.
 
 The circuit:
 * input connected to analog pin 0.
 * LED connected from digital pin 14 to ground (on-board green LED)
 */

// These constants won't change.  They're used to give names
// to the pins used:
const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to
const int digPin0 = P2_0;
const int digPin1 = P2_1;
const int digPin2 = P2_2;
const int digPin3 = P2_3;
const int digPin4 = P2_4;
const int digPin5 = P2_5;
const int digPin6 = P2_6;

//
int sensorValue = 0;        // value read from the input
int outputValue = 0;        // value output to the PWM (analog out)

void setup() {
  pinMode(GREEN_LED,OUTPUT);
  pinMode(digPin0,OUTPUT);
  pinMode(digPin1,OUTPUT);
  pinMode(digPin2,OUTPUT);
  pinMode(digPin3,OUTPUT);
  pinMode(digPin4,OUTPUT);
  pinMode(digPin5,OUTPUT);
  pinMode(digPin6,OUTPUT);
}
  
void loop() {
  // read the analog in value:
  sensorValue = analogRead(analogInPin);            
  // map it to the range of the analog out:
  outputValue = map(sensorValue, 0, 1023, 0, 128); // 2^7  
  // change the analog out value:
  analogWrite(GREEN_LED, outputValue); 

  if (outputValue & 1)
    digitalWrite(digPin0,HIGH);
  else
    digitalWrite(digPin0,LOW);
    
  if (outputValue & 2)
    digitalWrite(digPin1,HIGH);
  else
    digitalWrite(digPin1,LOW);
    
  if (outputValue & 4)
    digitalWrite(digPin2,HIGH);
  else
    digitalWrite(digPin2,LOW);
    
  if (outputValue & 8)
    digitalWrite(digPin3,HIGH);
  else
    digitalWrite(digPin3,LOW);
    
  if (outputValue & 16)
   digitalWrite(digPin4,HIGH);
  else
    digitalWrite(digPin4,LOW);
     
  if (outputValue & 32)
   digitalWrite(digPin5,HIGH);
  else
    digitalWrite(digPin5,LOW);
     
  if (outputValue & 64)
    digitalWrite(digPin6,HIGH);
  else
    digitalWrite(digPin6,LOW);
   
  // wait 10 milliseconds before the next loop
  // for the analog-to-digital converter to settle
  // after the last reading:
  delay(10);                     
}

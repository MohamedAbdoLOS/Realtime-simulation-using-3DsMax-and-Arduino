
void setup()
{
 Serial.begin(9600);
 pinMode(A3, INPUT);
 pinMode(A4, INPUT);
 pinMode(A5, INPUT);
}

void loop()
{   
  int detct = analogRead(A5);
  int x_byte = analogRead(A3); 
  int y_byte = analogRead(A4);
  Serial.print(x_byte); 
  Serial.print(",");
  Serial.print(y_byte);
  Serial.print(",");
  Serial.println(detct);
  delay(300);
}



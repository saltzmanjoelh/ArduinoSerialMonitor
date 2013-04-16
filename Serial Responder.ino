int LED = 13;
int STATE = 0;
int didWake = 0;

void setup() {
  Serial.begin(9600);
  pinMode(LED, OUTPUT);
}

void loop() {
  if(!didWake){
    Serial.println("hello world");
    didWake = 1;
  }
  if (Serial.available() <= 0) {
    STATE = (STATE)? 0 : 1;
    if(STATE){
      digitalWrite(LED, HIGH); 
    }
    else{
      digitalWrite(LED, LOW);
    }
    delay(1000);
  }
  else{
    String content = "";
    char character;
  
    while(Serial.available()) {
        character = Serial.read();
        content.concat(character);
    }
    if (content != "") {
      Serial.println("ARDUINO RECV: "+content);
    }
  }
}

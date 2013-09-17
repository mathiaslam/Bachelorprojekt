
import processing.serial.*;


Serial myPort;  
boolean firstContactDone = false;
String typing = "";
String PD = "PD";

boolean offset = true;

void setup() {
  size(384, 384);

  // The camera can be initialized directly using an 
  // element from the array returned by list():
println(Serial.list());
  String portName = Serial.list()[8];
  myPort = new Serial(this, portName, 9600);
}



void draw() {

String[] lines = loadStrings("file.txt");
println("there are " + lines.length + " lines");
println(lines);



}


void keyReleased() {
  if (key != CODED) {
    switch(key) {
      case BACKSPACE:
      myPort.write(TAB);
      myPort.write(TAB);
      myPort.write("#");
      myPort.write(TAB);
      myPort.write(TAB);
      break;
      case ENTER:
      myPort.write("ä");
      myPort.write(TAB);
      myPort.write(TAB);
      myPort.write(RETURN);
      break;
      default:
      typing += key;
      myPort.write(typing);
    }
  }

  typing = "";
}


//void safeBytes () {
//
//  String         sum;
//
//  sum     = typedText; // Clear accumulated 8 bits
//
//  print(sum);
//  myPort.write(sum);
//}
//



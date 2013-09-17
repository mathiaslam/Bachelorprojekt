
import processing.serial.*;


Serial myPort;  
boolean firstContactDone = false;
String typing = "";
String PD = "PD";
String lines;
String php;

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


String[] php = loadStrings("http://localhost:8888/sketch_130917a/template/db.php?id=1");
fill(0);
text(php[0],10,100);


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
      
      String lines[] = loadStrings("http://localhost:8888/sketch_130917a/template/db.php");

println("there are " + lines.length + " lines");
for (int i = 0 ; i < lines.length; i++) {
  println(lines[i]);
}

println(lines[0]);
      
      typing += key;
      myPort.write(lines[0]);
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



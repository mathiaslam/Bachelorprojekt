PFont f;
String typing = "";
//String saved = "";
StringList blacklist;

void setup() {
  size(600,400);
  f = createFont("Menlo",11,true);
  String word;
  blacklist = new StringList();
}

void draw() {
  background(0);
  int indent = 25;
  textFont(f);
  fill(255);
  text(typing+(frameCount/10 % 2 == 0 ? "_" : ""), 20, 380);
  //text(saved,indent,130);
}

void keyReleased() {
  if (key != CODED) {
    switch(key) {
      case BACKSPACE:
      typing = typing.substring(0,max(0,typing.length()-1));
      break;
      case ENTER:
      case RETURN:
      blacklist.append(typing);
      blacklist.upper();
      typing = ""; 
      println(blacklist);
      break;
      default:
      typing += key;
    }
  }
}

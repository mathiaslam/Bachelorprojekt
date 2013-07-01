//Kurzer Test zur Eingabe von Texten in Processing.
//Nicht sinnvoll für mein Vorhaben, weshalb die nächsten
//Test mit XML oder besser noch JSON stattfinden werden.
//Falls diese Methoden nicht ausreichen (Performance) auf SQL
//zurückgreifen.
//
//Für die nächsten Tests wieder auf Netbeans umsteigen.

PrintWriter output;
PFont font;
String typedText = "";
void setup() {
 size(400, 400);
  font = createFont("Courier", 18);  
  output = createWriter("blacklist.txt"); 
}

void draw() {
  background(0);
  fill(255,255,255);
  textFont(font,18);
  text(typedText+(frameCount/10 % 2 == 0 ? "_" : ""), 35, 45);
}

void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case BACKSPACE:
      typedText = typedText.substring(0,max(0,typedText.length()-1));
      break;
    case TAB:
      typedText += "    ";
      break;
    case ENTER:
    case RETURN:
        output.println(typedText); 
        output.flush(); 
      typedText += "\n";
      break;
    case ESC:
    case DELETE:
      break;
    default:
      typedText += key;
    }
  }
}


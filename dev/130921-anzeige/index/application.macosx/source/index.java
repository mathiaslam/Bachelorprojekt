import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.bezier.data.sql.*; 
import java.util.Date; 
import java.util.Calendar; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class index extends PApplet {






Serial myPort;  
MySQL msql;
String typing = "";
PrintWriter output;
PFont font;
String typedText = "";
Timer refresh;

public void setup()
{
  size(displayWidth, displayHeight);
  font = loadFont("Monaco-10.vlw");

  println(Serial.list());
  String portName = Serial.list()[8];
  myPort = new Serial(this, portName, 9600);

  refresh = new Timer(1000);
  refresh.start();	

  String user     = "root";
  String pass     = "root";

  String database = "Bachelorprojekt";

  msql = new MySQL( this, "localhost:8889", database, user, pass );
  msql.connect();
  myPort.write("LBTyping");
}

public void draw()
{
  background(229);
  stroke(0);
  strokeWeight(2);
  fill(229);
  rect(20, 20, 1400, 860);
  noStroke();
  fill(0);
  rect(23, 23, 1395, 855);

  textFont(font, 10);
  text(typedText+(frameCount/10 % 2 == 0 ? "_" : ""), 35, 45);
  printWord();
  showTopBlackwords();
}

public void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case BACKSPACE:
      typedText = typedText.substring(0, max(0, typedText.length()-1));
      break;

    case ENTER:
    case RETURN:

      saveWord();
      typedText = "";

      break;
    case ESC:
    case DELETE:
      break;
    default:
      typedText += key;
    }
  }
}

public void printWord() {   
  if (refresh.isFinished()) {      
    msql.query( "SELECT word FROM `term` WHERE (level_id = 3 OR level_id = 4 ) ORDER BY RAND() LIMIT 1" );
    msql.next();
    //println( "number of rows: " + msql.getString(1) );
    String foundWord = msql.getString(1);
    //String foundWord = "Hosenkacker";
    int foundWordLength = foundWord.length();
    msql.query("SELECT word FROM `blacklist` WHERE word = '"+foundWord+"' AND hidden_until > DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 1 HOUR)");
    if (msql.next()) {
      println( "number of rows ####: " + foundWord );
      myPort.write(foundWord);
      for (int i=0; i < foundWordLength; i++) {         
        myPort.write(TAB);
        myPort.write(TAB);
        myPort.write("#");
        myPort.write(TAB);
        myPort.write(TAB);
      }
      myPort.write("\u00e4");
      myPort.write(TAB);
      myPort.write(TAB);
      myPort.write(RETURN);
    } 
    else {
      println( "number of rows: " + foundWord );
      myPort.write(foundWord);
      myPort.write("\u00e4");
      myPort.write(TAB);
      myPort.write(TAB);
      myPort.write(RETURN);
    }

    refresh.start();
  }
}

public void saveWord() {
  msql.query("SELECT word FROM `blacklist` WHERE word = '"+typedText+"'");
  if (msql.next()) {
    msql.query("UPDATE blacklist SET count = count + 1 WHERE word = '"+typedText+"'");
  } 
  else {  
    Calendar calendar = Calendar.getInstance();
    calendar.add(Calendar.HOUR, 6);
    Date dt = calendar.getTime();

    java.text.SimpleDateFormat sdf = 
      new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    String currentTime = sdf.format(dt);

    println(currentTime);

    msql.query("INSERT INTO `Bachelorprojekt`.`blacklist` (`word`, `count`, `anticount`, `hidden_until`) VALUES ('"+typedText+"', '1', '0', '"+currentTime+"');");
  }
}

public void showTopBlackwords() {
  StringList blackwords;
  fill(255);
  text("Last typed Blackwords", 45, 60);
  blackwords = new StringList();
  msql.query("SELECT word FROM blacklist ORDER BY id DESC LIMIT 10");
  int i = 0;
    while (msql.next ()) {
    String word = msql.getString(1);
    text(word, 45, 85+i*20);
    i++;
  }
}

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) 
  {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  public void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  public boolean isFinished() { 
    
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
  
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "index" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

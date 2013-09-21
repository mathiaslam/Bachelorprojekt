import de.bezier.data.sql.*;
import java.util.Date;
import java.util.Calendar;
import processing.serial.*;

Serial myPort;  
MySQL msql;
String typing = "";
PrintWriter output;
PFont font;
String typedText = "";
Timer refresh;

void setup()
{
  size( 400, 400 );
  font = createFont("Courier", 18);

  println(Serial.list());
  String portName = Serial.list()[8];
  myPort = new Serial(this, portName, 9600);

  refresh = new Timer(10000);
  refresh.start();	

  String user     = "root";
  String pass     = "root";

  String database = "Bachelorprojekt";

  msql = new MySQL( this, "localhost:8889", database, user, pass );
  msql.connect();
  myPort.write("LBTyping");
}

void draw()
{
  background(0);
  fill(255, 255, 255);
  textFont(font, 18);
  text(typedText+(frameCount/10 % 2 == 0 ? "_" : ""), 35, 45);
  printWord();
}

void keyReleased() {
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

void printWord() {   
  if (refresh.isFinished()) {      
    msql.query( "SELECT word FROM `term` WHERE (level_id = 3 OR level_id = 4 ) ORDER BY RAND() LIMIT 1" );
    msql.next();
    //println( "number of rows: " + msql.getString(1) );
    //String foundWord = msql.getString(1);
    String foundWord = "Hosenkacker";
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
      myPort.write("ä");
      myPort.write(TAB);
      myPort.write(TAB);
      myPort.write(RETURN);
    } 
    else {
      println( "number of rows: " + foundWord );
      myPort.write(foundWord);
      myPort.write("ä");
      myPort.write(TAB);
      myPort.write(TAB);
      myPort.write(RETURN);
    }

    refresh.start();
  }
}

void saveWord() {
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


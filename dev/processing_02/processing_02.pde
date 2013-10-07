import de.bezier.data.sql.*;
import java.util.Date;
import java.util.Calendar;
import processing.serial.*;
import java.text.SimpleDateFormat;

Serial myPort;  
MySQL msql;
String typing = ""; 
PrintWriter output;
PFont font;
String typedText = "";
Timer refresh;
StringList blacklist;
//StringList synonyms;
int synid;

void setup()
{
  size(displayWidth, displayHeight);
  font = loadFont("Monaco-10.vlw");

  println(Serial.list());
//  String portName = Serial.list()[8];
//  myPort = new Serial(this, portName, 9600);

  refresh = new Timer(1000);
  refresh.start();	

  String user     = "root";
  String pass     = "root";

  String database = "Bachelorprojekt";

  msql = new MySQL( this, "localhost:8889", database, user, pass );
  msql.connect();
//myPort.write("LBTyping");
  blacklist = new StringList();
  //synonyms =  new StringList();
}

void draw()
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
  fill(255);
  text(typedText+(frameCount/10 % 2 == 0 ? "_" : ""), 45, 860);
  printWord();
  showTopBlackwords();
  lastWords();
  synonyms();
  blackTimer();
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
    msql.query( "SELECT word, synset_id, level_id FROM `term` WHERE (level_id = 2 OR level_id = 3 OR level_id = 4 ) ORDER BY RAND() LIMIT 1" );
    msql.next();
    String foundWord = msql.getString(1);
    synid = msql.getInt("synset_id");
    
      msql.query("SELECT word FROM term WHERE synset_id='"+synid+"' LIMIT 10");
  int s = 0;
  while (msql.next ()) {
    String syn = msql.getString(1);
    fill(255);
    text(syn, 450, 85+s*20);
    //text(syn, 50, 450);
    text(syn+(frameCount/10 % 2 == 0 ? "_" : ""), 45, 450);
    s++;
    println("SYNONYM:"+syn);
    //delay(2000);
}
    
    //String foundWord = "Hosenkacker";
    int foundWordLength = foundWord.length();
    msql.query("SELECT word FROM `blacklist` WHERE word = '"+foundWord+"' AND hidden_until > DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 1 HOUR)");

    int blacklistSize = blacklist.size();
    if (blacklistSize > 9) {
      blacklist.remove(0);
      blacklist.append(foundWord);
    } 
    else {
      blacklist.append(foundWord);
    }

    //println(blacklist);

    if (msql.next()) {
      println( "number of rows ####: " + foundWord );
//      myPort.write(foundWord);
      for (int i=0; i < foundWordLength; i++) {         
//        myPort.write(TAB);
//        myPort.write(TAB);
//        myPort.write("#");
//        myPort.write(TAB);
//        myPort.write(TAB);
      }
//      myPort.write("ä");
//      myPort.write(TAB);
//      myPort.write(TAB);
//      myPort.write(RETURN);
    } 
    else {
      println( "WORT: " + foundWord );
//      myPort.write(foundWord);
//      myPort.write("ä");
//      myPort.write(TAB);
//      myPort.write(TAB);
//      myPort.write(RETURN);
    }
    refresh.start();
  }
}



void saveWord() {
  msql.query("SELECT word FROM `blacklist` WHERE word = '"+typedText+"'");
  if (msql.next()) {
    msql.query("UPDATE blacklist SET count = count + 1, hidden_until = ADDTIME(hidden_until, '2:00:00') WHERE word = '"+typedText+"'");
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

void showTopBlackwords() {
  fill(255);
  text("Last typed Blackwords", 45, 60);
  msql.query("SELECT word FROM blacklist ORDER BY id DESC LIMIT 10");
  int i = 0;
  while (msql.next ()) {
    String word = msql.getString(1);
    text(word, 45, 85+i*20);
    i++;
  }
}

void lastWords() {
  fill(255);
  text("Last words from Database", 200, 60);
  for (int i=0; i<blacklist.size(); i++) {
    String blackword = blacklist.get(i);
    text(blackword, 200, 85+i*20);
  }
}

void synonyms() {
  fill(255);
  text("Synonyms", 450, 60);
  msql.query("SELECT word FROM term WHERE synset_id='"+synid+"' LIMIT 10");
  int s = 0;
  while (msql.next ()) {
    String syn = msql.getString(1);
    fill(255);
    text(syn, 450, 85+s*20);
    s++;
  }
}

void blackTimer() {  
  fill(255);
  text("Blackword Timer", 800, 60);
  msql.query("SELECT hidden_until FROM blacklist WHERE hidden_until > current_timestamp LIMIT 10 ");
  int s = 0;
  while (msql.next ()) {
    String hidden_untiltime= msql.getString(1);

    Calendar calendar = Calendar.getInstance();
    Date dt = calendar.getTime();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = sdf.format(dt);

    String dateStart = currentTime; 
    String dateStop = hidden_untiltime;


    SimpleDateFormat format = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");

    Date d1 = null;
    Date d2 = null;


    try {
      d1 = format.parse(dateStart);

      d2 = format.parse(dateStop);

      //in milliseconds
      long diff = d2.getTime() - d1.getTime();
      


      long diffSeconds = diff / 1000 % 60;
      long diffMinutes = diff / (60 * 1000) % 60;
      long diffHours = diff / (60 * 60 * 1000) % 24;
      long diffDays = diff / (24 * 60 * 60 * 1000) ;

      fill(255);
      text(diffDays + " days, " + diffHours + " hours, " + diffMinutes + " minutes, " + diffSeconds + " seconds.", 800, 85+s*20);
      s++;

    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}


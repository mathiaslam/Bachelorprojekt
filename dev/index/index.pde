import de.bezier.data.sql.*;
import java.util.Date;

// created 2005-05-10 by fjenett
// updated fjenett 20081129


MySQL msql;
PrintWriter output;
PFont font;
String typedText = "";
Timer refresh;



void setup()
{
    size( 400,400 );
    font = createFont("Courier", 18);
    
    refresh = new Timer(5000);
    refresh.start();	
    // this example assumes that you are running the 
    // mysql server locally (on "localhost").
    //
	
    // replace --username--, --password-- with your mysql-account.
    //
    String user     = "root";
    String pass     = "root";
	
    // name of the database to use
    //
    String database = "Bachelorprojekt";
    // add additional parameters like this:
    // bildwelt?useUnicode=true&characterEncoding=UTF-8
	
    // connect to database of server "localhost"
    //
    msql = new MySQL( this, "localhost:8889", database, user, pass );
    msql.connect();
    
    
}

void draw()
{
  background(0);
  fill(255,255,255);
  textFont(font,18);
  text(typedText+(frameCount/10 % 2 == 0 ? "_" : ""), 35, 45);
  printWord();    

}

void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case BACKSPACE:
      typedText = typedText.substring(0,max(0,typedText.length()-1));
      break;
    case TAB:
      typedText += "";
      break;
    case ENTER:
    case RETURN:
      typedText += "\n";
      saveWord();
      
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
          String foundWord = msql.getString(1);
          msql.query("SELECT word FROM `blacklist` WHERE word = '"+foundWord+"' AND hidden_until > DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 1 HOUR)");
          if (msql.next()){
          println( "number of rows ####: " + foundWord );
          } else {
          println( "number of rows: " + foundWord );
            }
              
          refresh.start();
        }
 }
 
 void saveWord() {
   msql.query("SELECT word FROM `blacklist` WHERE word = '"+typedText+"'");
     if (msql.next()){
     msql.query("UPDATE");
     } else {  
        java.util.Date dt = new java.util.Date();

        java.text.SimpleDateFormat sdf = 
        new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        String currentTime = sdf.format(dt);
     
    
     msql.query("INSERT INTO `Bachelorprojekt`.`blacklist` (`word`, `count`, `anticount`, `hidden_until`) VALUES ('"+typedText+"', '1', '0', '"+currentTime+"');");
     }
 }

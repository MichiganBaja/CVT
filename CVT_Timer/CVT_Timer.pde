import processing.serial.*;

// Export to excel variables:
Table myTable;
boolean log=false, stop=false;
Serial myPort; 
String val;
int Run=1;

////////////////////////////////BUTTON CLASS/////////////////////////////////////////
public class Button {
  public int x, y, h, w;
  boolean clicked;
  
  Button(int X, int Y, int H, int W){
    x=X;
    y=Y;
    h=H;
    w=W;
    clicked=false;
  }
  
  void click_on(){
    clicked=true;
  }

  void click_off(){
    clicked=false;
  } 
  
  boolean overRect(){
    if (mouseX >= x && mouseX <= x+w && 
      mouseY >= y && mouseY <= y+h) {
      return true;
    } else {
      return false;
    }
  }  
}
/////////////////////////////////END OF BUTTON CLASS//////////////////////////////////

int prev=18, Cur=18, hover, run=1;
String Filename = str(month())+"." + (day()+"."+(year()-2000)+ "-Run1");
String[] words = {str(month()) + "_" + str(day())+"_" + run, "Fast Don't Lie", "Do the Creep", "For sure",
"28698", ".060", "None", "Less Aggressive", "2 Tungston", "1 Tungston", "2 Washers", "None", "Green", "50", 
"3", "Polaris", Filename, "Saving...", "Hello!"};
boolean upon=false;
PImage img;

void setup() {
  
  // Overall Screen:
  size(650, 495);
  
  img = loadImage("MichiganBajaRacingLogo.png");
  
  // Serial and table setup:
  String portName = Serial.list()[0];
  myTable = new Table();
  
  //set up your port to listen to the serial port
  myPort = new Serial(this, portName, 9600); 
  
  //the following are dummy columns for each data value
  myTable.addColumn("Run #");
  myTable.addColumn("Acceleration Time");
  myTable.addColumn("Creep?");
  myTable.addColumn("Additional Notes");
  
  myTable.addColumn("Primary Spring Model #");
  myTable.addColumn("Spider Spacing");
  myTable.addColumn("Sheave Coating");
  myTable.addColumn("Weight Profile");
  
  
  myTable.addColumn("Heel");
  myTable.addColumn("Base");
  myTable.addColumn("Middle");
  myTable.addColumn("Top");
  
  myTable.addColumn("Secondary Spring Color");
  myTable.addColumn("Helix Angle");
  myTable.addColumn("Pretension");
  myTable.addColumn("Belt");
  
   

}

void draw() {

  background(255, 255, 51);
  
  // Cause Baja :)
  image(img, 5, 20, img.width/1.6, img.height/1.6);
  
/////////////////////////////////ALL BUTTON CREATION//////////////////////////////////
  // Create Button Array:
  Button[] all= new Button[18];

  int X=-150, inc=160, Y=275;
  for (int i=0; i<16; i++) {
    if(i%4==3) Y=425;
    if(i%4==2) Y=375;
    if(i%4==1) Y=325;
    if(i%4==0){ Y=275; X+=inc;}   
    all[i] = new Button(X, Y, 40, 150);
  }
  
  // Start Button:
  all[16] = new Button(425, 30, 50, 100);
  
  // Stop Button:
  all[17] = new Button(535, 30, 50, 100);

  // Rectangle Asthetics:
  strokeWeight(2);
  fill(0, 39, 93);
  stroke(0, 0, 0);
  for (int i=0; i<16; i++)
    rect(all[i].x, all[i].y, all[i].w, all[i].h, 5);

  fill(51, 204, 51);
  if(log || hover==16) fill(80, 255, 0);
  stroke(0, 0, 0);
  rect(all[16].x, all[16].y, all[16].w, all[16].h, 2);

  fill(204, 0, 0);
  if(stop || hover==17) fill(255, 0, 0);
  stroke(0, 0, 0);
  rect(all[17].x, all[17].y, all[17].w, all[17].h, 2);
 
///////////////////////////////TEXT INSIDE BUTTONS////////////////////////////////////
  // Button text setup:
  textSize(12.25);
  fill(255,255,51);
  text("Run #", 17, 300);
  text("Acceleration Time", 17, 350);
  text("Creep?", 17, 400);
  text("Additional Notes", 17, 450);
  
  text("Primary Spring Model #", 177, 300);
  text("Spider Spacing", 177, 350);
  text("Sheave Coating", 177, 400);
  text("Weight Profile", 177, 450);
  
  text("Heel", 337, 300);
  text("Base", 337, 350);
  text("Middle", 337, 400);
  text("Top", 337, 450);
  
  text("Secondary Spring Color", 497, 300);
  text("Helix Angle", 497, 350);
  text("Pretension", 497, 400);
  text("Belt", 497, 450);
  
  textSize(25);
  fill(0,0,0);
  text("Start", 444, 63);
  text("Stop", 557, 63);
  
///////////////////////UPDATE BASED ON BUTTON PRESSED/////////////////////////////////
  for (int i=0; i<18; i++){
    if (all[i].overRect()){
      hover=i;
      upon=true;
    }
  }
  
  if(!upon)
    hover=prev;
  
  upon=false;
  
  textSize(40);
  fill(0, 0, 0);
  text(words[Cur], 325-(textWidth(words[Cur])/2), 200);
  
//////////////////////////////////EXCEL FILE CREATION/////////////////////////////////
  val = myPort.readStringUntil('\n'); 
    if (val!= null) { //We have a reading! Record it.
      val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
      //println(val); //Optional, useful for debugging
      words[1] = val; 
  
      //saves the table as a csv in the same folder as the sketch every numReadings. 
      if (stop){
        println("Stopped");
        saveTable(myTable, "../"+words[16]+".csv"); 
        stop=false;
        myTable.clearRows();
        Run++;
        words[16] = words[16].substring(0, words[16].length()-1);
        words[16] = words[16] + str(Run); 
      }   
     
      if (log){ 
        TableRow newRow = myTable.addRow(); //add a row for this new reading
        
        //record sensor information. Customize the names so they match your sensor column names. 
        newRow.setString("Run #", words[0]);
        newRow.setString("Acceleration Time", words[1]);
        newRow.setString("Creep?", words[2]);
        newRow.setString("Additonal Notes", words[3]);
        
        newRow.setString("Primary Spring Model #", words[4]);
        newRow.setString("Spider Spacing", words[5]);
        newRow.setString("Sheave Coating", words[6]);
        newRow.setString("Weight Profile", words[7]);
        
        newRow.setString("Heel", words[8]);
        newRow.setString("Base", words[9]);
        newRow.setString("Middle", words[10]);
        newRow.setString("Top", words[11]);
        
        newRow.setString("Secondary Spring Color", words[12]);
        newRow.setString("Helix Angle", words[13]);
        newRow.setString("Pretension", words[14]);
        newRow.setString("Belt", words[15]);
        
        run+=1;
        words[0] = str(month()) + "_" + str(day())+"_" + run;
      }  
    }
}

void mousePressed() {
  println(hover);
  Cur=hover;
  prev=hover;
  if (hover==17){stop=true; log=false; run=1;}
  if (hover==16) log=true;
}

void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (words[Cur].length() > 0) {
      words[Cur] = words[Cur].substring(0, words[Cur].length()-1);
    }
  } else if (keyCode == DELETE) {
    words[Cur] = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    words[Cur] = words[Cur] + key;
  }
}
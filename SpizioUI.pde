/*

This program implements a UI Prototype for Spizio in Processing (.pde).
Screen state information is communicated to an onboard Arduino through
serial communication at a default 9600 baud rate.

*/


import java.awt.AWTException;
import java.awt.Robot;

Robot pos;

//Define coordinates of each button in the UI as a percentage of height and width of screen
//This makes the UI scalable
int wide=700, high=944;
float spiceX=0.052669*wide, spiceY=0.101563*high, spiceW=0.27809*wide, spiceH=0.103646*high;
float spiceRectX=0.098315*wide, spiceRectY=0.190667*high, spiceRectW=0.179775*wide, spiceRectH=0.013542*high; 
float blendX=0.490101*wide, blendY=0.101563*high, blendW=0.527388*wide, blendH=0.103646*high;
float blendRectX=0.512107*wide, blendRectY=0.190667*high, blendRectW=0.428096*wide, blendRectH=0.013542*high; 
float spice1X=0.056882*wide, spice1Y=0.243229*high, spice1W=0.252107*wide, spice1H=0.082813*high;
float spice2X=0.056882*wide, spice2Y=0.335938*high, spice2W=0.252107*wide, spice2H=0.082813*high;
float spice3X=0.056882*wide, spice3Y=0.428646*high, spice3W=0.252107*wide, spice3H=0.082813*high;
float spice4X=0.056882*wide, spice4Y=0.521354*high, spice4W=0.252107*wide, spice4H=0.082813*high;
float spice5X=0.056882*wide, spice5Y=0.614063*high, spice5W=0.252107*wide, spice5H=0.082813*high;
float spice6X=0.056882*wide, spice6Y=0.706771*high, spice6W=0.252107*wide, spice6H=0.082813*high;
float manualX=0.572331*wide, manualY=0.232292*high, manualW=0.365871*wide, manualH=0.094792*high;
float tspX=0.572331*wide, tspY=0.327083*high, tspW=0.181882*wide, tspH=0.094792*high;
float tbspX=0.755618*wide, tbspY=0.326042*high, tbspW=0.182584*wide, tbspH=0.094792*high;
float sel14X=0.572331*wide, sel14Y=0.420313*high, sel14W=0.365871*wide, sel14H=0.095313*high;
float sel12X=0.572331*wide, sel12Y=0.514583*high, sel12W=0.365871*wide, sel12H=0.095313*high;
float sel34X=0.572331*wide, sel34Y=0.609896*high, sel34W=0.365871*wide, sel34H=0.095313*high;
float s1X=0.572331*wide, s1Y=0.704167*high, s1W=0.365871*wide, s1H=0.095313*high;
float dispenseX=(189/1424.0)*wide, dispenseY=(1610/1920.0)*high, dispenseW=(1047/1424.0)*wide, dispenseH=(165/1920.0)*high;
float settingsX=(1182/1424.0)*wide, settingsY=0, settingsW=(208/1424.0)*wide, settingsH=(196/1920.0)*high;
float mainscreenX=0, mainscreenY=(200/1920.0)*high, mainscreenW=(711/1424.0)*wide, mainscreenH=(858/1920.0)*high;
float spicelistX=(713/1424.0)*wide, spicelistY=(200/1920.0)*high, spicelistW=(711/1424.0)*wide, spicelistH=(858/1920.0)*high;
float blendlistX=0, blendlistY=(1058/1920.0)*high, blendlistW=(711/1424.0)*wide, blendlistH=(858/1920.0)*high;
float calibrateX=(713/1424.0)*wide, calibrateY=(1058/1920.0)*high, calibrateW=(711/1424.0)*wide, calibrateH=(858/1920.0)*high;

int selR=200, selG=200, selB=200, selT=70;
int rectR=196, rectG=196, rectB=196, rectT=200;

import processing.serial.*;
Serial myPort;

PImage spiceNoManualScreen, spiceManualScreen, blendNoManualScreen, blendManualScreen, blendDispensingScreen, spiceDispensingScreen, settingsScreen;
int y;
boolean selSpice=true, selTsp=false, sel14=true, sel12=false, sel34=false, sel1=false, manual=false;
boolean[] selSpiceList= {true, false, false, false, false, false};
boolean dispensing = false, settings=true;
int time_until = 0, done=0;
boolean manualDispensing=false;

void setup() {
  size(700, 944);
  // The background image must be the same size as the parameters
  // into the size() method. In this program, the size of the image
  // is 700 x 944 pixels.
  spiceNoManualScreen = loadImage("spiceNoManualScreen.png");
  spiceManualScreen = loadImage("spiceManualScreen.png");
  blendNoManualScreen = loadImage("blendNoManualScreen.png");
  blendManualScreen = loadImage("blendManualScreen.png");
  blendDispensingScreen = loadImage("blendDispensingScreen.png");
  spiceDispensingScreen = loadImage("spiceDispensingScreen.png");
  settingsScreen=loadImage("settingsScreen.png");
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  //if in the settings screen
  if (settings) {
    //mainscreen
    background(settingsScreen);
    if (mouseX <= mainscreenX+mainscreenW && mouseX >=mainscreenX && mouseY >= mainscreenY && mouseY <= mainscreenY+mainscreenH) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(mainscreenX, mainscreenY, mainscreenW, mainscreenH);
    }

    //spice list
    if (mouseX <= spicelistX+spicelistW && mouseX >=spicelistX && mouseY >= spicelistY && mouseY <= spicelistY+spicelistH) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spicelistX, spicelistY, spicelistW, spicelistH);
    }

    //blend list
    if (mouseX <= blendlistX+blendlistW && mouseX >=blendlistX && mouseY >= blendlistY && mouseY <= blendlistY+blendlistH) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(blendlistX, blendlistY, blendlistW, blendlistH);
    }

    //calibrate
    if (mouseX <= calibrateX+calibrateW && mouseX >=calibrateX && mouseY >= calibrateY && mouseY <= calibrateY+calibrateH) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(calibrateX, calibrateY, calibrateW, calibrateH);
    }
  }

  //if not on the settings screen, display main screen
  if (!settings) {
    if (selSpice==true) {
      if (dispensing==true)
        background(spiceDispensingScreen);
      else if (manual==true) {
        background(spiceManualScreen);
      } else {
        background(spiceNoManualScreen);
      }
    } else {
      if (dispensing==true)
        background(blendDispensingScreen);
      else if (manual==true) {
        background(blendManualScreen);
      } else {
        background(blendNoManualScreen);
      }
    }

    //MANUAL
    if (manual==true)
    {
      fill(selR, selG, selB, selT);
      rect(manualX, manualY, manualW, manualH);
    }

    if (!dispensing && mouseX >= manualX && mouseX <= manualX+manualW && mouseY >= manualY && mouseY <= manualY+manualH && !manual) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(manualX, manualY, manualW, manualH);
    }

    //hold to dispense
    if (mouseX >= dispenseX && mouseX <= dispenseX+dispenseW && mouseY >= dispenseY && mouseY <= dispenseY+dispenseH && manual) {
      if (manualDispensing==false) {
        manualDispensing=true;
        int var4=0;
        for (int i=0; i<6; i++)
          if (selSpiceList[i]==true)
            var4=i;
        if (selSpice==true)
          myPort.write(100+var4*10);

        else
          myPort.write(6);
      }
      strokeWeight(0);
      fill(100, 0, 0, 25);
      rect(dispenseX, dispenseY, dispenseW, dispenseH, 17.5);
    }

    //SPICES
    if (selSpice==true)
    {
      strokeWeight(0);
      fill(rectR, rectG, rectB, rectT);
      rect(spiceRectX, spiceRectY, spiceRectW, spiceRectH);
    }

    if (!dispensing && mouseX >= spiceX && mouseX <= spiceX+spiceW && mouseY >= spiceY && mouseY <= spiceY+spiceH && !selSpice) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spiceRectX, spiceRectY, spiceRectW, spiceRectH);
    }

    //SPICE BLENDS
    if (selSpice==false)
    {
      strokeWeight(0);
      fill(rectR, rectG, rectB, rectT);
      rect(blendRectX, blendRectY, blendRectW, blendRectH);
    }

    if (!dispensing && mouseX <= blendX+blendW && mouseX >=blendX && mouseY >= blendY && mouseY <= blendY+blendH && selSpice) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(blendRectX, blendRectY, blendRectW, blendRectH);
    }

    //TSP
    if (selTsp==true && !manual)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(tspX, tspY, tspW, tspH);
    }

    if (!dispensing && !manual && mouseX <= tspX+tspW && mouseX >=tspX && mouseY >= tspY && mouseY <= tspY+tspH && !selTsp) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(tspX, tspY, tspW, tspH);
    }

    //TBSP
    if (selTsp==false && !manual)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(tbspX, tbspY, tbspW, tbspH);
    }

    if (!dispensing && !manual && mouseX <= tbspX+tbspW && mouseX >=tbspX && mouseY >= tbspY && mouseY <= tbspY+tbspH && selTsp) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(tbspX, tbspY, tbspW, tbspH);
    }

    //Spice1
    if (selSpiceList[0]==true)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice1X, spice1Y, spice1W, spice1H);
    }

    if (!dispensing && mouseX <= spice1X+spice1W && mouseX >=spice1X && mouseY >= spice1Y && mouseY <= spice1Y+spice1H && !selSpiceList[0]) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice1X, spice1Y, spice1W, spice1H);
    } 

    //Spice2
    if (selSpiceList[1]==true)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice2X, spice2Y, spice2W, spice2H);
    }

    if (!dispensing && mouseX <= spice2X+spice2W && mouseX >=spice2X && mouseY >= spice2Y && mouseY <= spice2Y+spice2H && !selSpiceList[1]) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice2X, spice2Y, spice2W, spice2H);
    }

    //Spice3
    if (selSpiceList[2]==true)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice3X, spice3Y, spice3W, spice3H);
    }

    if (!dispensing && mouseX <= spice3X+spice3W && mouseX >=spice3X && mouseY >= spice3Y && mouseY <= spice3Y+spice3H  && !selSpiceList[2]) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice3X, spice3Y, spice3W, spice3H);
    }

    //Spice4
    if (selSpiceList[3]==true)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice4X, spice4Y, spice4W, spice4H);
    }

    if (!dispensing && mouseX <= spice4X+spice4W && mouseX >=spice4X && mouseY >= spice4Y && mouseY <= spice4Y+spice4H  && !selSpiceList[3]) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice4X, spice4Y, spice4W, spice4H);
    }

    //Spice5
    if (selSpiceList[4]==true)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice5X, spice5Y, spice5W, spice5H);
    }

    if (!dispensing && mouseX <= spice5X+spice5W && mouseX >=spice5X && mouseY >= spice5Y && mouseY <= spice5Y+spice5H && !selSpiceList[4]) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice5X, spice5Y, spice5W, spice5H);
    }

    //Spice6
    if (selSpiceList[5]==true)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice6X, spice6Y, spice6W, spice6H);
    }

    if (!dispensing && mouseX <= spice6X+spice6W && mouseX >=spice6X && mouseY >= spice6Y && mouseY <= spice6Y+spice6H && !selSpiceList[5]) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(spice6X, spice6Y, spice6W, spice6H);
    }

    //0.25
    if (sel14==true && !manual)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(sel14X, sel14Y, sel14W, sel14H);
    }

    if (!dispensing && !manual && mouseX <= sel14X+sel12Y && mouseX >=sel14X && mouseY >= sel14Y && mouseY <= sel14Y+sel14H && !sel14) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(sel14X, sel14Y, sel14W, sel14H);
    }

    //0.5
    if (sel12==true && !manual)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(sel12X, sel12Y, sel12W, sel12H);
    }

    if (!dispensing && !manual && mouseX <= sel12X+sel12W && mouseX >=sel12X && mouseY >= sel12Y && mouseY <= sel12Y+sel12H && !sel12) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(sel12X, sel12Y, sel12W, sel12H);
    }

    //0.75
    if (sel34==true && !manual)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(sel34X, sel34Y, sel34W, sel34H);
    }

    if (!dispensing && !manual && mouseX <= sel34X+sel34W && mouseX >=sel34X && mouseY >= sel34Y && mouseY <= sel34Y+sel34H && !sel34) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(sel34X, sel34Y, sel34W, sel34H);
    }

    //1
    if (sel1==true && !manual)
    {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(s1X, s1Y, s1W, s1H);
    }

    if (!dispensing && !manual && mouseX <= s1X+s1W && mouseX >=s1X && mouseY >= s1Y && mouseY <= s1Y+s1H && !sel1) {
      strokeWeight(0);
      fill(selR, selG, selB, selT);
      rect(s1X, s1Y, s1W, s1H);
    } 
    //}

    //dispense
    if (dispensing) {
      fill(255, 0, 0, 50);
      rect(dispenseX, dispenseY, dispenseW, dispenseH, 17.5);
      while (myPort.available() < 0) {
      }
      int inByte = myPort.read();
      if (inByte==65) {
        dispensing = false;
        done=millis();
      }
    }

    if (millis()<done+800) {
      fill(0, 181, 67, 50);
      rect(dispenseX, dispenseY, dispenseW, dispenseH, 17.5);
    } else done=0;
  }
}

void mouseReleased() {
  if (!settings) {
    //SPICES
    if (!dispensing && mouseX <= spiceX+spiceW && mouseX >= spiceX && mouseY >= spiceY && mouseY <= spiceY+spiceH && !selSpice) {
      selSpice = true;
    }

    //SPICE BLENDS
    if (!dispensing && mouseX <= blendX+blendW && mouseX >=blendX && mouseY >= blendY && mouseY <= blendY+blendH && selSpice) {
      selSpice=false;
    }

    //TSP
    if (!dispensing && mouseX <= tspX+tspW && mouseX >=tspX && mouseY >= tspY && mouseY <= tspY+tspH && (!selTsp||manual)) {
      selTsp = true;
      manual = false;
    }

    //TBSP
    if (!dispensing && mouseX <= tbspX+tbspW && mouseX >=tbspX && mouseY >= tbspY && mouseY <= tbspY+tbspH && (selTsp||manual)) {
      selTsp=false;
      manual = false;
    }
	
	void setSpice(int num){
		//check if it's a valid spice
		if(num>5) return;
		
		for (int i=0; i<6; i++){
			selSpiceList[i]=false;
		}
		selSpiceList[num]=true
	}

    //SPICE 1
    if (!dispensing && mouseX <= spice1X+spice1W && mouseX >=spice1X && mouseY >= spice1Y && mouseY <= spice1Y+spice1H && !selSpiceList[0]) {
      setSpice(0);
    }

    //SPICE 2
    if (!dispensing && mouseX <= spice2X+spice2W && mouseX >=spice2X && mouseY >= spice2Y && mouseY <= spice2Y+spice2H && !selSpiceList[1]) {
      setSpice(1);
    }

    //SPICE 3
    if (!dispensing &&mouseX <= spice3X+spice3W && mouseX >=spice3X && mouseY >= spice3Y && mouseY <= spice3Y+spice3H && !selSpiceList[2]) {
      setSpice(2);
    }

    //SPICE 4
    if (!dispensing && mouseX <= spice4X+spice4W && mouseX >=spice4X && mouseY >= spice4Y && mouseY <= spice4Y+spice4H  && !selSpiceList[3]) {
      setSpice(3);
    }

    //SPICE 5
    if (!dispensing && mouseX <= spice5X+spice5W && mouseX >=spice5X && mouseY >= spice5Y && mouseY <= spice5Y+spice5H && !selSpiceList[4]) {
      setSpice(4);
    }

    //SPICE 6
    if (!dispensing && mouseX <= spice6X+spice6W && mouseX >=spice6X && mouseY >= spice6Y && mouseY <= spice6Y+spice6H&& !selSpiceList[5]) {
      setSpice(5);
    }

    //sel14
    if (!dispensing && mouseX <= sel14X+sel14W && mouseX >=sel14X && mouseY >= sel14Y && mouseY <= sel14Y+sel14H && (manual||!sel14)) {
      sel14 = true;
      sel12 = false;
      sel34 = false;
      sel1 = false;
      manual = false;
    }

    //sel12
    if (!dispensing && mouseX <= sel12X+sel12W && mouseX >=sel12X && mouseY >= sel12Y && mouseY <= sel12Y+sel12H && (manual||!sel12)) {
      sel14 = false;
      sel12 = true;
      sel34 = false;
      sel1 = false;
      manual = false;
    }

    //sel34
    if (!dispensing && mouseX <= sel34X+sel34W && mouseX >=sel34X && mouseY >= sel34Y && mouseY <= sel34Y+sel34H && (!sel34||manual)) {
      sel14 = false;
      sel12 = false;
      sel34 = true;
      sel1 = false;
      manual = false;
    }

    //sel1
    if (!dispensing && mouseX <= s1X+s1W && mouseX >=s1X && mouseY >= s1Y && mouseY <= s1Y+s1H && (!sel1||manual)) {
      sel14 = false;
      sel12 = false;
      sel34 = false;
      sel1 = true;
      manual = false;
    }

    //manual
    if (!dispensing && mouseX <= manualX+manualW && mouseX >=manualX && mouseY >= manualY && mouseY <= manualY+manualH) {
      manual = !manual;
    }

    //dispense
    if (!dispensing && mouseX <= dispenseX+dispenseW && mouseX >=dispenseX && mouseY >= dispenseY && mouseY <= dispenseY+dispenseH && !manual) {
      time_until = millis();
      dispensing=true;
      int var1=0, var2=0, var3=0, var4=0, var5=0;

      if (selSpice==true)
        var1=1;
      else var1=2;

      if (selTsp==true)
        var2=1;
      else var2=2;

      if (sel14==true)
        var3=1;
      else if (sel12==true)
        var3=2;
      else if (sel34==true)
        var3=3;
      else 
      var3=4;

      for (int i=0; i<6; i++)
        if (selSpiceList[i]==true)
          var4=i;

      if (selSpice==true) {
		//send to Arduino
        myPort.write(200+var4*10+var3);
        println(200+var4*10+var3);
      } else myPort.write(var3);
      println(var3);
    }

    //hold to dispense
    if (manual == true && mouseX <= dispenseX+dispenseW && mouseX >=dispenseX && mouseY >= dispenseY && mouseY <= dispenseY+dispenseH) {
	#move mouse away from the dispense button
	#this is only if the screen is implemented on a laptop
      try {
        pos = new Robot();
        pos.mouseMove(800, 250);
      }
      catch(AWTException e) {
        e.printStackTrace();
      }
      myPort.write(15);
      delay(300);
      manualDispensing=false;
    }
    //settings
    if (mouseX <= settingsX+settingsW && mouseX >=settingsX && mouseY >= settingsY && mouseY <= settingsY+settingsH) {
      settings=true;
    }
  }
  if (settings) {
    //settings
    if (mouseX <= mainscreenX+mainscreenW && mouseX >=mainscreenX && mouseY >= mainscreenY && mouseY <= mainscreenY+mainscreenH) {
      settings=false;
    }
  }
}

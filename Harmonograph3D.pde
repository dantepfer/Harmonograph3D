import processing.sound.*;

import controlP5.*;

ControlP5 cp5;

float camSpeed = 50;
float rotIncr = .1;
PVector camDir, camPos; 
float camRotY=-PI; //camera azimuth angle
float camRotX=0; //camera elevation angle

float rotTheta=10;

float baseFreq = 440.0;


float theta1 = 0;  
float theta2 = 0;
float theta3 = 0;
public float theta1Incr = .1;
public float theta2Incr = .15;
public float theta3Incr = .2;
public int iterations = 4000;

int scaleFactor = 400;
PFont myFont;

SinOsc[] sine = new SinOsc[3];

void setup() {
  //size(1400, 800, P3D); 
  fullScreen(P3D);
  pixelDensity(2);
  camDir = new PVector(0,0,-1);
  camPos = new PVector(width/2,height/2,1000);
  myFont = createFont("Georgia", 15); 
  
  
  cp5 = new ControlP5(this);
  
    cp5.addSlider("theta1Incr")
     .setPosition(100,50)
     .setRange(.01,.2)
     ;

  
  //controlP5 = new ControlP5(this);
  // controlP5.setAutoDraw(false);
  //controlWindow = controlP5.addControlWindow("controlP5window",100,100,1000,200);
  //controlWindow.hideCoordinates();
  
  //controlWindow.setBackground(color(40));
  //controlP5.Controller mySlider1 = controlP5.addSlider("theta1Incr",.01,.2,40,40,800,10);
  //controlP5.Controller mySlider2 = controlP5.addSlider("theta2Incr",.01,.2,40,60,800,10);
  //controlP5.Controller mySlider3 = controlP5.addSlider("theta3Incr",.01,.2,40,80,800,10);
  //controlP5.Controller mySlider4 = controlP5.addSlider("iterations",2000,50000,40,100,800,10);
  
  //Textfield field1 = controlP5.addTextfield("field1",900,40,40,20);
  //Textfield field2 = controlP5.addTextfield("field2",900,60,40,20);
  //Textfield field3 = controlP5.addTextfield("field3",900,80,40,20);
  
  //mycheckbox = controlP5.addCheckBox("checkBox",40,120);
  //mycheckbox.addItem("RotX",1);
  //mycheckbox.addItem("RotY",1);
  //mycheckbox.addItem("RotZ",1);
  
  //mycheckbox.moveTo(controlWindow);
  
  //mySlider1.setWindow(controlWindow);
  //mySlider2.setWindow(controlWindow);
  //mySlider3.setWindow(controlWindow);
  //field1.setWindow(controlWindow);
  //field2.setWindow(controlWindow);
  //field3.setWindow(controlWindow);
  //mySlider4.setWindow(controlWindow);
  
  //field1.setAutoClear(false);
  //field2.setAutoClear(false);
  //field3.setAutoClear(false);
     
  for (int i = 0; i<3; i++){
     sine[i] = new SinOsc(this);
  }
  sine[0].set(baseFreq, 0.5, 0, 0.5);
  sine[1].set(baseFreq*theta2Incr/theta1Incr, 0.5, 0, 0.5);
  sine[2].set(baseFreq*theta3Incr/theta1Incr, 0.5, 0, 0.5);
  
  for (int i = 0; i<3; i++){
     sine[i].play();
  }
  
  
}





void draw() {
  
  background(255);
  stroke(0);
  
 // theta3Incr -= .0000005;
//  theta2Incr += .0000005;
  
  
   checkCameraInput();
   camera(camPos.x, camPos.y, camPos.z, // eyeX, eyeY, eyeZ
         camPos.x+camDir.x,camPos.y+camDir.y,camPos.z+camDir.z, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
         
  translate (width/2, height/2, 0);
  scale (scaleFactor);
         
  rotateY(rotTheta);
  
  if (keyPressed && key == 'r'){
  }
  else{
    rotTheta = rotTheta+.01;
  }
  
  textFont(myFont); 
  fill(0);
  textMode(MODEL);
  text("a:"+str(theta1Incr)+"    b:"+str(theta2Incr)+"    c:"+str(theta3Incr),20,20);
  
  for (int i=0; i<iterations; i++){
 //if (mycheckbox.arrayValue()[0] == 1) {rotateX(theta1Incr/16);}
 //if (mycheckbox.arrayValue()[1] == 1) {rotateY(theta1Incr/16);}
 //if (mycheckbox.arrayValue()[2] == 1) {rotateZ(theta1Incr/16);}
 //scale(.999999);
 strokeWeight(2);
    line(sin(theta1+i*theta1Incr), cos(theta2+i*theta2Incr), cos(theta3+i*theta3Incr), sin(theta1+(i+1)*theta1Incr), cos(theta2+(i+1)*theta2Incr), cos(theta3+(i+1)*theta3Incr));
  }
  

  //controlP5.draw();
  
  sine[0].freq(baseFreq);
    sine[1].freq(baseFreq*theta2Incr/theta1Incr);
    sine[2].freq(baseFreq*theta3Incr/theta1Incr);


}


void checkCameraInput() {
if (keyPressed) {
    if (keyCode == LEFT) {
      camRotY = camRotY + rotIncr;
    } 
    if (keyCode == RIGHT) {
      camRotY = camRotY - rotIncr;
    } 
    if (keyCode == UP) {
      camRotX = camRotX - rotIncr;
    } 
    if (keyCode == DOWN) {
      camRotX = camRotX + rotIncr;
    } 
    if (key == 'a') {
      camDir.mult(camSpeed);
      camPos.add(camDir);
    } 
    if (key == 'z') {
      camDir.mult(camSpeed);
      camPos.sub(camDir);
    } 
 camDir.set(sin(camRotY)*cos(camRotX),sin(camRotX),cos(camRotY)*cos(camRotX));
}

}



//public void field1(String theText) {
//  // receiving text from controller texting
//  if (float(theText) > 0 && float(theText) <1){
//  theta1Incr = float(theText);
//  }
//  controlP5.controller("theta1Incr").setValue(theta1Incr);
//}

//public void field2(String theText) {
//  // receiving text from controller texting
//  if (float(theText) > 0 && float(theText) <1){
//  theta2Incr = float(theText);
//  }
//  controlP5.controller("theta2Incr").setValue(theta2Incr);
//}

//public void field3(String theText) {
//  // receiving text from controller texting
//  if (float(theText) > 0 && float(theText) <1){
//  theta3Incr = float(theText);
//  }
//  controlP5.controller("theta3Incr").setValue(theta3Incr);
//}
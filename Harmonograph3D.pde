import processing.sound.*;

import controlP5.*;

ControlP5 cp5;

float camSpeed = 50;
float rotIncr = .1;
PVector camDir, camPos; 
float camRotY=-PI; //camera azimuth angle
float camRotX=0; //camera elevation angle
float rotationSpeed = 0.01;
int shouldRotate = 0;

float rotThetaY=10;
float rotThetaX=0;

float baseFreq = 440.0;

float theta1 = 0;  
float theta2 = 0;
float theta3 = 0;
public float theta1Incr = 4;
public float theta2Incr = 5;
public float theta3Incr = 6;
float thetaScaleFactor = 0.005;
public int iterations = 35000;
int detuneB = 0;
int detuneC = 0;
float detuneAmountPerFrame2 = 0.00001;
float detuneAmountPerFrame3 = -0.00001;
float mouseDeltaX=0;
float mouseDeltaY=0;

int scaleFactor = 1;
int scaleFactor2 = 400;
PFont myFont;
CheckBox checkBox;

SinOsc[] sine = new SinOsc[3];

void setup() {
  //size(1400, 800, P3D);
  fullScreen(P3D);
  pixelDensity(2);
  smooth();
  camDir = new PVector(0,0,-1);
  camPos = new PVector(width/2,height/2,1200);
  myFont = createFont("Serif-15",15); 
  
  
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  cp5.addSlider("theta1Incr")
    .setPosition(20,50)
    .setRange(1,20)
    .setSize(20,300)
    .setNumberOfTickMarks(20)
    .showTickMarks(false)
    .setColorCaptionLabel(0) 
    .setCaptionLabel("   a") 
  ;
  
    cp5.addSlider("theta2Incr")
     .setPosition(50,50)
     .setRange(1,20)
     .setSize(20,300)
     .setNumberOfTickMarks(20)
     .showTickMarks(false)
     .setColorCaptionLabel(0) 
    .setCaptionLabel("   b") 
  ;
  
    cp5.addSlider("theta3Incr")
     .setPosition(80,50)
     .setRange(1,20)
     .setSize(20,300)
     .setNumberOfTickMarks(20)
     .showTickMarks(false)
     .setColorCaptionLabel(0) 
     .setCaptionLabel("   c") 
  ;
  
checkBox = cp5.addCheckBox("checkBox")
                .setPosition(20, 400)
                .setSize(20, 20)
                .setItemsPerRow(1)
                .setSpacingColumn(40)
                .setSpacingRow(10)
                .addItem("rotate", 1)
                .addItem("detuneB", 0)
                .addItem("detuneC", 0)
                .setColorLabels(0)
       ;
       
       if(shouldRotate==1){
         checkBox.toggle(0);
       }
         

  cp5.addSlider("iterations")
     .setPosition(width-50,50)
     .setRange(1,50000)
     .setSize(20, height -100)
  ;
     
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
  
  if(detuneB==1){
    theta2Incr += detuneAmountPerFrame2;
  }
    if(detuneC==1){
    theta3Incr += detuneAmountPerFrame3;
  }
   
   checkCameraInput();
   camera(camPos.x, camPos.y, camPos.z, // eyeX, eyeY, eyeZ
         camPos.x+camDir.x,camPos.y+camDir.y,camPos.z+camDir.z, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
         
  translate(width/2, height/2, 0);
   scale (scaleFactor);
            
  decrementRotation();
  rotThetaY += mouseDeltaX/100.0;
  rotThetaX -= mouseDeltaY/100.0;
            
  if (shouldRotate==1){
    rotThetaY += rotationSpeed;
  }
  
  rotateX(rotThetaX);
  rotateY(rotThetaY);

    for (int i=0; i<iterations; i++){
 strokeWeight(2);
    line(sin(theta1+i*theta1Incr*thetaScaleFactor)*scaleFactor, cos(theta2+i*theta2Incr*thetaScaleFactor)*scaleFactor, cos(theta3+i*theta3Incr*thetaScaleFactor)*scaleFactor,
    sin(theta1+(i+1)*theta1Incr*thetaScaleFactor)*scaleFactor, cos(theta2+(i+1)*theta2Incr*thetaScaleFactor)*scaleFactor, cos(theta3+(i+1)*theta3Incr*thetaScaleFactor)*scaleFactor);
  }
  
  camera(); //anthing after this is rendered in 2D
  
  textFont(myFont); 
  fill(0);
  text("a:"+str(theta1Incr)+"    b:"+str(theta2Incr)+"    c:"+str(theta3Incr),20,20);
  
  cp5.draw();
  
  sine[1].freq(baseFreq*theta2Incr/theta1Incr);
  sine[2].freq(baseFreq*theta3Incr/theta1Incr);


}


void checkCameraInput() {
if (keyPressed) {
    //if (keyCode == LEFT) {
    //  camRotY = camRotY + rotIncr;
    //} 
    //if (keyCode == RIGHT) {
    //  camRotY = camRotY - rotIncr;
    //} 
    //if (keyCode == UP) {
    //  camRotX = camRotX - rotIncr;
    //} 
    //if (keyCode == DOWN) {
    //  camRotX = camRotX + rotIncr;
    //} 
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


void mouseDragged(){
  if((mouseX > width/2 - 400) && (mouseX < width/2 + 400)
  && (mouseY > height/2 - 400) && (mouseY < height/2 + 400)){
       mouseDeltaX=mouseX-pmouseX;
       mouseDeltaY=mouseY-pmouseY;
}
}

//void mouseReleased(){
//       mouseDeltaX=0;
//       mouseDeltaY=0;
//}

void decrementRotation(){
  if (mouseX-pmouseX == 0 && abs(mouseDeltaX) > 0){
    mouseDeltaX /= 2;
  }
    if (mouseY-pmouseY == 0 && abs(mouseDeltaY) > 0){
    mouseDeltaY /= 2;
  }
  
}





//for checkboxes
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(checkBox)) {
      shouldRotate = (int)checkBox.getArrayValue()[0];
      detuneB = (int)checkBox.getArrayValue()[1];
      detuneC = (int)checkBox.getArrayValue()[2];
  }
}
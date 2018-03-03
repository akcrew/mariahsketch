import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

float em = 16; //#vertices
boolean newShape = false;
float aa = 2.0;
float bb = 2.0;
float step = 1;
int count1 =0;
float scale = 1;
float none = 2.0;
float ntwo = 2.0;
float nthree= 2.0;
float theta = 0;

void setup(){
  background(0);
  frameRate(50);
  size(1361, 700);
  //
  //noFill();
  //stroke(255);
  //strokeWeight(2);
  smooth();
  myBus = new MidiBus(this, 0, "Java Sound Synthesizer");
}

void draw() {
  //background(0);
  fill(0,5);
  rect(-5, -5, 1361,700);
  text("# of vertices: " + int(em), 10, 20);

  translate(width/2, height/2);
  int channel = 0;
  int number = 0;
  int value = 90;

  myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  //count1++;
  if (newShape){
    none = .635;
      ntwo = .635;
    nthree = 0;
    aa = .09;
    bb = 0;
    scale = 162.75876;
    step=9.431096;
    newShape = false;
    count1 = 0;
  }
  
  stroke(255, 22);
  noFill();
  beginShape();
  //addd vertices
  for(int i=1; i < 60; i++) {
  //for (float theta = 0; theta <= 2* PI; theta += 0.01){
   float rad = r(theta,
   aa, //a
   bb,  //b
   12,  //m
   none,  //n1
   ntwo,  //n2
   nthree   //n3
   );
    rad = rad* scale;
    theta = theta+step;
   float x = rad * cos(theta)*50;
   float y = rad * sin(theta)*50;
   vertex(x,y);
  //}
  }
  endShape();
}

float r(float theta, float a, float b, float m, float n1, float n2, float n3) {
  return pow(pow(abs(cos(m* theta / 4.0) / a),n2)  +  
  pow(abs(sin(m* theta / 4.0) / b),n3), -1.0 /n1) ;
}

void keyReleased(){
    
   if(keyCode == ' '){newShape = true;}
   print("ahh");
}
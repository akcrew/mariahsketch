import themidibus.*;
MidiBus myBus; //The MidiBus



float em = 16; //#vertices
float nn1 = 1;
float nn2 = 1;
float nn3 = 1;
float aa = 2;
float bb = 2;



void setup(){
  background(0);
  size(500, 500);
  fill(0,5);
  //noFill();
  stroke(255);
  strokeWeight(2);
  smooth();
  
  myBus = new MidiBus(this, 0, "Java Sound Synthesizer");
}

void draw() {
  int channel = 0;
  int number = 0;
  int value = 90;
  myBus.sendControllerChange(channel, number, value);
  background(0);
  text("# of vertices: " + int(em), 10, 20);

  translate(width/2, height/2);

  beginShape();
  //addd vertices
  for (float theta = 0; theta <= 2* PI; theta += 0.01){
   float rad = r(theta,
   aa,  //a
   bb,  //b
   em,  //m
   nn1,  //n1
   nn2,  //n2
   nn3   //n3
   );
   float x = rad * cos(theta)* 200;
   float y = rad * sin(theta)* 200;
   vertex(x,y);
  }
  endShape();
}

float r(float theta, float a, float b, float m, float n1, float n2, float n3) {
  return pow(pow(abs(cos(m* theta / 4.0) / a),n2)  +  
  pow(abs(sin(m* theta / 4.0) / b),n3), -1.0 /n1) ;
}

void keyReleased(){
    if(keyCode == UP){ em = em+2;}
    if(keyCode == DOWN){ em = em-2;}
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if(+number == 22){
  nn2 = +value /200.0;
  }
  if(+number == 23){
  nn3 = +value /200.0;
  }
   if(+number == 24){
  nn1 = +value /200.0;
  }
  if(+number == 26){
  aa = +value /100.0;
  }if(+number == 27){
  bb = +value /100.0;
  }
 
  if(+number == 29){
    em = +value;
  }
  
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}
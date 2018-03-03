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

int stillnum = 1;
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
    none = random(0.5);
      ntwo = random(6.0);
    nthree = 0;
    scale = random(100,200);
    step=random(.05,10);
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
   em,  //m
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
 if (key == 's') {
   delay(5000);
   print("wtf");
   String[] lines = new String[8];
   lines[0]= "a = " + aa + "\t";
   lines[1]= "b = " + bb + "\t";
   lines[2]= "n1 = " + none + "\t";
   lines[3]="n2 = " + ntwo + "\t";
   lines[4]="n3 = " + nthree + "\t";
   lines[5]= "vertices = " + em + "\t";
   lines[6]="scale = " + scale + "\t";
   lines[7]="step = " + step;
    saveFrame("stills/"+"still"+stillnum+"/" + "frame-######.png");
    saveStrings("stills/"+"still"+stillnum+"/" +"variables.txt",lines);
  stillnum+=1;

 
 
 }
}



void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if(+number == 22){
  ntwo = +value /200.0;
  }
  if(+number == 23){
  nthree = +value /200.0;
  }
   if(+number == 24){
  none = +value /200.0;
  }
  if(+number == 26){
  aa = +value /100.0;
  }
  if(+number == 27){
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
float em = 16;
float t = 0;
boolean newshape = false;
float n11 = -1;
float n22 = 0;
float step = .1;
float theta = 0;

void setup(){
  //background(0);
  size(500, 500);
  
  
  stroke(150);
  
  //strokeWeight(2);
  smooth();
}

void draw() {
  //frameRate(17);
  fill(0,5);
  background(0);
  text("# of vertices: " + int(em), 10, 20);
  //text(em,10,10);
  translate(width/2, height/2);
 //float soundLevel = song.mix.level();
  //nn2 = soundLevel*70;
  //nn3 = soundLevel*70;
  // print("sl:  "+soundLevel);
    
  //print("n2:" + (mouseX /200.0));
  //print("n3:" + (mouseY /200.0));
  //print("nn2: " + nn2);
  //print("nn3: " + nn3);
  
  if(newshape){
    
    n11 = random(.5);
    n22 = random(6.);
    step = random(.05, 10);
   newshape = false; 
  }
  
  
  beginShape();
  //addd vertices
  for (float i = 1; i < 60; i++){
   float rad = r(theta,
   2,  //a
   2,  //b
   em,  //m
   n11,  //n1
   //nn2,
   //nn3
   n22,
   //sin(t) * 0.9 + 0.9,  //n2
   0  
   //cos(t) * 0.9 + 0.9  //n3
   );
   
   //   mouseX /100.0,  //n2
   //mouseY /100.0   //n3
   theta = theta+ step;
   float x = rad * cos(theta )* 50;
   float y = rad * sin(theta) * 50;
   curveVertex(x,y);
  }
  endShape();
  t += 0.04;
}

float r(float theta, float a, float b, float m, float n1, float n2, float n3) {
  return 3 * pow(pow(abs(cos(m* theta / 4.0) / a),n2)  +  
  pow(abs(sin(m* theta / 4.0) / b),n3), -1.0 /n1) ;

  
}

void keyReleased(){
    if(keyCode == UP){ em = em+2;}
    if(keyCode == DOWN){ em = em-2;}
    if(keyCode ==' '){newshape = true;}
}
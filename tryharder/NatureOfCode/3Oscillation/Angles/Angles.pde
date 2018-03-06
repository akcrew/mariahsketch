//Rotate a baton around it's center using translate() and rotate()
//commented section speeds up the rotation over time (accelerates)
//also saveframe is set up for movie making

float angle = 0;
//float aVelocity = 0;
//float aAcceleration = 0.001;

void setup() {
 size(1600, 950);
 strokeWeight(5);
}

void draw(){
  rectMode(CENTER);
  smooth();
  background(255);
  translate(width/2, height/2);
  rotate(angle);
    ellipse(-100,0,60,60);
    ellipse(100,0,60,60);
    line(-70,0,70,0);

  angle +=.02;
  
  //saveFrame("mov/frame-######.png");
    //aVelocity += aAcceleration;
    //angle += aVelocity;
}
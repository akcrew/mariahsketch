//fucking circles

//global variables
float x;
float y;
float rad = 200;
float c = cos(PI);

void setup () {
  size(1000, 450);
  x = width/2;
  y = height/4;
  strokeWeight(2);
  smooth();
  noFill();
}

void draw () {
background (255,255,255,0);
  //for (int i = 0; i<7; i++) {
    //rad= rad+5;
    ellipse(x, y, rad, rad);
    //rotate(1*PI);
    translate(0,rad/2);
    ellipse(x,y, rad, rad);
    translate(0,rad/2);
  ellipse(x,y, rad, rad);
  translate(0,-rad/2);
  translate(rad/2,rad/4);
  ellipse(x,y,rad,rad);
  translate(0,-rad/2);
  ellipse(x,y,rad,rad);
  translate(-rad,0);
  ellipse(x,y,rad,rad);
  translate(0,rad/2);
  ellipse(x,y,rad,rad);
//}
  filter(BLUR,2);
}
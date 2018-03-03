//fucking circles

//global variables
float x;
float y;
float rad = 200;
float c = cos(PI);

float centerX = width/2;
float centerY = height/4;
//float x;
//float y;
float angle;
boolean neww = true;



void setup () {
  size(1000, 450);
  x = width/2;
  y = height/4;
  strokeWeight(1);
  smooth();
  noFill();
}

void draw () {
//background (255,255,255,0);
stroke(1, 1, 1, 20);
  //for (int i = 0; i<7; i++) {
    //rad= rad+5;
    stroke(1, 1, 1, 20);
  //draw circle
  if (neww == true) {
    //on the first time through draw loop i times (draw i spirals)
    for ( int i=0; i<500; i++) {
      float radius = 5;
      float radiusNoise = random(10);
      int startangle = int(random(360));
      int endangle = 1000+int(random(1000));
      int anglestep = 5 + int(random(3));
      float prevx = 0;
      float prevy = 0;

// draw a spiral
      for (float ang =startangle; ang <= endangle; ang+=anglestep) {
        radiusNoise += .07;
        float rad = radians(ang);
        float thisRadius = radius + (noise(radiusNoise)*200)-100;
        x = centerX + (thisRadius*cos(rad));
        y = centerY + (thisRadius * sin(rad));
        radius += .5;
        if (neww == true) 
          neww = false;
        else {
          line(prevx, prevy, x, y) ;
        }
        prevx = x;
        prevy = y;
      }
      neww = true;
    }
    neww = false;
  }
    
    
    
    //ellipse(x, y, rad, rad);
    //rotate(1*PI);
    translate(0,rad/2);
    //ellipse(x,y, rad, rad);
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
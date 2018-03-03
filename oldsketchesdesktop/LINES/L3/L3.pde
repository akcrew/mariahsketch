//This program draws i spirals effected by noise


//Global Variabls :)
float centerX = 400;
float centerY = 254;
float x;
float y;
float angle;
boolean neww = true;

void setup() {
  size(800, 585);
  //background(random(255), random(255), random(255));
  background(255);
  strokeWeight(.5);
  smooth();
  frameRate(200);
}

void draw() {
  stroke(1, 1, 1, 20);
  //draw circle
  if (neww == true) {
    //on the first time through draw loop i times (draw i spirals)
    for ( int i=0; i<500; i++) {
      float radius = 5;
      float radiusNoise = random(10);
      int startangle = int(random(360));
      int endangle = 3000+int(random(3000));
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
    if (keyPressed ) {
    saveFrame("spiral-######.png");
  }
}
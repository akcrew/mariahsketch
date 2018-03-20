class Pend{
  PVector location;
  PVector origin;
  float armlength;
float angle;
float angularV;
float angularA;

//constructor
Pend( float inarmlength, PVector originin){
  armlength = inarmlength;
  origin = originin.get();
  location = new PVector();
  angularV = 0.02;
  angularA = 0.02;
  
}

void drawP(){
  update();
  drawPend();
}
  
void drawPend (){
 print ("drawing");
 //PVector origin = new PVector(mouseX, mouseY);
 location.set(armlength*sin(angle), armlength*cos(angle));
 location.add(origin);
 
 stroke(0);
 fill(175);
 line(origin.x, origin.y, location.x, location.y);
 ellipse(location.x, location.y, 16,16);
}

void update(){
 print ("updating");
 float gravity =0.4;
 angularA = (-1 * gravity/armlength) * sin(angle);
 angularV += angularA;
 angle += angularV;
}
}
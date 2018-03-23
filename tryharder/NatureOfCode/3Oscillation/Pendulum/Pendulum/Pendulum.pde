//make a pendulum class 
//implement gravity
//origin follows mouse

Pend thisPendulum;

void setup(){
  size(800,800);
  thisPendulum = new Pend(125.0, new PVector(width/2, height/2));
}

void draw(){
background(255);
thisPendulum.drawP();

}
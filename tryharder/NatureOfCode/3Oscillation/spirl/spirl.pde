//filelocation

float r = 0;
float theta = 0;
 
void setup() {
  size(640,360);
  background(255);
}
 
void draw() {
 
//Polar coordinates (r,theta) are converted to Cartesian (x,y) for use in the ellipse() function.
  float x = r * cos(theta);
  float y = r * sin(theta);
 
  noStroke();
  fill(0);
  ellipse(x+width/2, y+height/2, 2, 2);
 
  theta += 0.02;
  r+= .02;
}

void keyReleased(){
    
   if(keyCode == ' ')
   {
     delay(100);
         saveFrame("spirals/" +"frame-####.png");
   }
   
}
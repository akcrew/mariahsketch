
int x,y;
float rad = 100;

void setup()
{
  stroke(1,1,1, 80);
   size(800, 585);
   fill(0,0,0,0);
}

void draw(){
 
  x = width/4;
  y = height/4;

ellipse(x,(y+(rad/2)),rad,rad);
ellipse(x,y,rad,rad);  
ellipse(x,(y+rad),rad,rad);

translate(x,y);
//translate(-rad,0);
rotate (-PI/3);
ellipse(x,y,rad,rad+33);

}
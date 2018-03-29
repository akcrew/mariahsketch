class Dude {

  float x;
  float y;
  float llength;


Dude(float tempX, float tempY, float templength) {
  x =tempX;
  y = tempY;
  llength = templength;
}



void display(){
 line(x-llength/2,y,x+llength/2,y);
}
}
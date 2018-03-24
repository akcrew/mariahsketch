class Dude {
 float x;
 float y;
 float speed;
 float gravity;
 float w;
 float life = 1000;
 float r;
 float g;
 float b;


Dude(float tempX, float tempY, float tempW, float tempR, float tempG, float tempB) {
  x = tempX;
  y = tempY;
  w = tempW;
  r = tempR;
  g = tempG;
  b = tempB;
  speed = 0;
  gravity = 0.1;
}

void move(){
  speed = speed + gravity;
  
  y = y+speed;
  
  if (y > height){
   speed = speed * -0.8;
   y = height;
  }
}

boolean finished(){
 life--;
 if(life <0) {
  return true; 
 }
 else{
  return false; 
 }
}

void display(){
  //stroke(255);
  stroke(r,g,b);
 fill(0,life);
 line(x,y,x+5,y+5);
 line(x+5,y+5,x+10,y);
 //ellipse(x,y,w,w);
}
}
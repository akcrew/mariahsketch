
//Global Variabls :)
float centerX = 400;
float centerY = 254;
float x;
float y;
float prevx = 0;
float prevy;
float angle;
float radius = 5;
boolean neww = false;

void setup(){
size(800,585);
background(random(255),random(255),random(255));
strokeWeight(5);
 smooth();
frameRate(17);

}

void draw() {
stroke(0,0,0,255);
if (radius >= 500){
 background(random(255),random(255),random(255));
 x = width/2;
 y  = height/2;
 prevx = width/2;
prevy = height/2;
 
 
 neww= true;
 radius = 5;
}
//draw circle
for(float ang =0; ang <= 360; ang+=5){
  float rad = radians(ang);
radius += .5;
x = centerX + (radius*cos(rad));
y = centerY + (radius * sin(rad));

if (prevx != width/2 && prevy != height/2 && prevx != 0){
  
line(prevx, prevy, x, y) ;
neww = false;
}
point(x,y);
prevx = x;
prevy = y;
}

//draw spiral


//draw line
//line((width/2), (height/2),(width/4)*3, (height/4)*3);
}
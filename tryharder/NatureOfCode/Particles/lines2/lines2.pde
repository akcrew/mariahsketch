ArrayList<Dude> dudes;
float s;
float mX;
float mY;
float cR;
float cG;
float cB;
void setup() {
size(600,650);
background(15);
//stroke(255);

//fill(0);
dudes = new ArrayList<Dude>();
}

void draw (){
  //fill(0);
  strokeWeight(1.2);
  //noStroke();
  stroke(37,45,45);
  cR= 143;
  background(cR);
  s = 500;
mX = width/2;
mY = height/2;

  for(int i = 0; i<=20; i++){
  
  dudes.add(new Dude(mX,mY+i*10,400));
  dudes.add(new Dude(mX,mY-i*10,400));
  }
  fill(cR);
  //background(74,44,8);
  
 
  
  
for (int i = dudes.size()-1; i>= 0; i--){
  Dude dude = dudes.get(i);
  dude.display();
  
noStroke();
  
  //triangle(mX-s/2,150,mX,s,mX+s/2,150
  ellipse(mX,mY,s-295,s-295);
  //fill(0);
  triangle(mX-s/2+49,mY,mX-s/2+49,mY+210,mX,mY+210);
  triangle(mX+s/2-49,mY,mX+s/2-49,mY+210,mX,mY+210);
  
  
  triangle(mX-s/2+49,mY,mX-s/2+49,mY-210,mX,mY-210);
  triangle(mX+s/2-49,mY,mX+s/2-49,mY-210,mX,mY-210);
  
  
  stroke(55);
  fill(69,18,24,200);
  noStroke();
  ellipse(mX,mY,249,249);
  fill(132,97,4);
  ellipse(mX,mY,150,150);
  stroke(31,14,54);
  fill(cR);
  
}
}
void keyPressed(){
if (key == ' '){
  saveFrame("frame-####.png"); 
}
}
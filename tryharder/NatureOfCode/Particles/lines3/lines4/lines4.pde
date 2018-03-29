ArrayList<Dude> dudes;
float s;
float mX;
float mY;
float cR;
float cG;
float cB;
float onlyonce;
float scale;
void setup() {
size(900,950);
background(15);
//stroke(255);
onlyonce = 0;
//fill(0);
dudes = new ArrayList<Dude>();
}

void draw (){
  //fill(0);
  scale = 100;
  strokeWeight(1.5);
  //noStroke();
  stroke(126,9,169);
  cR= 143;
  //background(cR);
  s = 500;
mX = width/2;
mY = height/2;
 //for (int i = 0; i<=40; i++){
   // dudes.add(new Dude(mX,mY,400-(i*20)));
  //}



  for(int i = 0; i<=3; i++){
   //dudes.add(new Dude(mX,mY, i*13));
  dudes.add(new Dude(mX,mY+i*scale,random(400)));
   // dudes.add(new Dude(mX,mY+i*10,random(400)));

  dudes.add(new Dude(mX,mY-i*scale,random(400)));
 
  }
  
  for(int i = 0; i<=3; i++){
   //dudes.add(new Dude(mX,mY, i*13));
  dudes.add(new Dude(mX+i*scale,mY,random(400)));
   // dudes.add(new Dude(mX,mY+i*10,random(400)));

  dudes.add(new Dude(mX-i*scale,mY,random(400)));
 
  }
 
  //dudes.add(new Dude(mX,mY,300));
  noFill();
  //background(74,44,8);
  
 
  if(onlyonce<= 2){
    print("here");
  
for (int i = dudes.size()-1; i>= 0; i--){
  Dude dude = dudes.get(i);
  dude.display();
}
onlyonce++;
//onlyonce = false;
  }
  /*
noStroke();
  
  //triangle(mX-s/2,150,mX,s,mX+s/2,150
  //ellipse(mX,mY,s-295,s-295);
  
  //fill(0);
  //triangle(mX-s/2+49,mY,mX-s/2+49,mY+202,mX,mY+202);
  //triangle(mX+s/2-48,mY,mX+s/2-48,mY+202,mX,mY+202); 
  
  
  //triangle(mX-s/2+49,mY,mX-s/2+49,mY-210,mX,mY-210);
  //triangle(mX+s/2-49,mY,mX+s/2-49,mY-210,mX,mY-210);
  
  
  stroke(55);
  fill(69,18,24,200);
  noStroke();
  //ellipse(mX,mY,170,170);
  //fill(132,97,4);
  //ellipse(mX,mY,150,150);
  stroke(31,14,54);
  fill(cR);
  */

}
void keyPressed(){
if (key == ' '){
  saveFrame("frame-####.png"); 
}
if(key == 'p'){
 // for (int i = dudes.size()-1; i>= 0; i--){
 //print("here: " + dudes.get(i)); 
 // }
}

}
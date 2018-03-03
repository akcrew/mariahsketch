
void setup(){
  background(0);
  size(900,900);
  stroke(255, 150);
  strokeWeight(.1);
  smooth(500);
 noFill();

}

void draw(){
translate(450,450);

float tS = 200;
ellipse(0,0,tS,tS);
for(int i=1; i <= 6; i++)
    {
      
      translate(tS/2, 0);
      ellipse(0, 0, tS, tS); //original 6
      rotate(PI/3);
      translate(tS/2, 0);
      ellipse(0,0,tS,tS); //2nd layer
      
      
      rotate(PI/3);
      translate(tS/2, 0);
      ellipse(0,0,tS,tS); //3rd layer (step 5);
      translate(-tS/2, 0);
      rotate(-PI/3);
      
      
      translate(-tS/2, 0);
      rotate(-PI/3);
      translate(-tS/2, 0);
      rotate(PI/3);
    }
}

      
/**
 * Playing with:
 * classes
 * functions
 * circle intersection
 * and learning about the translation matrix
 * Mariah Vicary 10/14/17 
 * 
 */

float firstintx;
float firstinty;
float secintx;
float secinty;
float fx;
float fy;
float sx;
float sy;


float originalrad = 200;
void setup()
{size(800, 500);
 noFill();
  stroke(0,0,0);
  drawCircles();
}
 
void draw()
{
}
   void drawCircles() {
    for (int i=0; i<6; i++) {
     if (i == 0){
     pushMatrix();
     translate(400,150);
     pushMatrix();
     Circle thisCirc = new Circle(0, 0, originalrad);
     thisCirc.drawMe(); //1
     }
      if (i ==1)
      {
        translate(0, originalrad/2);
        pushMatrix();
        Circle thisCirc = new Circle(0, 0, originalrad);
         thisCirc.drawMe(); //2
      }
      if (i ==2)
      {
        popMatrix();
        popMatrix();
        popMatrix();
        circleintersect(400,150,400,(150+originalrad/2),originalrad/2);
        fx = firstintx; fy = firstinty; sx = secintx; sy = secinty;
         Circle thisCirc = new Circle(firstintx, firstinty, originalrad);
         thisCirc.drawMe(); //3
    
         thisCirc = new Circle(secintx, secinty, originalrad);
     thisCirc.drawMe(); //4
     
     
        circleintersect(400,150,fx, fy, originalrad/2);
       thisCirc = new Circle(firstintx, firstinty, originalrad);
       thisCirc.drawMe();// new1
       
       circleintersect(400,150,sx, sy, originalrad/2);
       thisCirc = new Circle(secintx, secinty, originalrad);
       thisCirc.drawMe();// new2
     
     
      }
       if (i ==3)
      {circleintersect(400,(150+originalrad/2),fx, fy,originalrad/2);
         Circle thisCirc = new Circle(secintx, secinty, originalrad);
         thisCirc.drawMe(); //5
         //fx = firstintx; fy = firstinty; 
         sx = secintx; sy = secinty;
         //circleintersect(fx, fy, sx,sy,originalrad/2);
          //thisCirc = new Circle(firstintx, firstinty, originalrad);
          //thisCirc.drawMe(); //new3
      }
       if (i ==4)
      {circleintersect(400,(150+originalrad/2), sx, sy, originalrad/2);
       Circle thisCirc = new Circle(secintx, secinty, originalrad);
       stroke(023,123,28);
       thisCirc.drawMe(); //6
       stroke(0);
        //sx = secintx; sy = secinty;
        
        stroke(023,123,28);
       //circleintersect(sx, sy, secintx, secinty, originalrad/2);
       //thisCirc = new Circle(firstintx, firstinty, originalrad);
       //thisCirc.drawMe();
       stroke(0);
       
      } 
      if (i ==5)
     // print("hi!");
      {circleintersect(400,(150+originalrad/2),sx, sy,originalrad/2);
        Circle thisCirc = new Circle(secintx, secinty, originalrad);
         thisCirc.drawMe(); //7
      }
    }
  }

//Stolen math to calculate circle intersection
//function returns the two points of intersection
//would error if circles did not intersect
//https://gist.github.com/jupdike/bfe5eb23d1c395d8a0a1a4ddd94882ac
void circleintersect(float x1, float y1, float x2, float y2, float r){
  float r1 = r;
  float r2 = r;
  float centerdx = x1 - x2;
  float centerdy = y1 - y2;
  float R = sqrt(centerdx * centerdx + centerdy * centerdy);
  
  float R2 = R*R;
  float R4 = R2*R2;
  float a = (r1*r1 - r2*r2) / (2 * R2); 
  float r2r2 = (r1*r1 - r2*r2);
  float c = sqrt(2 * (r1*r1 + r2*r2) / R2 - (r2r2 * r2r2) / R4 - 1);
  
  float fx = (x1+x2) / 2 + a * (x2 - x1);
  float gx = c * (y2 - y1) / 2;
  float ix1 = fx + gx;
  float ix2 = fx - gx;

  float fy = (y1+y2) / 2 + a * (y2 - y1);
  float gy = c * (x1 - x2) / 2;
  float iy1 = fy + gy;
  float iy2 = fy - gy;
  
 firstintx =ix1;
 firstinty = iy1;
 secintx = ix2;
 secinty = iy2;
}
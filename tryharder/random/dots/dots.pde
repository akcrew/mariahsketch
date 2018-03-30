//import processing.opengl.*;
float dotsx[] ;
float dotsy[];
int numDots = 14;
void setup(){
  size(600,600);
  background(255);
  //noSmooth();
  dotsx = new float[numDots];
  dotsy = new float[numDots];
 for (int i = 0; i<numDots; i++){
  dotsx[i]=random(width);
}
for (int i = 0; i<numDots; i++){
  dotsy[i]=random(height);
}
}
void draw(){
  //fill(0);
for (int i = 0; i<numDots; i++){
  ellipse(dotsx[i],dotsy[i],6,6);
}

strokeWeight(.6);

for (int i = 0; i<numDots; i++){
  for (int j = 0; j<numDots; j++){
    float midx = (dotsx[i]+dotsx[j])/2;
    float midy = (dotsy[i]+dotsy[j])/2;
    ellipse(midx,midy,6,6);
    //smooth(2);
    //beginShape();
    /*
    curveVertex(dotsx[i],dotsy[i]);
    curveVertex(dotsx[i],dotsy[i]);
    curveVertex(midx,midy);
    curveVertex(midx,midy);
    curveVertex(dotsx[j],dotsy[j]);
    curveVertex(dotsx[j],dotsy[j]);
 // line(dotsx[i],dotsy[i],dotsx[j],dotsy[j]);
 //bezierVertex(dotsx[i],dotsy[i],dotsx[j],dotsy[j],dotsx[j],dotsy[j]);
  //bezierVertex(dotsx[i],dotsy[i]);
//bezierVertex(dotsx[j],dotsy[j]);
 //bezierVertex(dotsx[j],dotsy[j],dotsx[j],dotsy[j],dotsx[);
 endShape();*/
}
}
}
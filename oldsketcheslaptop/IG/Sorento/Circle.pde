class Circle {
 float x;
   float y;
  float rad;
  
  Circle(float inx, float iny, float inrad) {
    x = inx;
    y = iny;
    rad = inrad;
  }
  
  void drawMe(){
  ellipse(x,y,rad,rad);
}
}
float dotsx[] ;
float dotsy[];
//boolean savex = false;
int numDots;
void setup() {
  size(600, 600);
  background(random(255), random(255), random(255));
  noStroke();
  fill(random(255), random(255), random(255));
 
  numDots = int(random(4,15));
   dotsx = new float[numDots];
  dotsy = new float[numDots];
  print(numDots);
  frameRate(30);
  for (int i = 0; i<numDots; i++) {
    dotsx[i]=random(width);
  }
  for (int i = 0; i<numDots; i++) {
    dotsy[i]=random(height);
  }
 for (int i = 0; i<numDots; i++) {
    for (int j = 0; j<numDots; j++) {
     line(dotsx[i], dotsy[i], dotsx[j], dotsy[j]);
      if (j>0) {
        triangle(dotsx[i], dotsy[i], dotsx[j], dotsy[j], dotsx[j-1], dotsy[j-1]);
      }
    }
  }
}
void draw() {
}
void keyPressed() {
  if (key == ' ') {
    saveFrame("frame-####.png");
  }
  if (key == 'l') {
    noStroke();
  }
}
class ParticleVertex {

  // GLOBAL VARIABLES

  PVector location;

  float xincrement = 0.000005; // x speed
  float yincrement = 0.000008; // y speed

  // CONSTRUCTOR INITIALIZE ALL VALUES - THE CONSTRUCTOR IS THE OBJECTS SETUP()
  // the constructor is all the stuff that happens when you first make that object

  ParticleVertex(PVector l) {
    location = l.get();
  }

  void movement() {

    float displacementX = noise(xoff1) * width;
    float displacementY = noise(yoff1) * height;

    xoff1 += xincrement;
    yoff1 += yincrement;

    // dist (x1, y1, x2, y2);
    movePoint1 = dist(displacementX - (width / 2), displacementY - (height / 2), location.x, location.y);
  }  

  // display at x & y location

  void display() {    

    noStroke();
    fill(0, 0, 100, 255);
    ellipse(location.x + random(-randomX1, randomX1), location.y + random(-randomY1, randomY1), diameter1, diameter1);
  }
}
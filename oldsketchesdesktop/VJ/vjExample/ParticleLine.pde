class ParticleLine {

  // GLOBAL VARIABLES

  PVector location;

  float xincrement = 0.000005; // x speed
  float yincrement = 0.000008; // y speed

  // CONSTRUCTOR INITIALIZE ALL VALUES - THE CONSTRUCTOR IS THE OBJECTS SETUP()
  // the constructor is all the stuff that happens when you first make that object

  ParticleLine(PVector l) {
    location = l.get();
  }

  void movement() {

    float displacementX = noise(xoff) * width;
    float displacementY = noise(yoff) * height;

    xoff += xincrement;
    yoff += yincrement;

    // dist (x1, y1, x2, y2);
    movePoint = dist(displacementX - (width / 2), displacementY - (height / 2), location.x, location.y);
  }  

  // display at x & y location

  void displayRectangle() {
    noFill();
    stroke(0, 0, 100, 50);
    strokeWeight(1);
    rectMode(CENTER);
    rect(location.x + random(-randomX, randomX), location.y + random(-randomY, randomY), diameter * 150, 1);
  }

  void displayVertex() {   
    noFill();
    stroke(0, 0, 100, 150);
    strokeWeight(2);
    vertex(location.x + random(-randomX, randomX), location.y + random(-randomY, randomY));
  }
}
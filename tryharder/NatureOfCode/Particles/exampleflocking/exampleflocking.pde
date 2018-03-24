/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

Flock flock;

void setup() {
  background(0);
  size(1000, 500);
  flock = new Flock();
  // Add an initial set of boids into the system
 
}

void draw() {
  //fill(0,10);
  //rect(0,0,width,height);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
   for (int i = 0; i < 100; i++) {
    flock.addBoid(new Boid(mouseX,mouseY));
  }
  //flock.addBoid(new Boid(mouseX,mouseY));
}

void keyPressed(){
 background(0); 
}

import processing.opengl.*;
import processing.sound.*;//  
//Amplitude amp;// AudioIn in; SoundFile file;


//import ddf.minim.*;
//Minim minim;
//AudioPlayer in;

void setup() {
  size(760, 945, P3D);
  //framerate
  background(36, 20, 89);
  stroke(0, 0, 0);
  strokeWeight(5);
  smooth();
}

void draw() {
  //background(255);
  translate((height/2 ), (width/2));
  sphere(400); 
  fill(97, 248, 236);

  if (keyPressed ) {
    saveFrame("sphere-######.png");
  }
}

//import processing.opengl.*;
//import processing.sound.*;//  
//Amplitude amp;// AudioIn in; SoundFile file;


import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
FFT         fft;
//Beatlistener bl;

float rad;

void setup() {
  
  minim = new Minim(this);
  
  song = minim.loadFile("locked.mp3");
  song.play();
  
  //beat = new BeatDetect();
   fft = new FFT( song.bufferSize(), song.sampleRate() );
  size(760, 945, P3D);
  //framerate
  background(36, 20, 89);
  stroke(0, 0, 0);
  strokeWeight(5);
  smooth();
  rad = 400;
  
  
  
}

void draw() {
  //background(255);
  
 // beat.detect(song.mix);
  fft.forward(song.mix);
 
  translate((height/2 ), (width/2));
  
  // if(beat.isOnset()) rad = 200;
  //sphere(rad); 
  fill(97, 248, 236);



for(int i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i, height, i, height - fft.getBand(i)*8 );
    rad = (rad*i);
    if (rad > 600){
     rad= 200; 
    }
 sphere(rad);   
}






  if (keyPressed ) {
    saveFrame("sphere-######.png");
  }
}
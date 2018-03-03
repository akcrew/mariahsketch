import processing.opengl.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import geomerative.*;

AudioAnalyse myAudioAnalyse; 

BeatBase myBase;

int sampleRate = 44100;
int bufferSize = 512; 

int fft_base_freq = 86; // size of the smallest octave to use (in Hz) so we calculate averages based on a miminum octave width of 55 Hz 
int  fft_band_per_oct = 1; // how many bands to split each octave into? in this case split each octave into 12 bands

boolean onBeat = false;
float beatSense = 8;

float level = 0;
float leveldB = -100;
int lastBand = 0;

int nbAverage = (sampleRate / bufferSize) * 2; // 44100 / 512 = 86 * 2 returns 172
int nbAverageShortTerm = (sampleRate / bufferSize) / 3; // returns 28
int nbAverageLongTerm =  (sampleRate / bufferSize) * 8; // returns 688

int numZones = 0;
int playhead1 = 0;

float[] score;
float[] scoreLongTerm;

float score2 = 0;

float[][] zoneEnergy;
float[][] zoneScore;
float[][] zoneEnergyShortTerm;

boolean zoneEnabled[];

float[] zoneEnergyVolumeMeter;
float[] zoneEnergyPeak;
float[] zoneEnergyPeakHoldTimes; 

// GEOMETRY STUFF

RShape shape;

RPoint[] myPoints1;
RPoint[] myPoints2;

boolean ignoringStyles = true;

// PARTICLE STUFF

GeoAudio1 myAudio1;
GeoAudio2 myAudio2;

ParticleVertex[] myVertexParticle; 
ParticleLine[] myLineParticle; 

float xoff1 = 0.0;
float xoff = 0.0;

float yoff1 = 0.0;
float yoff = 0.0;

float movePoint1;
float movePoint;

float randomX1;
float randomX;

float randomY1;
float randomY;

float diameter1;
float diameter;

// MINIM STUFF

Minim minim;
AudioPlayer song;
FFT fft;

void setup() {  

  frameRate(60);

  size(1280, 720, OPENGL);
  colorMode(HSB, 360, 100, 100);

  // ********** AUDIO CLASSES ********** //

  myAudioAnalyse = new AudioAnalyse(); 

  // ********** THE BASE AUDIO CLASSE ********** //

  myBase = new BeatBase();

  // ********** GEOMETRY CLASSES ********** //

  myAudio1 = new GeoAudio1();
  myAudio2 = new GeoAudio2();

  // ********** MINIM ********** //

  minim = new Minim(this);
  song = minim.loadFile("../AudioData/richie.mp3", bufferSize);
  song.loop();  
  song.addListener(new BeatListener()); 
  fft = new FFT( song.bufferSize(), song.sampleRate() );
  fft.logAverages(fft_base_freq, fft_band_per_oct); // results in 108 averages, each corresponding to an octave,  (55, 12)
  fft.window(FFT.HAMMING);

  // println("Sound Control: FFT on " + fft.avgSize() + " logarithmic bands. Sample rate: " + sampleRate + "Hz. " + sampleRate / bufferSize + " buffers of " + bufferSize + " samples per second.");

  numZones = fft.avgSize(); // avgSize() returns the number of averages currently being calculated (9).

  // ********** ENERGY ARRAYS ********** //

  zoneEnergy = new float[numZones][];
  //println(zoneEnergy.length);
  zoneScore = new float[numZones][];
  zoneEnergyShortTerm = new float[numZones][];  

  zoneEnabled = new boolean[numZones];

  zoneEnergyVolumeMeter = new float[numZones];
  zoneEnergyPeak = new float[numZones];
  zoneEnergyPeakHoldTimes = new float[numZones];

  score = new float[nbAverage];
  scoreLongTerm = new float[nbAverageLongTerm];

  for (int i = 0; i < numZones; i++) {
    // 0 - 8 main arrays, zones
    zoneEnergy[i] = new float[nbAverage]; // each index  0 - 8 contains 172 arrays 
    zoneScore[i] = new float[nbAverage]; // each index 0 - 8 contains 172 arrays 
    zoneEnergyShortTerm[i] = new float[nbAverageShortTerm]; // each index 0 - 8  contains 28 arrays
    zoneEnabled[i] = true; // returns  the zone 0 - 8 as true or false
  }

  // ********** GEOMETRY ********** //

  RG.init(this); 
  RG.ignoreStyles(ignoringStyles);
}

// ********** DRAW ********** //

void draw() {

  frame.setTitle(int(frameRate) + " fps");
  smooth(8);  
  background(0, 0, 0);

  myBase.drawBase();
  myAudio1.drawParticle();
  myAudio2.drawParticle();

  fft.forward(song.mix);

  // ------ SAVING  ------ //

  // saveFrame("richie-######.tga");
}

// ********** FUNCTIONS ********** //

float average(float[] array1) {

  float sum = 0;

  for (int i = 0; i < array1.length; i++) {

    sum += array1[i];
  }
  return (sum / array1.length);
}

float[] sum(float[] array1, float[] array2) {

  float[] array3 = new float[array1.length];

  for (int i = 0; i < array1.length; i++) {

    array3[i] += array1[i] + array2[i];
  }
  return (array3);
}


// --- start function ---

float ScaleIEC(float db) { // scales the decibel level according to the standard, IEC-268-18.

  float percent = 0.0; 

  if (db < -70.0) {

    percent = 0.0;
  }

  else if (db < -60.0) {

    percent = (db + 70.0) * 0.25;

    // println("db: " + db);
  }

  else if (db < -50.0) {

    percent = (db + 60.0) * 0.5 + 2.5;
  }

  else if (db < -40.0) {

    percent = (db + 50.0) * 0.75 + 7.5;
  }

  else if (db < -30.0) {

    percent = (db + 40.0) * 1.5 + 15.0;
  }

  else if (db < -20.0) {

    percent = (db + 30.0) * 2.0 + 30.0;
  }

  else if (db < 0.0) {

    percent = (db + 20.0) * 2.5 + 50.0;
  }

  else {

    percent = 100.0;
  }

  return percent; // returns the percentage to scale the decibel level to.
}

// --- end function ---

void stop() {
  song.close(); // always close Minim audio classes when you are finished with them
  minim.stop(); // always stop Minim before exiting
}
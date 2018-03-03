class GeoAudio1 {

  // GLOBAL VARIABLES

  PVector location;

  int lowFreq;
  float distance = 1;

  // CONSTRUCTOR

  GeoAudio1() {

    // RCommand.setSegmentLength(distance);
    // RCommand.setSegmentator(RCommand.UNIFORMLENGTH); // CUBICBEZIERTO, ADAPTATIVE

    RG.setPolygonizer(RG.UNIFORMLENGTH); // ADAPTATIVE, UNIFORMLENGTH, UNIFORMSTEP
    RG.setPolygonizerLength(distance); // Set the distance between the points

    shape = RShape.createCircle(0, 0, 20);
    shape.centerIn(g, 200);
    myPoints1 = shape.getPoints(); // returns the points of the group      
    myVertexParticle = new ParticleVertex[myPoints1.length];

    // INITIALIZE THE OBJECT 

    for (int i = 0; i < myPoints1.length; i++) {
      // myVertexParticle is a new ParticleVertex object, set new PVector (x, y)  
      myVertexParticle[i] = new ParticleVertex(new PVector(myPoints1[i].x, myPoints1[i].y));
    }
  }

  // FUNCTIONS  

  void drawParticle() {

    translate(width / 2, height / 2);

    // ********** THE AUDIO ********** //

    if (numZones != 0) {

      int avgWidth = int(width / numZones);

      for (int i = 0; i < numZones; i++) { // 9 bands, averages

        float average = zoneEnergyVolumeMeter[i];
        float avg = 0;

        if ( i == 0 ) {
          lowFreq = 0;
        } 
        else {
          lowFreq = (int)((sampleRate/2) / (float)Math.pow(2, numZones - i)); // 0, 86, 172, 344, 689, 1378, 2756, 5512, 11025
        }
        int hiFreq = (int)((sampleRate/2) / (float)Math.pow(2, numZones - 1 - i)); // 86, 172, 344, 689, 1378, 2756, 5512, 11025, 22050

        int lowBound = fft.freqToIndex(lowFreq);
        int hiBound = fft.freqToIndex(hiFreq);

        // println("range " + i + " = " + "Freq: " + lowFreq + " Hz - " + hiFreq + " Hz " + "indexes: " + lowBound + "-" + hiBound);

        for (int j = lowBound; j <= hiBound; j++) { // j is 0 - 256

          float spectrum = fft.getBand(j); // return the amplitude of the requested frequency band, ie. returns spectrum[offset]
          avg += spectrum;
        }

        avg /= (hiBound - lowBound + 1);
        average = avg;

        float dbZoneEnergyPeak = abs(10 * (float) log(zoneEnergyPeak[i] / 250));
        float dbVolumeMeter = abs(10 * (float) log(zoneEnergyVolumeMeter[i] / 250));

        // println("i: " + i); 

        if (i == 6) { 

          // println("average: " + average);   
          // println(dbZoneEnergyPeak + " db");

          // ***** START CIRCLE VERTEX ***** //

          beginShape();

          for (int p = 0; p < myPoints1.length; p++) {

            if (average > 2.0 && average < 5.0) {
              randomX1 = (15 / movePoint1) * (dbZoneEnergyPeak * 10);
              diameter1 = (15 / movePoint1) * dbZoneEnergyPeak;
            } 

            else {
              randomX1 = (150 / movePoint1) * 4;
              // diameter1 = 3;
              // diameter1 = (35 / movePoint1) * (dbZoneEnergyPeak / 20);
              diameter1 = (15 / movePoint1) * (dbZoneEnergyPeak / 5);
            }

            myVertexParticle[p].display();
            myVertexParticle[p].movement();
          }

          endShape();

          // ***** END CIRCLE VERTEX ***** //
        }

        // ****************************** //
      }
    }

    // ********** //
  }
}
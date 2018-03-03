class GeoAudio2 {

  // GLOBAL VARIABLES

  PVector location;

  int lowFreq;
  float distance = 10;

  // CONSTRUCTOR

  GeoAudio2() {

    // RCommand.setSegmentLength(10);
    // RCommand.setSegmentator(RCommand.UNIFORMLENGTH);

    RG.setPolygonizer(RG.UNIFORMLENGTH); // ADAPTATIVE, UNIFORMLENGTH, UNIFORMSTEP
    RG.setPolygonizerLength(distance); // Set the distance between the points

    shape = RShape.createCircle(0, 0, 20);
    shape.centerIn(g, 200);
    myPoints2 = shape.getPoints(); // returns the points of the group  
    myLineParticle = new ParticleLine[myPoints2.length];

    // INITIALIZE THE OBJECT 

    for (int i = 0; i < myPoints2.length; i++) {
      // myVertexParticle is a new ParticleVertex object, set new PVector (x, y)  
      myLineParticle[i] = new ParticleLine(new PVector(myPoints2[i].x, myPoints2[i].y));
    }
  }

  // FUNCTIONS  

  void drawParticle() {

    // translate(width / 2, height / 2);

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

        if (i == 6) { 

          // println("average: " + average);   
          // println(dbZoneEnergyPeak + " db");

          // RECTANGLE

          beginShape();

          for (int p = 0; p < myPoints2.length; p++) {

            if (average > 0.1 && average < 3.0) { // average > 0.9 && average < 2.0; 

              randomX = (5 / movePoint) * (dbZoneEnergyPeak * 5);
              diameter = ((50 / movePoint) * (average * 5));
            }
            // println("diameter: " + diameter);

            myLineParticle[p].displayRectangle();
            myLineParticle[p].movement();
          }

          endShape();
           
          // VERTEX

          beginShape();

          for (int p = 0; p < myPoints2.length; p++) {

            if (average > 0.1 && average < 3.0) { // average > 0.9 && average < 2.0; 

              randomX = (5 / movePoint) * (dbZoneEnergyPeak * 5);
              diameter = ((50 / movePoint) * (average * 5));
            }
            // println("diameter: " + diameter);

            myLineParticle[p].displayVertex();
            myLineParticle[p].movement();
          }

          endShape();

          // ****************************** //
        }

        // ********** //
      }
    }

    // ********** //
  }
}
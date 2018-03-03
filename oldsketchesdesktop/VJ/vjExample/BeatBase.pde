class BeatBase {

  // GLOBAL VARIABLES

  // CONSTRUCTOR

  BeatBase() {
  }

  // FUNCTIONS  

  void drawBase() {

    int avgWidth = int(width / numZones);
    // println("avgWidth: " + avgWidth); // returns 46
    // println("FFT avgSize: " + fft.avgSize()); // returns 11 (the number of bands)
    // println("Bandwidth: " + fft.getBandWidth() + " Hz"); // returns 86 Hz

    int highZone = numZones - 1;

    for (int i = 0; i < numZones; i++) { // 9 bands / zones /  averages

      // float average = fft.getAvg(i); // return the value of the requested average band, ie. returns averages[i]
      float average = zoneEnergyVolumeMeter[i];

      float avg = 0;
      int lowFreq;

      if ( i == 0 ) {
        lowFreq = 0;
      } 
      else {
        lowFreq = (int)((sampleRate/2) / (float)Math.pow(2, numZones - i)); // 0, 86, 172, 344, 689, 1378, 2756, 5512, 11025
      }
      int hiFreq = (int)((sampleRate/2) / (float)Math.pow(2, highZone - i)); // 86, 172, 344, 689, 1378, 2756, 5512, 11025, 22050

      int lowBound = fft.freqToIndex(lowFreq); // ask for the index of lowFreq & hiFreq
      int hiBound = fft.freqToIndex(hiFreq); // freqToIndex returns the index of the frequency band that contains the requested frequency

      // println("range " + i + " = " + "Freq: " + lowFreq + " Hz - " + hiFreq + " Hz " + "indexes: " + lowBound + "-" + hiBound);

      for (int j = lowBound; j <= hiBound; j++) { // j is 0 - 256
        float spectrum = fft.getBand(j); // return the amplitude of the requested frequency band, ie. returns spectrum[j]
        avg += spectrum; // avg += spectrum[j];
      }

      avg /= (hiBound - lowBound + 1);
      average = avg; // averages[i] = avg;

      float dbVolumeMeter = abs(10 * (float) log(zoneEnergyVolumeMeter[i] / 250)); 
      float dbZoneEnergyPeak = abs(10 * (float) log(zoneEnergyPeak[i] / 250));  

      // ********** //

      if (i == 3) { 

        float newRange = map(dbVolumeMeter, 20.0, 50.0, 4, 12);

        // println(dbVolumeMeter);
        // println("average: " + average);   
        // println(dbZoneEnergyPeak + " db");

        strokeWeight(newRange);

        if (average > 10.0 && average < 20.0) {

          for (int y = 60; y < height; y += 150) { 
            for (int x = 40; x < width; x += 150) { 
              stroke(0, 0, 100);
              point (x, y);
            }
          }
        }


        if (average > 10.0 && average < 30.0) {
          stroke(0, 0, 100);  
          fill(0, 0, 0);
          ellipse(width / 2, height / 2, dbZoneEnergyPeak * 3, dbZoneEnergyPeak * 3);
        }
      }

      // ********** //

      if (i == 5) {

        if (average > 2.9 && average < 5.0) {
          noStroke();  
          fill(0, 0, 100);
          ellipse(width / 2, height / 2, dbZoneEnergyPeak * 6, dbZoneEnergyPeak * 6);
        }
      }

      // ********** //
    }
  }
}
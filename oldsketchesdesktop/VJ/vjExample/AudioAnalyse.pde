class AudioAnalyse {

  // GLOBAL VARIABLES

  int bpm = 180;
  int skipFrames = 0;

  boolean autoBeatSense = true;
  float beatSenseSense = 1; 

  int playheadShortTerm1 = 0;
  int playheadLongTerm1 = 0;   

  // ENERGY PEAK LINES

  float peakHoldTime = 0.3; // energy peak lines hold longer
  float peakDecayRate = 0.96; // energy peak lines decay slower
  
  float linearEQIntercept = 0.8; // reduced gain at lowest frequency
  float linearEQSlope = 0.2; // increasing gain at higher frequencies

  int lastBandCount = 0;
  int repeatDelay = (int) ((60 / bpm / 6) * (sampleRate / bufferSize)); // skip beat for a quarter of beat

  // FUNCTIONS

  void analyse() {

    // update our round robins heads

    int playhead2 = (playhead1 + 1) % nbAverage; // returns 0 - 171    
    int playheadShortTerm2 = (playheadShortTerm1 + 1) % nbAverageShortTerm; // returns 0 - 27
    int playheadLongTerm2 = (playheadLongTerm1 + 1) % nbAverageLongTerm; // returns 0 - 687

    // println("playhead 1: " + playhead1); 
    // println("playhead 2: " + playhead2); 

    // println("playheadLongTerm 1: " + playheadLongTerm1);
    // println("playheadLongTerm 2: " + playheadLongTerm2);

    // println("playheadShortTerm 1: " + playheadShortTerm1);
    // println("playheadShortTerm 2: " + playheadShortTerm2);

    for (int i = 0; i < numZones; i++) {

      // GET ENERGY FOR EACH OF THE 9 ZONES

      float lineDecay = linearEQIntercept + (i * linearEQSlope); // 0.8 + (i * 0.2)

      zoneEnergy[i][playhead2] = fft.getAvg(i) * lineDecay; // multiplying by lineDecay variable causes the gradual decay in height of the bars

      /********************/

      // COMPUTE ZONE ENERGY PEAKS             

      if (zoneEnergy[i][playhead2] >= zoneEnergyPeak[i]) {  // if the current zone energy average is greater or equal to zone energy peak

        // println("zoneEnergy: " + zoneEnergy[i][playhead2]);
        // println("zoneEnergyPeak: " + zoneEnergyPeak[i]); 

        // SAVE A NEW PEAK ENERGY LEVEL
        zoneEnergyPeak[i] = zoneEnergy[i][playhead2];

        // AND RESET THE HOLD TIMER
        zoneEnergyPeakHoldTimes[i] = peakHoldTime; // returns 30
        // println("zoneEnergyPeakHoldTimes: " + zoneEnergyPeakHoldTimes[i]);
      }

      else { // else, if the current zone energy average is not greater or equal to zone energy peak, ie. does not exceed peak  

        // HOLD THE PEAK

        if (zoneEnergyPeakHoldTimes[i] > 0) {
          zoneEnergyPeakHoldTimes[i] --; // subtracts 1 from 30 and returns 0 - 29
        } 

        // OR DECAY THE PEAK

        else {

          // same as zoneEnergyPeak[i] * peakDecayRate (*= multiplication assignment operator)
          zoneEnergyPeak[i] *= peakDecayRate; // peakDecayRate decreases the value of zoneEnergyPeak[i] & result is the peaks fall down
        }
      }

      // ******************** //

      zoneEnergyVolumeMeter[i] = zoneEnergy[i][playhead2];

      // println("zoneEnergy: " + zoneEnergy[i][playhead2]);
      // println("zoneEnergyVolumeMeter: " + zoneEnergyVolumeMeter[i]);

      zoneEnergyShortTerm[i][playheadShortTerm2] = zoneEnergy[i][playhead2];  

      // println("zoneEnergyShortTerm: " + zoneEnergyShortTerm[i][playheadShortTerm2]);
      // println(zoneEnergy[i][playhead2] + " " + average(zoneEnergy[i]));

      // ********** COMPUTE A PER BAND SCORE ********** //

      if ((zoneEnergy[i][playhead2] > 0.3) && (average(zoneEnergy[i]) > 0.1)) {

        zoneScore[i][playhead2] = zoneEnergy[i][playhead2] / average(zoneEnergy[i]) * zoneEnergyShortTerm[i][playheadShortTerm2] / average(zoneEnergyShortTerm[i]);

        // println("zoneScore: " + zoneScore[i][playhead2]);
      }
      else {

        zoneScore[i][playhead2] = 0;
      }

      if (zoneEnabled[i]) {       

        if (zoneScore[i][playhead2] < 100) {

          score[playhead2] += zoneScore[i][playhead2];
        } 

        else {

          score[playhead2] += 100;
        }
      }
    }

    // ********** PITCH DETECT ********** //

    float maxEnergy = 0;
    int bandmaxEnergy = 0;
    int thres = 0;

    for (int i = 0; i < numZones; i++) {

      if (zoneEnergy[i][playhead2] > maxEnergy && zoneEnabled[i]) {

        bandmaxEnergy = i;
        maxEnergy = zoneEnergy[i][playhead2];

        // println(i + " " + maxEnergy);
      }
    }

    // else if bandmaxEnergy is not equal to lastBand

    if (bandmaxEnergy != lastBand) {

      //println("bandmaxEnergy: " + bandmaxEnergy);
      //println("lastBand: " + lastBand);

      if (lastBandCount > thres) {

        // println(".");
      }
      lastBandCount = 0;
    } 

    // else if bandmaxEnergy is equal to lastBand

    else { 

      // println (bandmaxEnergy + " " + fft.getBandWidth() * bandmaxEnergy + " Hz");

      if (thres == lastBandCount) {

        // println ("thres: " + thres);
        // println ("lastBandCount: " + lastBandCount);
        // println (bandmaxEnergy + " " + fft.getBandWidth() * bandmaxEnergy + " Hz");

        // ********** //
      }
      /*
      if (lastBandCount > thres) {
       
       // println(".");
       }
       */
      lastBandCount++;
      // println("lastBandCount: " + lastBandCount);
    }

    lastBand = bandmaxEnergy;
    //println("lastBand: " + lastBand);

    // ********** COMPUTE A GLOBAL SCORE ********** //

    int numZoneEnabled = 0;

    for (int i = 0; i < numZones; i++)

      numZoneEnabled += (zoneEnabled[i]) ? 1 : 0;

    if (numZoneEnabled == 0) {

      score[playhead2] = 0;
      scoreLongTerm[playheadLongTerm2] = 0;
    } 
    else {

      score[playhead2] = score[playhead2] / numZoneEnabled;
      scoreLongTerm[playheadLongTerm2] = score[playhead2] / numZoneEnabled;
    }

    float smooth = 0.9;

    if (score2 * smooth < score[playhead2]) {

      score2 = score[playhead2];
    } 
    else {

      score2 *= smooth;
    }

    // ********** ARE WE ON THE BEAT? ********** //

    if ((skipFrames <= 0) && (score[playhead2] > beatSense)) {

      onBeat = true;
      skipFrames = repeatDelay;
    }

    if (skipFrames > 0) skipFrames--;

    // ********** COMPUTE AUTO BEAT SENSE ********** //

    float max = max(score);

    if (max > 30) max = 30;

    float avg = average(scoreLongTerm);

    if (avg < 1.5) avg = 1.5;

    if (autoBeatSense && max > 1.1) {

      beatSense = beatSense * 0.995 + 0.002 * max * beatSenseSense + 0.003 * avg * beatSenseSense; 

      if (beatSense < 1.1) beatSense = 1.1;
    }

    // println("max: " + max + " avg: " + avg + " var: "+ average(score));

    // make our round robin heads public

    playhead1 = playhead2;
    playheadShortTerm1 = playheadShortTerm2;
    playheadLongTerm1 = playheadLongTerm2;

    // println("Threshold : "+ beatSense);
    // println("Current Score : "+ score2);
    // println("On Beat : " + onBeat);
  }
}
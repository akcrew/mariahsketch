class BeatListener implements AudioListener {

  void samples(float[] sample) { // a method of AudioListener

    float max = max(sample); // max() determines the largest value in a sequence of numbers, and then returns that value

    if (max > level) {
      level = max;
    } 
    else {
      level = level * 0.8;
    }
    
    leveldB = (float) (10 * log(level));
    myAudioAnalyse.analyse();
    
  }

  void samples(float[] sampleL, float[] sampleR) { // a method of AudioListener
     
     if (sampleL != null && sampleR != null) {

      float max = max(sum(sampleL, sampleR)) / 2;

      // println("Max: " + max); 
      
      if (max > level) {
        level = max;
      } 
      else {
        level = level * 0.8;
        // println("Level: " + level); 
      }
      
      leveldB = (float) (10 * log(level));
      // println("Level dB: " + leveldB); // returns negative numbers between - 0 and - 100
      myAudioAnalyse.analyse();
      
    }
  }
}
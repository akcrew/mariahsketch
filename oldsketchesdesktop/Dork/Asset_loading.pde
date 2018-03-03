void saveScores() {
  String[] aux=new String[20]; 
  for (int i=0; i<aux.length; i++) {
    if (i%2==0) {
      aux[i]=scoreList[i/2];
    } else {
      aux[i]=str(scoreNum[floor(i/2)]);
    }
  }
  if (!flags[1]) {
    highScoresEasy[1]=join(aux, '-');

    saveStrings("data/info/highscoresEasy.txt", highScoresEasy);
  } else {
    highScoresHard[1]=join(aux, '-'); 


    saveStrings("data/info/highscoresHard.txt", highScoresHard);
  }
}

void resetScoresEasy() {
  String aux[]={"", "...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0"};
  saveStrings("data/info/highscoresEasy.txt", aux);
}

void resetScoresHard() {
  String aux[]={"", "...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0"};
  saveStrings("data/info/highscoresHard.txt", aux);
}

void loadFlags() {
  String[] aux=loadStrings("data/info/flags.txt");

  flags=new boolean[aux.length-1];
  flags=boolean(aux);
  cursorType=int(aux[aux.length-1]);
  if (flags==null) {
    resetFlags();
    loadFlags();
  }
  if (flags[2]) {
    cutScenes[0]=true;
  }
  if (flags[3]) {
    cutScenes[1]=true;
  }
  if (flags[6]) {
    cutScenes[2]=true;
  }
}

void resetFlags() {
  String[] aux={"false", "false", "false", "false", "false", "false", "false", "false", "0"};
  saveStrings("data/info/flags.txt", aux);
}


void saveFlags() {
  String[] aux=new String[9];
  aux=str(flags);
  aux[aux.length-1]=str(cursorType);
  saveStrings("data/info/flags.txt", aux);
}

void loadHighScores() {
  for (int i=0; i<scoreList.length; i++) {
    scoreList[i]="...";
  }
  for (int i=0; i<scoreNum.length; i++) {
    scoreNum[i]=0;
  }

  highScoresEasy=loadStrings("data/info/highscoresEasy.txt"); 
  highScoresHard=loadStrings("data/info/highscoresHard.txt");
  if (!flags[1]) {
    if (highScoresEasy==null) {
      resetScoresEasy();
      loadHighScores();
    }
    String[] aux=split(highScoresEasy[1], '-'); 
    for (int i=0; i<aux.length; i++) {
      if (i<20) {
        if (i%2==0) {
          scoreList[i/2]=aux[i];
        } else {

          scoreNum[floor(i/2)]=int(aux[i]);
        }
      }
    }
  } else {

    if (highScoresHard==null) {
      resetScoresHard();
      loadHighScores();
    }
    String[] aux=split(highScoresHard[1], '-'); 
    for (int i=0; i<aux.length; i++) {
      if (i<20) {
        if (i%2==0) {
          scoreList[i/2]=aux[i];
        } else {

          scoreNum[floor(i/2)]=int(aux[i]);
        }
      }
    }
  }
}

void drawHighScores(int scl, float X, float Y) {
  pushStyle(); 
  colorMode(HSB); 
  textSize(scl); 
  textAlign(CENTER); 
  for (int i=0; i<scoreList.length; i++) {
    if (newHigh&&i==listPos) {
      fill(angle, 255, 255);
    } else {
      fill(255);
    }
    text(scoreList[i]+"........."+scoreNum[i], X, Y+i*25);
  }
  popStyle();
}
void loadStuff() {


  theme=minim.loadFile("data/sounds/theme.wav");
  shot=minim.loadFile( "data/sounds/shot.wav");
  reloadSound=minim.loadFile( "data/sounds/reload.wav");
  levelUp= minim.loadFile( "data/sounds/levelUp.wav");
  loss= minim.loadFile("data/sounds/loss.wav");
  splatter=minim.loadFile("data/sounds/dorkSplatter.wav");
  noAmmo= minim.loadFile("data/sounds/noAmmo.wav");
  UFOCrash= minim.loadFile("data/sounds/UFOCrash.wav");
  eSound=minim.loadFile("data/sounds/Eloop.wav");
  qSound=minim.loadFile("data/sounds/qSound.wav");
  rSound=minim.loadFile("data/sounds/rSound.wav");
  pieceBoom=minim.loadFile("data/sounds/pieceBoom.wav");


  desktop= loadImage("art/desktop.png");
  desktop.resize(width, 250);
  scoreboard= loadImage("art/scoreboard.png");
  flapAright= loadImage("art/flapAright.png");
  flapBright= loadImage("art/flapBright.png");
  flapAleft= loadImage("art/flapAleft.png");
  flapBleft= loadImage("art/flapBleft.png");
  dorkExp=loadImage("art/dorkExp.png");
  plane=loadImage("art/plane.png");
  planeBoom=loadImage("art/planeBoom.png");
  bullet=loadImage("art/bullet.png");
  volume=loadImage("art/volume.png");
  mute=loadImage("art/mute.png");
  wrench=loadImage("art/wrench.png");

  cursor[0]=loadImage("art/cursor1.png");
  cursor[1]=loadImage("art/cursor2.png");
  cursor[2]=loadImage("art/cursor3.png");
  cursor[3]=loadImage("art/cursor4.png");
  cursor[4]=loadImage("art/cursor5.png");

  whiteCursor[0]=loadImage("art/cursor1W.png"); 
  whiteCursor[1]=loadImage("art/cursor2W.png");
  whiteCursor[2]=loadImage("art/cursor3W.png");
  whiteCursor[3]=loadImage("art/cursor4W.png");
  whiteCursor[4]=loadImage("art/cursor5W.png");

  QWER[0]=loadImage("art/Q.png");
  QWER[1]=loadImage("art/W.png");
  QWER[2]=loadImage("art/E.png");
  QWER[3]=loadImage("art/R.png");

  bossIm[0]=loadImage("art/bossHead.png");
  bossIm[1]=loadImage("art/bossArmLeft.png"); 
  bossIm[2]=loadImage("art/bossArmRight.png");
  bossIm[3]=loadImage("art/bossPiece.png"); 
  bossIm[4]=loadImage("art/bossBody.png");

  for (int i=0; i<userHealth.length; i++) {
    userHealth[i]=loadImage("art/dorkIcon.png");
  }
  loadFlags();
  loadHighScores();

  cooldowns[0]=10;//10
  cooldowns[1]=20;//20
  cooldowns[2]=45;//45
  cooldowns[3]=90;//90

  threadDone=true;
  if (flags[1]) {
    startAmmo=25;
  } else {
    startAmmo=50;
  }
  shotIndex=startAmmo;
  levelChoose();
}

void highScoreLeaderBoard() {
  if (score>0) {
    checkScore(score, scoreNum, scoreList); 
    saveScores();
  }
}

void checkScore(int num, int[] list, String[] nameList) {
  int[] auxN; 
  String[] auxS; 
  for (int i=0; i<list.length; i++) {
    if (num>=list[i]) {
      listPos=i; 
      auxN=splice(list, num, i); 

      auxS=splice(nameList, name, i); 

      newHigh=true; 
      for (int j=0; j<list.length; j++) {
        scoreNum[j]=auxN[j]; 
        scoreList[j]=auxS[j];
      }
      return;
    }
  }
}
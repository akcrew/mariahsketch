import ddf.minim.*; //<>//


//Dork Hunt 
//Game by GRsni
//Version 1.2.5 for Processing 3.x
//---------------------------------------
//TO DO:
//Re-balance bullet usage(needs testing)
//---------------------------------------
//All audio files belong to their respective owners.
//---------------------------------------

Minim minim; 

AudioPlayer theme;
AudioPlayer loss;
AudioPlayer shot;
AudioPlayer splatter;
AudioPlayer reloadSound;
AudioPlayer levelUp;
AudioPlayer noAmmo;
AudioPlayer UFOCrash;
AudioPlayer qSound;
AudioPlayer eSound;
AudioPlayer rSound;
AudioPlayer pieceBoom;


PImage titlebaricon;
PImage desktop;
PImage bullet;
PImage scoreboard;
PImage flapAright;
PImage flapBright;
PImage flapAleft;
PImage flapBleft;
PImage dorkExp;
PImage plane;
PImage planeBoom;
PImage volume;
PImage mute;
PImage wrench;
PImage[] cursor=new PImage[5];
PImage[] whiteCursor=new PImage[5];
PImage[] QWER = new PImage[4];
PImage[] bossIm= new PImage[5];
PImage[] userHealth=new PImage[10];

PFont scoreFont, ammoFont;
String[] highScoresEasy;
String[] highScoresHard;
String[] scoreList=new String[10];
int[] scoreNum=new int[10];
boolean fullS=false;
boolean[] flags;//0=mute, 1=difficulty 2=Q 3=W 4=E 5=R 6=kill dorks 7=cursor type
String name="";
float[] cooldowns=new float[4];
boolean[] abilities=new boolean[4];
float[] remains=new float[4];
int lastMillis;
int wTime, eTime, wRest, eRest;
int bonusTime;
float wActivation=1.0;
boolean eActivation=false;


ArrayList<Duck> ducks= new ArrayList<Duck>();
ArrayList<Bullet> bullets=new ArrayList<Bullet>();
ArrayList<Score> points=new ArrayList<Score>();
ArrayList<Plane> planes=new ArrayList<Plane>();
Boss boss;

int level=1;
static int startAmmo;
int score=0;
float up=0.01;
static float grav=.1;
float life=100;
int listPos=0;
int txtSize;
int cursorType;
boolean typing;
boolean newHigh=false;
boolean nameDone=false;
boolean[] cutScenes=new boolean[4];

int gameState=0;
int levelType=1;
boolean gameStart=false;
boolean clicked=false;
boolean threadDone=false;

boolean bossSpawned=false;

int killCount=0;
int killsSinceAmmo=0;

int shotIndex;
float angle=0;
int time2=0;


void setup() { 
  fullScreen();

  titlebaricon=loadImage("data/art/dorkIcon.png");


  surface.setIcon(titlebaricon);
  surface.setTitle("Dork Hunt");
  minim =new Minim(this);
  noCursor();


  scoreFont=loadFont("info/OCRAExtended.vlw");
  ammoFont=loadFont("info/Power_Clear_Bold-40.vlw");
  textFont(scoreFont, 30);
  thread("loadStuff");
}

void draw() { 
  background(120);


  switch(gameState) {
  case 0:
    drawGameState0();//name selection
    break;
  case 1:
    drawGameState1();//actual game
    break;
  case 2:
    drawGameState2();//intro menu
    break;
  case 3:
    drawGameState3();//game info
    break;
  case 4:
    drawGameState4();//death screen
    break;
  case 5:
    drawGameState5();//pause screen
    break;
  case 6:
    drawGameState6();//settings
    break;
  }
  if (threadDone) {
    if (gameState==4||gameState==0) {
      image(whiteCursor[cursorType], mouseX-10, mouseY-10);
    } else if (gameState==1&&mousePressed) {
      image(whiteCursor[cursorType], mouseX-10, mouseY-10);
    } else {
      image(cursor[cursorType], mouseX-10, mouseY-10);
    }
  }

  angle+=.1; 
  txtSize-=2;
}


void mousePressed() {
  if (gameState==1) {
    if (mouseY<height-250) {
      if (shotIndex>0) {
        if (!eActivation) {
          if (!flags[0]) {
            shot.play(0);
          }
          if (shot.position()==shot.length()) {
            shot.rewind();
          }
          bullets.add(new Bullet(mouseX, mouseY, 0)); 
          bulletRemove(); 

          shotIndex--;
        }
      }
    }

    if (mouseX>675&&mouseX<675+115&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>15) {
        if (!abilities[0]&&flags[2]) {
          Q();
          points.add(new Score(235, height-86, -15, 1));
          if (!flags[0]) {
            qSound.play(0);
          }
          shotIndex-=15;
          abilities[0]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (mouseX>675+145&&mouseX<675+115+145&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>20) {
        if (!abilities[1]&&flags[3]) {
          points.add(new Score(235, height-86, -20, 1));
          shotIndex-=20;
          abilities[1]=true;
          wActivation=0.5;
          wTime=millis();
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (mouseX>675+145*2&&mouseX<675+115+145*2&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>25) {
        if (!abilities[2]&&flags[4]) {
          E();
          points.add(new Score(235, height-86, -25, 1));
          eTime=millis();
          shotIndex-=25;
          abilities[2]=true;
          eActivation=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (mouseX>675+145*3&&mouseX<675+115+145*3&&mouseY>615&&mouseY<615+115) {
      if (shotIndex>30) {
        if (!abilities[3]&&flags[5]) {
          if (!flags[0]) {
            rSound.play(0);
          }
          R();
          points.add(new Score(235, height-86, -30, 1));
          shotIndex-=30;
          abilities[3]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    }
  }
}

void mouseReleased() {
  clicked=false;
}

void keyPressed() {
  if (!typing) {
    if (key==ESC&&key==SHIFT) {
      exit();
    }
    if (key==ESC) {

      key=0; 
      if (gameState==2) {
        saveFlags();
        exit();
      } else if (gameState==1) {
        if (eSound.isPlaying()) {
          eSound.pause();
          eSound.rewind();
        }
        gameState=5;
        eRest=eTime+6500-millis();
        wRest=wTime+10000-millis();
      } else if (gameState==5) {
        if (abilities[2]&&!flags[0]) {
          eSound.loop();
        }
        eTime=millis()-(6500-eRest);
        gameState=1;

        wTime=millis()+wRest-10000;
      } else {
        gameState=2; 
        time2=0;
      }
    }

    if (keyCode=='P'||keyCode=='p'||keyCode==' ') {
      if (gameState==1&&gameStart) {
        gameState=5;
      } else if (gameState==5) {
        gameState=1;
      }
    }
    if (key=='Q'||key=='q') {
      if (shotIndex>15) {
        if (!abilities[0]&&flags[2]) {
          Q();
          points.add(new Score(235, height-86, -15, 1));
          if (!flags[0]) {
            qSound.play(0);
          }
          shotIndex-=15;
          abilities[0]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (key=='w'||key=='W') {
      if (shotIndex>20) {
        if (!abilities[1]&&flags[3]) {
          points.add(new Score(235, height-86, -20, 1));
          shotIndex-=20;
          abilities[1]=true;
          wActivation=0.5;
          wTime=millis();
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (key=='E'||key=='e') {
      if (shotIndex>25) {
        if (!abilities[2]&&flags[4]) {
          E();
          points.add(new Score(235, height-86, -25, 1));
          eTime=millis();
          shotIndex-=25;
          abilities[2]=true;
          eActivation=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    } else if (key=='R'||key=='r') {
      if (shotIndex>30) {
        if (!abilities[3]&&flags[5]) {
          if (!flags[0]) {
            rSound.play(0);
          }
          R();
          points.add(new Score(235, height-86, -30, 1));
          shotIndex-=30;
          abilities[3]=true;
        }
      } else {
        if (!flags[0]) {
          noAmmo.play(0);
        }
      }
    }
  } else {
    if (keyCode==BACKSPACE) {
      if (name.length()>0) {
        name=name.substring(0, name.length()-1);
      }
    } else if (keyCode==DELETE) {
      name="";
    } else  if (keyCode!=SHIFT&&keyCode!=ENTER&&keyCode!=TAB&key!='\uFFFF') {
      name=name+key;
    } else if (keyCode==' ') {
      name=name.substring(0, name.length()-1); 
      name=name+' ';
    } else if (keyCode==ENTER) {
      if (gameState==0&&threadDone) {
        gameState=2;
        nameDone=true;
        typing=false;
      }
    }
  }
}

void drawGameState0() {

  pushStyle();
  fill(0);
  stroke(0);
  textFont(ammoFont);
  if (!nameDone) {
    if (!focused) {
      pushStyle();
      colorMode(HSB);
      fill(angle, 255, 255);

      textAlign(CENTER);
      textSize(25+abs(20*sin(angle/10)));
      if (angle>255) {
        angle=0;
      }
      text("Click anywhere on the screen!", width/2, height-200);
      popStyle();
    } else {
      if (sin(angle)>0) {
        String aux="Enter your name"+name;
        stroke(0);
        strokeWeight(4);
        strokeCap(SQUARE);
        line(width/2+aux.length()*20/2, 170, width/2+aux.length()*20/2, 210);
      }
    }
    typing=true;
    textAlign(CENTER);
    text("Enter your name:"+name, width/2, 200);

    text("Press ENTER when you're done.", width/2, 300);
  } else {
    typing=false;
  }
  popStyle();
}


void drawGameState1() {//actual game
  pushStyle();
  rectMode(CORNER);
  background(#54C0FF);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  if (gameStart) {
    if (!theme.isPlaying()&&!flags[0]) {
      theme.loop();
    }

    for (int i=ducks.size()-1; i>=0; i--) {//dork handling code
      Duck duck= ducks.get(i);
      if (duck.alpha<3) {
        ducks.remove(i);
      }
      duck.show(); 
      duck.move();
      if (duck.click(true, mouseX, mouseY)&&duck.alive) {
        killDork(duck);
      }
    }

    for (int i=planes.size()-1; i>=0; i--) {//UFO handling code
      Plane plane=planes.get(i);
      if (plane.alpha<3) {
        planes.remove(i);
      }
      plane.move();
      plane.show(); 
      if (mouseX>plane.x&&mouseX<(plane.x+plane.l)&&mouseY>plane.y&&mouseY<(plane.y+plane.h)&&mousePressed&&!clicked&&shotIndex>0&&plane.alive) {
        killPlane(plane);
      }
    }
    if (bossSpawned) {
      boss.update();
      boss.hit();
      boss.show();
    }

    image(desktop, 0, height-250);
    textSize(20);
    text(int(frameRate), 0, 20);

    noFill();
    rectMode(CORNER);
    stroke(25, 0, 0);
    strokeWeight(4);
    rect(40, 550, 130+21*name.length(), 50, 4);
    int addition=0;
    if (level<10) {
      addition=0;
    } else if (level>9&&level<100) {
      addition=20;
    } else if (level>99) {
      addition=40;
    }
    rect(40, 615, 180+addition, 50, 4);
    rect(40, 680, 300, 50, 4);

    textSize(35);
    fill(#FFD800);
    text("User:"+name, 50, height-180);
    text("Level:"+level, 50, height-110);
    text("Ammo:"+shotIndex, 50, height-45);
    if (shotIndex<10) {
      image(bullet, 200, height-83);
    } else if (shotIndex>9&&shotIndex<100) {
      image(bullet, 220, height-83);
    } else if (shotIndex>99&&shotIndex<1000) {
      image(bullet, 240, height-83);
    } else {
      image(bullet, 260, height-83);
    }
    if (shotIndex<10) {
      textFont(ammoFont, 40);
      fill(50, 20, 0, sin(angle)*255);
      text("Low Ammo", 350, height-45);
      textFont(scoreFont, 30);
    }

    scoreBoardAnim(); 
    image(scoreboard, width-300, 0); 
    textSize(35); 
    fill(#FFD800); 
    textAlign(BOTTOM, BOTTOM); 
    text("Score:", width-270, 70); 
    textAlign(LEFT); 
    if (score>999999||score<-99999) {
      textSize(25);
    }
    text(score, width-150, 65); 
    noTint(); 

    if (shotIndex<0) {//if no ammo 
      fill(#502626, map(sin(angle), -1, 1, 0, 255)); 
      textSize(50); 
      text("NO AMMO", 150, height-65);
    }
    for (int i=points.size()-1; i>=0; i--) {
      Score scr=points.get(i); 
      scr.show(); 
      if (scr.up>4) {
        points.remove(i);
      }
    }
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i); 
      bullet.show(); 
      bullet.d+=.65; 

      if (bullet.d>10) {
        bullets.remove(i);
      }
    }
    levelCheck(); 
    checkGameLose(); 

    levelType();
    misses();
    abilitiesAnim();
    cutscenes();
    if (wActivation==0.5&&flags[7]) {
      W();
    }
    if (abilities[2]) {
      E();
    }
  }//end gameStart
  popStyle();
} //end gameState1



void drawGameState2() {

  pushStyle();
  rectMode(CORNER);
  background(84, 192, 255);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  if (theme.isLooping()) {
    theme.pause();
  }
  fill(0);
  String s="User:"+name;
  text(s, 30, 60);


  Button w=new Button(true, 20+s.length()*23.5, 25, 36, 36, 4, 4, #000000, #484848);
  w.show();

  if (w.click(mouseX, mouseY, false)) {
    textSize(20);
    text("Change name", s.length()*23.5-20, 95);
  }
  if (w.click(mouseX, mouseY, true)) {
    gameState=0;
    nameDone=false;
  }
  stroke(50);
  noFill();
  strokeWeight(4);

  image(wrench, s.length()*23.5+20, 25 );
  rect(20+s.length()*23.5, 25, 36, 36, 4);

  Button vol=new Button(false, width-70, 25, 35, 35, 2, 4, #000000, #484848);
  vol.show();
  if (vol.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    flags[0]=!flags[0];
    if (flags[0]) {
      checkMusic();
    }
    saveFlags();
  }
  if (!flags[0]) {
    image(volume, width-70, 25);
  } else {
    image(mute, width-70, 25);
  }
  noFill();
  stroke(50);
  rect(width-70, 25, 36, 36, 2);

  if (vol.click( mouseX, mouseY, false)) {
    pushStyle();
    textSize(20);
    textAlign(CENTER);
    fill(0);
    if (!flags[0]) {
      text("Mute", width-48, 95);
    } else {
      text("Unmute", width-48, 95  );
    }
    popStyle();
  }


  time2++;
  textSize(100+int(10*sin(angle))); 

  fill(#FFD800); 
  textAlign(CENTER);

  pushMatrix();
  if (time2>6000) {

    translate(width/2, 200);
    rotate(angle/2);
    text("Dork Hunt!", 0, 0);
  } else {
    text("Dork Hunt!", width/2, 200);
  }

  popMatrix();
  fill(#FFD800); 
  if (!flags[1]) {
    textFont(ammoFont);
    textSize(35);
    fill(#FFFF00);
    text("Highscores-Easy Mode", 1100, 300);
    text("------------", 1100, 330);
  } else {
    textFont(ammoFont);
    textSize(35);
    fill(#FFFF00);
    text("Highscores-Hard Mode", 1100, 300);
    text("------------", 1100, 330);
  }

  drawHighScores(20, 1100, 350);


  textFont(scoreFont);
  fill(#FF8705); 
  strokeWeight(4); 
  stroke(200); 

  rect(width/2-150, height/2+150, 300, 75, 5); 
  rect(width/2-150, height/2+250, 300, 75, 5); 
  fill(255); 

  if (!gameStart) { 
    textSize(75); 
    Button play=new Button(true, width/2-150, height/2-50, 300, 150, 10, 4, #FF8705, #C8C8C8, "Play", #FFFFFF);
    play.show();
    if (play.click(mouseX, mouseY, true)) {
      gameStart=true;
      gameState=1;
    }
  } else {
    Button newGame=new Button(true, width/2-275, height/2-50, 250, 150, 5, 4, #FF8705, #C8C8C8, "New Game", #FFFFFF);
    Button Continue=new Button(true, width/2+25, height/2-50, 250, 150, 5, 4, #FF8705, #C8C8C8, "Continue", #FFFFFF);
    newGame.show();
    Continue.show();
    if (newGame.click(mouseX, mouseY, true)) {
      resetGame();
      gameState=1;
      gameStart=true;
      theme.rewind();
    }
    if (Continue.click(mouseX, mouseY, true)) {
      gameState=1;
    }
  }

  textSize(40); 

  Button gameInfo=new Button(true, width/2-150, height/2+150, 300, 75, 5, 4, #FF8705, #C8C8C8, "Game Info", #FFFFFF);
  gameInfo.show();
  if (gameInfo.click(mouseX, mouseY, true)) {
    gameState=3;
    ducks.add(new Duck(550, 420, 2, 1));
    planes.add(new Plane(490, 490));
  }

  Button controls=new Button(true, width/2-150, height/2+250, 300, 75, 5, 4, #FF8705, #C8C8C8, "Settings", #FFFFFF);
  controls.show();
  if (controls.click(mouseX, mouseY, true)) {
    gameState=6;
  }
  Button quit=new Button(true, 50, height-125, 150, 75, 0, 4, #969696, #C8C8C8, "Quit", #320000);
  quit.show();
  if (quit.click(mouseX, mouseY, true)&&!clicked) {
    saveFlags();
    exit();
  }
  popStyle();
}



void drawGameState3() {
  pushStyle();
  rectMode(CORNER);
  background(84, 192, 255);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  fill(84, 192, 255); 
  rect(0, 0, width, height); 

  fill(#FFD800); 
  textSize(75); 
  textAlign(CENTER); 
  text("Game Info", width/2, 150); 

  textSize(35); 
  text("-Get as many points as you can.", width/2, 250); 
  textSize(20); 
  textAlign(LEFT); 
  text("-Shoot the dorks to earn points.", 150, 450); 
  text("-Try and get the UFOs.", 150, 520); 
  textSize(30); 
  fill(#712323); 
  textAlign(CENTER); 
  text("-If you run out of bullets you lose.", width/2, 330);

  ducks.get(ducks.size()-1).show();


  planes.get(planes.size()-1).show();

  textSize(35); 
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, #969696, #C8C8C8, "Back to menu", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2; 
    ducks.remove(ducks.size()-1);
  }
  popStyle();
}



void drawGameState4() {
  angle+=1;
  if (angle>255) {
    angle=0;
  }
  pushStyle();
  if (theme.isLooping()) {
    theme.pause();
  }
  background(0); 

  fill(255); 
  textAlign(CENTER); 
  textSize(75  );
  text("You lost", width/2, height/2-200);
  textSize(50);
  text("Level:" + level+"    Score:"+score, width/2, height/2-100);
  if (newHigh) {
    if (!flags[1]) {
      pushStyle();
      colorMode(HSB);
      fill(angle, 255, 255);
      text("New highscore(Easy)!", width/2, height/2+50);
      text("------------", width/2, height/2+75);
      popStyle();
    } else {
      pushStyle();
      colorMode(HSB);
      fill(angle, 255, 255);
      text("New highscore(Hard)!", width/2, height/2+50);
      text("------------", width/2, height/2+75);
      popStyle();
    }
  } else {
    if (!flags[1]) {
      fill(255);
      text("Highscores(Easy)", width/2, height/2+25);
      text("------------", width/2, height/2+75);
    } else {
      fill(255);
      text("Highscores(Hard)", width/2, height/2+25);
      text("------------", width/2, height/2+75);
    }
  }

  fill(255);


  drawHighScores(16, width/2, height/2+100);

  Button menu=new Button(true, 50, height-150, 250, 100, 0, 10, #C8C8C8, #646464, "Menu", #320000);
  Button retry=new Button(true, width-300, height-150, 250, 100, 0, 10, #C8C8C8, #646464, "Retry", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    gameState=2;
    resetGame();
    gameStart=false;
    time2=0;
  }
  retry.show();
  if (retry.click(mouseX, mouseY, true)) {
    resetGame();
    gameState=1; 
    gameStart=true;
  }
}



void drawGameState5() {
  pushStyle();
  background(84, 192, 255);
  image(desktop, 0, height-250);

  noFill();
  rectMode(CORNER);
  textAlign(BOTTOM, BOTTOM);
  strokeWeight(4);
  stroke(25, 0, 0);
  rect(40, 550, 130+21*name.length(), 50, 4);
  int addition=0;
  if (level<10) {
    addition=0;
  } else if (level>9&&level<100) {
    addition=20;
  } else if (level>99) {
    addition=40;
  }
  rect(40, 615, 180+addition, 50, 4);
  rect(40, 680, 300, 50, 4);

  textSize(35);

  fill(#FFD800);
  text("User:"+name, 50, height-180);
  text("Level:"+level, 50, height-110);

  text("Ammo:"+shotIndex, 50, height-45);

  if (shotIndex<10) {
    image(bullet, 200, height-83);
  } else if (shotIndex>9&&shotIndex<100) {
    image(bullet, 220, height-83);
  } else if (shotIndex>99&&shotIndex<1000) {
    image(bullet, 240, height-83);
  } else {
    image(bullet, 260, height-83);
  }
  if (shotIndex<10) {
    textFont(ammoFont, 40);
    fill(50, 20, 0, sin(angle)*255);
    text("Low Ammo", 350, height-45);
    textFont(scoreFont, 30);
  }
  for (Duck duck : ducks) {
    duck.show();
  }
  for (Plane plane : planes) {
    plane.show();
  }
  image(scoreboard, width-300, 0); //scoreboard
  textSize(35); 
  fill(#FFD800); 
  textAlign(BOTTOM, BOTTOM); 
  text("Score:", width-270, 70); 
  textAlign(LEFT); 
  if (score>999999) {
    textSize(25);
  }
  text(score, width-150, 65); //end scoreboard

  if (shotIndex<0) {//if no ammo 
    fill(#502626, map(sin(angle), -1, 1, 0, 255)); 
    textSize(50); 
    text("NO AMMO", 150, height-65);
  }
  for (int i=points.size()-1; i>=0; i--) {
    Score scr=points.get(i); 
    scr.show(); 

    if (scr.up>4) {
      points.remove(i);
    }
  }

  fill(120, 180); 
  textSize(30); 
  noStroke();
  rect(0, 0, width, height); 
  Button vol=new Button(false, width-70, 25, 35, 35, 2, 4, #000000, #484848);
  vol.show();
  if (vol.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    flags[0]=!flags[0];
    if (flags[0]) {
      checkMusic();
    }
    saveFlags();
  }
  if (!flags[0]) {
    image(volume, width-70, 25);
  } else {
    image(mute, width-70, 25);
  }
  noFill();
  stroke(50);
  rect(width-70, 25, 36, 36, 2);
  if (vol.click(mouseX, mouseY, false)) {
    pushStyle();
    textSize(20);
    fill(0);
    textAlign(CENTER);
    if (!flags[0]) {
      text("Mute", width-48, 100);
    } else {
      text("Unmute", width-48, 100);
    }
    popStyle();
  } 
  textSize(75);
  Button paused=new Button(true, width/2-200, height/2-200, 400, 300, 10, 4, #FF8705, #C8C8C8, "Game paused", #FFFFFF);

  if (paused.click(mouseX, mouseY, false)) {
    paused.content="Unpause the game?";
  }
  paused.show();
  if (paused.click(mouseX, mouseY, true)) {
    if (abilities[2]&&!flags[0]) {
      eSound.loop();
    }
    eTime=millis()-(6500-eRest);
    gameState=1;

    wTime=millis()+wRest-10000;
  }
  textSize(40);
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, #969696, #C8C8C8, "Back to menu", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2;
    time2=0;
  }
  popStyle();
}



void drawGameState6() {
  background(#54C0FF);
  pushStyle();
  if (theme.isLooping()) {
    theme.pause();
  }

  textSize(40);
  textFont(ammoFont);
  textAlign(LEFT);
  fill(0);
  text("Game settings", 50, 75);

  textSize(25);

  text("-Choose the difficulty:", 50, 200 );
  noFill();
  rectMode(CORNER);
  rect(310, 170, 80, 40);
  pushStyle();
  if (flags[1]) {
    text("Hard", 400, 200);
    Button diff=new Button(false, 351, 171, 39, 39, 0, 0, #C80000, #000000);
    diff.show();
    if (diff.click(mouseX, mouseY, true)&&!clicked) {
      shotIndex=0;
      reload(25);
      flags[1]=!flags[1];
      resetGame();
      loadHighScores();
      saveFlags();
    }
  } else {
    text("Easy", 400, 200);
    Button diff=new Button(false, 311, 171, 39, 39, 0, 0, #09C600, #000000);
    diff.show();
    if (diff.click(mouseX, mouseY, true)&&!clicked) {
      clicked=true;
      shotIndex=0;
      reload(50);
      flags[1]=!flags[1];
      resetGame();
      loadHighScores();
      saveFlags();
    }
  }
  popStyle();
  fill(0);
  text("-Reticle selection:", 50, 300);



  Button cursorRect=new Button(false, 300, 275, 40, 40, 4, 3, #54C0FF, #1E1E1E);
  cursorRect.show();
  if (cursorRect.click(mouseX, mouseY, true)&&!clicked) {
    clicked=true;
    cursorType++;
    if (cursorType>4) {
      cursorType=0;
    }
  }
  if (!cursorRect.click(mouseX, mouseY, false)) {
    text("Click on the reticle to change it.", 360, 300);
  }

  image(cursor[cursorType], cursorRect.x+10, cursorRect.y+10);

  text("Game made by GRsni", width-220, 50+10*sin(angle));
  text("-Reset all saved game data:", 50, height-140);
  textSize(35);
  Button reset=new Button(true, 400, height-190, 150, 80, 4, 4, #969696, #C8C8C8, "Reset data", #320000); 
  reset.show();
  if (mouseX>reset.x&&mouseX<reset.x+reset.Xl&&mouseY>reset.y&&mouseY<reset.x+reset.Yl) {
    fill(255, 0, 0);
    textSize(10);
    text("This will delete all data. Are you sure you want to proceed?", 600, height-200, 500, 300);
  }
  if (reset.click(mouseX, mouseY, true)) {
    resetFlags();
    loadFlags();

    resetScoresEasy();
    resetScoresHard();
    loadHighScores();
    resetGame();
    gameStart=false;
  }
  textFont(scoreFont);
  textSize(35); 
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, #969696, #C8C8C8, "Back to menu", #320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2;
    time2=0;
  }


  popStyle();
}


void dSpawn() {//spawns the dorks
  if (killCount==0&&!flags[6]) {
    ducks.add(new Duck(random(width), height-250, random(.5, 1), 1) );
  } else {
    ducks.add(new Duck(random(width), height-250, random(.5, 1), dorkLives()) );
  }

  Duck duck= ducks.get(ducks.size()-1); 
  if (wActivation==0.5) {
    duck.speed.y=random(-11, -13);
  } else {
    duck.speed.y=random(-10, -13);
  }
  duck.chooseDir();
}



void pSpawn() {//spawns the UFOs
  if (random(1)>.5) {//planes towards the right
    planes.add(new Plane(-50, random(50, 250))); 
    Plane plane=planes.get(planes.size()-1); 
    plane.rightDir=true; 
    plane.speed.x=(10+level*.13)*wActivation; 
    plane.speed.y=(random(0, 2.5))*wActivation;
  } else {//planes towards the left
    planes.add(new Plane(width+50, random(75, 225))); 
    Plane plane=planes.get(planes.size()-1); 
    plane.rightDir=false; 
    plane.speed.x=-10-level*.13; 
    plane.speed.y=random(0, 2.5);
  }
}

int dorkLives() {
  float r=random(1);

  if (r<.8) {
    return 1;
  } else if (r>=.8&&r<.95) {
    return 2;
  } else {
    return 3;
  }
}

void killDork(Duck d) {
  int point=0;
  clicked=true;
  if (d.lives>1) {
    d.lives--;
  } else {

    d.alive=false;
    d.rotation=random(-PI, PI);
    d.speed.y=0;
    if (!flags[0]) {
      splatter.play(0);
    }
    killCount++;
    if (d.initLives==1) {
      point=200;
    } else if (d.initLives==2) {
      point=400;
    } else {
      point=900;
    }
    score+=point;
    points.add(new Score(d.x, d.y, point, 0));

    if (!flags[1]) {//easy mode
      if (random(1)>0.3+log(level)*0.25||killsSinceAmmo>level/2&&d.initLives!=3) {
        chooseBonus();
        killsSinceAmmo=0;
      } else if (d.initLives==3) {
        killsSinceAmmo=0;
        int r=10+int(random(5));
        reload(r);
        points.add(new Score(235, height-84, r, 1));
      } else {
        killsSinceAmmo++;
      }
    } else {//hard mode
      if (random(1)>.4+log(level)*.24||killsSinceAmmo>(25+log(level)*2)&&d.initLives!=3) {
        chooseBonus();
        killsSinceAmmo=0;
      } else if (d.initLives==3) {
        killsSinceAmmo=0;
        int r=10+int(random(5));
        reload(r);
        points.add(new Score(235, height-84, r, 1));
      } else {
        killsSinceAmmo++;
      }
    }
  }
}

void killPlane(Plane p) {
  clicked=true;
  points.add(new Score(p.x, p.y, 1000, 0));
  p.alive=false;
  p.speed.y=0;
  if (!flags[0]) {
    UFOCrash.play(0);
  }
  score+=1000;
  killCount++;
  int reloadAmount;
  if (levelType==2) {
    reloadAmount=10;
    reload(reloadAmount);
  } else {
    reloadAmount=20;
    reload(reloadAmount);
  }
  points.add(new Score(235, height-84, reloadAmount, 1));
}


void levelType() {//spawn algorithm 

  if (levelType==2) {
    fill(120, 0, 0); 
    textAlign(CENTER); 
    if (txtSize>30) {
      textSize(txtSize);
    } else {
      textSize(30);
    }
    textAlign(LEFT, TOP ); 
    text("Bonus level", 0, 5);
    if (!abilities[1]) {
      if (frameCount%10==0) {
        pSpawn();
      }
    } else {
      if (frameCount%20==0) {
        pSpawn();
      }
    }
  } else if (levelType==1) {
    if (!flags[1]) {
      if (frameCount%ceil(100/(.1*level+1))==0) {
        dSpawn();
      }
      if (frameCount%(400+level*30)==0) {
        pSpawn();
      }
    } else {
      if (frameCount%ceil(100/(.25*level+1))==0) {
        dSpawn();
      }
      if (frameCount%(1000+level*60)==0) {
        pSpawn();
      }
    }
  } else if (levelType==3) {
    fill(120, 0, 0);
    textAlign(LEFT, TOP);
    if (txtSize>40) {  
      textSize(txtSize);
      text("Boss fight", map(txtSize, 100, 40, width/2, 0), map(txtSize, 100, 40, height/2, 0));
    } else {
      textSize(30);
      text("Boss fight", 0, 5);
    }

    if (!bossSpawned) {
      PVector aux1=new PVector(random(240, 250), random(180, 300));
      PVector aux2=new PVector(width-random(240, 260), random(180, 300));
      PVector aux3=new PVector(random(width/2-95, width/2-55), random(50, 70));
      boss=new Boss(aux1, aux2, aux3);
      bossSpawned=true;
    }
  }
}



void levelChoose() {//level selection
  if (flags[1]) {//hard
    if (level%20==0&&level%15!=0) {
      for (int j=0; j<ducks.size(); j++) {
        ducks.remove(j);
      }
      levelType=2;
      bonusTime=millis();
      txtSize=70;
    } else if (level%15==0) {
      for (int i=0; i<ducks.size(); i++) {
        ducks.remove(i);
      }
      for (int j=0; j<planes.size(); j++) {
        planes.remove(j);
      }
      levelType=3;
      txtSize=100;
    } else {
      levelType=1;
      if (level-1%10==0) {
        for (int j=0; j<planes.size(); j++) {
          planes.remove(j);
        }
      }
    }
  } else {//easy 
    if (level%10==0&&level%15!=0) {
      for (int j=0; j<ducks.size(); j++) {
        ducks.remove(j);
      }
      levelType=2;
      txtSize=70;
      bonusTime=millis();
    } else if (level%15==0) {
      for (int i=0; i<ducks.size(); i++) {
        ducks.remove(i);
      }
      for (int j=0; j<planes.size(); j++) {
        planes.remove(j);
      }
      levelType=3;
      txtSize=100;
    } else {
      levelType=1;
      if (level-1%10==0) {
        for (int j=0; j<planes.size(); j++) {
          planes.remove(j);
        }
      }
    }
  }
}

void misses() {//remove the missed dorks and UFOs
  for (int i=ducks.size()-1; i>=0; i--) {//remove missed dorks
    Duck duck=ducks.get(i); 

    if (duck.y>height-200&&duck.alive) {
      points.add(new Score(width-150, 90, -1000, 0)); 
      score-=1000; 
      ducks.remove(i);
      life-=5;
    }
  }

  for (int i=planes.size()-1; i>=0; i--) {//remove missed planes
    Plane p= planes.get(i); 
    if ((p.rightDir&&p.x>width)||(!p.rightDir&&p.x<0)||p.y>height-300) {

      planes.remove(i);
    }
  }
}

void levelCheck() {//check level up requirements

  if (levelType==1) {
    if (killCount>=floor(3+sqrt(level)*1.5)) {
      score+=2000*level; 
      points.add(new Score(width-175, 50, 1000*level, 0)); 
      level++; 
      levelChoose();
      killCount=0; 
      if (level%15!=0) {
        points.add(new Score(width/2, height-500, 0, 2));
      }

      lastMillis=millis();
      if (!flags[0]) {
        levelUp.play(0);
      }
    }
  } else if (levelType==3) {
    if (boss.health3<1) {
      score+=1000*level;
      points.add(new Score(width-175, 50, 2250*level, 0)); 
      level++;
      if (!flags[0]) {
        pieceBoom.play(0);
      }
      levelChoose();
      points.add(new Score(width/2, height-500, 0, 2));
      if (!flags[0]) {
        levelUp.play(0);
      }
    }
  } else if (levelType==2) {
    if (millis()-bonusTime>4500) {
      level++;
      levelChoose();
      killCount=0;
      points.add(new Score(width/2, height-500, 0, 2));
      if (!flags[0]) {
        levelUp.play(0);
      }
    }
  }
}

void checkGameLose() {//lose condition when out of ammo
  if (shotIndex<1) {
    gameState=4; 
    highScoreLeaderBoard();
    if (!flags[0]) {
      loss.play(0);
    }
  }
}

void resetGame() {//resets all dorks, planes, and bullets and refills the ammo, sets temporal flags back to initial state
  level=1;
  levelType=1;
  score=0; 
  bossSpawned=false;
  killCount=0; 
  shotIndex=0;
  newHigh=false;
  gameStart=false;
  theme.rewind();

  if (!flags[1]) {
    reload(50);
  } else {
    reload(25);
  }

  for (int i=0; i<abilities.length; i++) {
    abilities[i]=false;
    remains[i]=0;
  }

  for (int i=ducks.size()-1; i>=0; i--) {
    ducks.remove(i);
  }
  for (int i=0; i<points.size(); i++) {
    points.remove(i);
  }
  for (int i=planes.size()-1; i>=0; i--) {
    planes.remove(i);
  }
  for (int i=0; i<bullets.size(); i++) {
    bullets.remove(i);
  }
}

void reload(int num) {//self explanatory
  if (gameState==1) {
    if (!flags[0]) {

      reloadSound.play(0);
    }
  }
  for (int i=0; i<num; i++) {
    shotIndex++;
  }
}

void checkMusic() {
  theme.pause();
  loss.pause();
  shot.pause();
  splatter.pause();
  reloadSound.pause();
  levelUp.pause();
  noAmmo.pause();
  UFOCrash.pause();
}


void cutscenes() {

  if (level==5) {
    if (!flags[2]||cutScenes[0]) {
      if (millis()-lastMillis<2000) {
        cutScenes[0]=true;
        flags[2]=true;
        saveFlags();
        noStroke();
        fill(0, 100);
        rect(0, height-250, width, height);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text("Press Q to use the shotugn", 600, height-50);
        fill(255, 50);
        rect(685, 610, 95, 95);
      } else {
        cutScenes[0]=false;
      }
    }
  }

  if (level==9) {
    if (!flags[3]||cutScenes[1]) {
      if (millis()-lastMillis<2000) {
        cutScenes[1]=true;
        flags[3]=true; 
        flags[4]=true;
        flags[5]=true;
        saveFlags();
        noStroke();
        fill(0, 100);
        rect(0, height-250, width, height);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text("Check your new abilitites", 650, height-50);
        fill(255, 50);
        for ( int i=0; i<3; i++) {
          rect(830+145*i, 610, 95, 95);
        }
      } else {
        cutScenes[1]=true;
      }
    }
  }

  if (!flags[7]) {
    if (killCount<1) {
      wActivation=0.5;
      noStroke();

      fill(0, 140);
      rect(0, 0, width, height-250);
      if (ducks.size()>0&&ducks.get(0).y<height-300) {
        fill(255);
        if (ducks.get(0).x>width/2) {
          text("Click on the dork", 100, 200);
          stroke(0);
          strokeWeight(2);
          line( 300, 220, ducks.get(0).x-20, ducks.get(0).y+20);
        } else {
          text("Click on the dork", 900, 200);
          stroke(0);
          strokeWeight(2);
          line( 1100, 220, ducks.get(0).x+100, ducks.get(0).y+20);
        }

        noStroke();
        fill(255, 40);
        rect(ducks.get(0).x, ducks.get(0).y, ducks.get(0).w/ducks.get(0).d, ducks.get(0).w/ducks.get(0).d);
      }
    } else {
      flags[7]=true;
      saveFlags();
      wActivation=1;
    }
  }
}

void scoreBoardAnim() {//fades the scoreboard
  for (int i=0; i<ducks.size(); i++) {
    Duck duck =ducks.get(i); 
    if (duck.x>width-350&&duck.y<100) {
      tint(255, 90);
    }
  }
  for (int i=0; i<planes.size(); i++) {
    Plane p=planes.get(i); 
    if (p.x>width-350&&p.x<width&&p.y<100) {
      tint(255, 90);
    }
  }

  if (bossSpawned) {
    if (boss.pos[2].x>width-350&&boss.pos[2].x<width&&boss.pos[2].y<100) {
      tint(255, 90);
    }
  }
}


void chooseBonus() {//randomly selects the amount of ammunition
  int R= (int)random(1, 15); 
  reload(R); 
  points.add(new Score(235, height-84, R, 1));
}

void bulletRemove() {//erases bullets that hit targets
  for (int i=0; i<ducks.size(); i++) {
    Duck duck=ducks.get(i); 
    for (int j=bullets.size()-1; j>=0; j--) {
      Bullet b=bullets.get(j);
      if (ducks.size()>0) {
        if (b.inside(duck)) {
          bullets.remove(j);
        }
      }
    }
  }
}
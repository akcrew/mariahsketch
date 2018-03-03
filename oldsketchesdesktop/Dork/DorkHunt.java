import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DorkHunt extends PApplet {

 //<>//


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
float wActivation=1.0f;
boolean eActivation=false;


ArrayList<Duck> ducks= new ArrayList<Duck>();
ArrayList<Bullet> bullets=new ArrayList<Bullet>();
ArrayList<Score> points=new ArrayList<Score>();
ArrayList<Plane> planes=new ArrayList<Plane>();
Boss boss;

int level=1;
static int startAmmo;
int score=0;
float up=0.01f;
static float grav=.1f;
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


public void setup() { 
  

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

public void draw() { 
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

  angle+=.1f; 
  txtSize-=2;
}


public void mousePressed() {
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
          wActivation=0.5f;
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

public void mouseReleased() {
  clicked=false;
}

public void keyPressed() {
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
          wActivation=0.5f;
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

public void drawGameState0() {

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


public void drawGameState1() {//actual game
  pushStyle();
  rectMode(CORNER);
  background(0xff54C0FF);

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
    text(PApplet.parseInt(frameRate), 0, 20);

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
    fill(0xffFFD800);
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
    fill(0xffFFD800); 
    textAlign(BOTTOM, BOTTOM); 
    text("Score:", width-270, 70); 
    textAlign(LEFT); 
    if (score>999999||score<-99999) {
      textSize(25);
    }
    text(score, width-150, 65); 
    noTint(); 

    if (shotIndex<0) {//if no ammo 
      fill(0xff502626, map(sin(angle), -1, 1, 0, 255)); 
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
      bullet.d+=.65f; 

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
    if (wActivation==0.5f&&flags[7]) {
      W();
    }
    if (abilities[2]) {
      E();
    }
  }//end gameStart
  popStyle();
} //end gameState1



public void drawGameState2() {

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


  Button w=new Button(true, 20+s.length()*23.5f, 25, 36, 36, 4, 4, 0xff000000, 0xff484848);
  w.show();

  if (w.click(mouseX, mouseY, false)) {
    textSize(20);
    text("Change name", s.length()*23.5f-20, 95);
  }
  if (w.click(mouseX, mouseY, true)) {
    gameState=0;
    nameDone=false;
  }
  stroke(50);
  noFill();
  strokeWeight(4);

  image(wrench, s.length()*23.5f+20, 25 );
  rect(20+s.length()*23.5f, 25, 36, 36, 4);

  Button vol=new Button(false, width-70, 25, 35, 35, 2, 4, 0xff000000, 0xff484848);
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
  textSize(100+PApplet.parseInt(10*sin(angle))); 

  fill(0xffFFD800); 
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
  fill(0xffFFD800); 
  if (!flags[1]) {
    textFont(ammoFont);
    textSize(35);
    fill(0xffFFFF00);
    text("Highscores-Easy Mode", 1100, 300);
    text("------------", 1100, 330);
  } else {
    textFont(ammoFont);
    textSize(35);
    fill(0xffFFFF00);
    text("Highscores-Hard Mode", 1100, 300);
    text("------------", 1100, 330);
  }

  drawHighScores(20, 1100, 350);


  textFont(scoreFont);
  fill(0xffFF8705); 
  strokeWeight(4); 
  stroke(200); 

  rect(width/2-150, height/2+150, 300, 75, 5); 
  rect(width/2-150, height/2+250, 300, 75, 5); 
  fill(255); 

  if (!gameStart) { 
    textSize(75); 
    Button play=new Button(true, width/2-150, height/2-50, 300, 150, 10, 4, 0xffFF8705, 0xffC8C8C8, "Play", 0xffFFFFFF);
    play.show();
    if (play.click(mouseX, mouseY, true)) {
      gameStart=true;
      gameState=1;
    }
  } else {
    Button newGame=new Button(true, width/2-275, height/2-50, 250, 150, 5, 4, 0xffFF8705, 0xffC8C8C8, "New Game", 0xffFFFFFF);
    Button Continue=new Button(true, width/2+25, height/2-50, 250, 150, 5, 4, 0xffFF8705, 0xffC8C8C8, "Continue", 0xffFFFFFF);
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

  Button gameInfo=new Button(true, width/2-150, height/2+150, 300, 75, 5, 4, 0xffFF8705, 0xffC8C8C8, "Game Info", 0xffFFFFFF);
  gameInfo.show();
  if (gameInfo.click(mouseX, mouseY, true)) {
    gameState=3;
    ducks.add(new Duck(550, 420, 2, 1));
    planes.add(new Plane(490, 490));
  }

  Button controls=new Button(true, width/2-150, height/2+250, 300, 75, 5, 4, 0xffFF8705, 0xffC8C8C8, "Settings", 0xffFFFFFF);
  controls.show();
  if (controls.click(mouseX, mouseY, true)) {
    gameState=6;
  }
  Button quit=new Button(true, 50, height-125, 150, 75, 0, 4, 0xff969696, 0xffC8C8C8, "Quit", 0xff320000);
  quit.show();
  if (quit.click(mouseX, mouseY, true)&&!clicked) {
    saveFlags();
    exit();
  }
  popStyle();
}



public void drawGameState3() {
  pushStyle();
  rectMode(CORNER);
  background(84, 192, 255);

  textFont(scoreFont);
  textAlign(BOTTOM, BOTTOM);
  textSize(35);
  fill(84, 192, 255); 
  rect(0, 0, width, height); 

  fill(0xffFFD800); 
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
  fill(0xff712323); 
  textAlign(CENTER); 
  text("-If you run out of bullets you lose.", width/2, 330);

  ducks.get(ducks.size()-1).show();


  planes.get(planes.size()-1).show();

  textSize(35); 
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, 0xff969696, 0xffC8C8C8, "Back to menu", 0xff320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2; 
    ducks.remove(ducks.size()-1);
  }
  popStyle();
}



public void drawGameState4() {
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

  Button menu=new Button(true, 50, height-150, 250, 100, 0, 10, 0xffC8C8C8, 0xff646464, "Menu", 0xff320000);
  Button retry=new Button(true, width-300, height-150, 250, 100, 0, 10, 0xffC8C8C8, 0xff646464, "Retry", 0xff320000);
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



public void drawGameState5() {
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

  fill(0xffFFD800);
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
  fill(0xffFFD800); 
  textAlign(BOTTOM, BOTTOM); 
  text("Score:", width-270, 70); 
  textAlign(LEFT); 
  if (score>999999) {
    textSize(25);
  }
  text(score, width-150, 65); //end scoreboard

  if (shotIndex<0) {//if no ammo 
    fill(0xff502626, map(sin(angle), -1, 1, 0, 255)); 
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
  Button vol=new Button(false, width-70, 25, 35, 35, 2, 4, 0xff000000, 0xff484848);
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
  Button paused=new Button(true, width/2-200, height/2-200, 400, 300, 10, 4, 0xffFF8705, 0xffC8C8C8, "Game paused", 0xffFFFFFF);

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
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, 0xff969696, 0xffC8C8C8, "Back to menu", 0xff320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2;
    time2=0;
  }
  popStyle();
}



public void drawGameState6() {
  background(0xff54C0FF);
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
    Button diff=new Button(false, 351, 171, 39, 39, 0, 0, 0xffC80000, 0xff000000);
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
    Button diff=new Button(false, 311, 171, 39, 39, 0, 0, 0xff09C600, 0xff000000);
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



  Button cursorRect=new Button(false, 300, 275, 40, 40, 4, 3, 0xff54C0FF, 0xff1E1E1E);
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
  Button reset=new Button(true, 400, height-190, 150, 80, 4, 4, 0xff969696, 0xffC8C8C8, "Reset data", 0xff320000); 
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
  Button menu=new Button(true, width-250, height-150, 200, 100, 0, 4, 0xff969696, 0xffC8C8C8, "Back to menu", 0xff320000);
  menu.show();
  if (menu.click(mouseX, mouseY, true)) {
    gameState=2;
    time2=0;
  }


  popStyle();
}


public void dSpawn() {//spawns the dorks
  if (killCount==0&&!flags[6]) {
    ducks.add(new Duck(random(width), height-250, random(.5f, 1), 1) );
  } else {
    ducks.add(new Duck(random(width), height-250, random(.5f, 1), dorkLives()) );
  }

  Duck duck= ducks.get(ducks.size()-1); 
  if (wActivation==0.5f) {
    duck.speed.y=random(-11, -13);
  } else {
    duck.speed.y=random(-10, -13);
  }
  duck.chooseDir();
}



public void pSpawn() {//spawns the UFOs
  if (random(1)>.5f) {//planes towards the right
    planes.add(new Plane(-50, random(50, 250))); 
    Plane plane=planes.get(planes.size()-1); 
    plane.rightDir=true; 
    plane.speed.x=(10+level*.13f)*wActivation; 
    plane.speed.y=(random(0, 2.5f))*wActivation;
  } else {//planes towards the left
    planes.add(new Plane(width+50, random(75, 225))); 
    Plane plane=planes.get(planes.size()-1); 
    plane.rightDir=false; 
    plane.speed.x=-10-level*.13f; 
    plane.speed.y=random(0, 2.5f);
  }
}

public int dorkLives() {
  float r=random(1);

  if (r<.8f) {
    return 1;
  } else if (r>=.8f&&r<.95f) {
    return 2;
  } else {
    return 3;
  }
}

public void killDork(Duck d) {
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
      if (random(1)>0.3f+log(level)*0.25f||killsSinceAmmo>level/2&&d.initLives!=3) {
        chooseBonus();
        killsSinceAmmo=0;
      } else if (d.initLives==3) {
        killsSinceAmmo=0;
        int r=10+PApplet.parseInt(random(5));
        reload(r);
        points.add(new Score(235, height-84, r, 1));
      } else {
        killsSinceAmmo++;
      }
    } else {//hard mode
      if (random(1)>.4f+log(level)*.24f||killsSinceAmmo>(25+log(level)*2)&&d.initLives!=3) {
        chooseBonus();
        killsSinceAmmo=0;
      } else if (d.initLives==3) {
        killsSinceAmmo=0;
        int r=10+PApplet.parseInt(random(5));
        reload(r);
        points.add(new Score(235, height-84, r, 1));
      } else {
        killsSinceAmmo++;
      }
    }
  }
}

public void killPlane(Plane p) {
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


public void levelType() {//spawn algorithm 

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
      if (frameCount%ceil(100/(.1f*level+1))==0) {
        dSpawn();
      }
      if (frameCount%(400+level*30)==0) {
        pSpawn();
      }
    } else {
      if (frameCount%ceil(100/(.25f*level+1))==0) {
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



public void levelChoose() {//level selection
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

public void misses() {//remove the missed dorks and UFOs
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

public void levelCheck() {//check level up requirements

  if (levelType==1) {
    if (killCount>=floor(3+sqrt(level)*1.5f)) {
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

public void checkGameLose() {//lose condition when out of ammo
  if (shotIndex<1) {
    gameState=4; 
    highScoreLeaderBoard();
    if (!flags[0]) {
      loss.play(0);
    }
  }
}

public void resetGame() {//resets all dorks, planes, and bullets and refills the ammo, sets temporal flags back to initial state
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

public void reload(int num) {//self explanatory
  if (gameState==1) {
    if (!flags[0]) {

      reloadSound.play(0);
    }
  }
  for (int i=0; i<num; i++) {
    shotIndex++;
  }
}

public void checkMusic() {
  theme.pause();
  loss.pause();
  shot.pause();
  splatter.pause();
  reloadSound.pause();
  levelUp.pause();
  noAmmo.pause();
  UFOCrash.pause();
}


public void cutscenes() {

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
      wActivation=0.5f;
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

public void scoreBoardAnim() {//fades the scoreboard
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


public void chooseBonus() {//randomly selects the amount of ammunition
  int R= (int)random(1, 15); 
  reload(R); 
  points.add(new Score(235, height-84, R, 1));
}

public void bulletRemove() {//erases bullets that hit targets
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
public void abilitiesAnim() {

  pushStyle();
  noStroke();
  fill(0, 180);
  for (int i=0; i<4; i++) {
    if (flags[i+2]) {

      QWER[i].resize(115, 90);
      image(QWER[i], 670+i*145, 615);
      if (shotIndex<15+i*5) {
        tint(50);
        image(QWER[i], 670+i*145, 615);
      }

      if (abilities[i]) {
        float phase=radians(360/(cooldowns[i]*60));
        remains[i]+=phase;
        arc(675+i*145+115/2, 657, 115, 115, -HALF_PI+remains[i], 3*HALF_PI, PIE);
        if (remains[i]>TWO_PI) {
          abilities[i]=false;
          remains[i]=0;
        }
      }
    }
  }
  popStyle();

  pushStyle();

  for (int i=0; i<4; i++) { 
    noFill();
    strokeWeight(35);
    stroke(0xff007F0E);
    rect(675+i*145, 600, 115, 115);
    stroke(50, 0, 0);
    strokeWeight(4);
    rect(690+i*145, 615, 85, 85, 4);
    if (flags[i+2]) {
      textFont(scoreFont);
      textAlign(CENTER);
      textSize(18);
      fill(0);
      text(15+i*5, 675+80+i*145, 635);
    }
  } 
  textSize(25);
  textAlign(CENTER);
  textFont(ammoFont);
  fill(0xffFFD800);
  if (flags[2]) {
    text("Q", 705, 695);
  }
  if (flags[3]) {
    text("W", 850, 695);
  }
  if (flags[4]) {
    text("E", 995, 695);
  }
  if (flags[5]) {
    text("R", 1140, 695);
  }
  popStyle();
}

public void Q() {
  if (mouseY<height-250) {
    bullets.add(new Bullet(mouseX, mouseY, 0));
  }
  for (int i=0; i<20; i++) {
    float step=random(200);
    float x=mouseX+random(-step, step);
    float y=mouseY+random(-step, step);
    if (y>0&&y<height-250) {
      bullets.add(new Bullet(x, y, 0)); 
      if (levelType==3) {
        if (i==0) {
          if (boss.health1>0&&boss.items[0].click(mouseX, mouseY, false)) {
            boss.leftHit=true;
            boss.leftTime=millis();
            clicked=true;
            boss.health1-=10;
          }
          if (boss.health2>0&&boss.items[1].click(mouseX, mouseY, false)) {
            boss.rightHit=true;
            boss.rightTime=millis();
            clicked=true;
            boss.health2-=10;
          }
          if (boss.health1<1&&boss.items[3].click(mouseX, mouseY, false)) {
            boss.health2-=10;
            boss.bodyHit=true;
            boss.bodyTime=millis();
            clicked=true;
          } else if (boss.health2<1&&boss.items[3].click(mouseX, mouseY, false)) {
            boss.health1-=10;
            boss.bodyHit=true;
            boss.bodyTime=millis();
          } else {
            if (boss.items[3].click(mouseX, mouseY, false)) {
              if (random(1)<.5f) {
                boss.health1-=5;
                boss.bodyHit=true;
                boss.bodyTime=millis();
              } else {
                boss.health2-=5;
                boss.bodyHit=true;
                boss.bodyTime=millis();
              }
            }
          }
          if (boss.health1<1&&boss.health2<1&&boss.health3>0&&boss.items[2].click(mouseX, mouseY, false)) {
            boss.headHit=true;
            boss.headTime=millis();
            clicked=true;
            boss.health3-=10;
          }
        }
        if (boss.health1>0&&boss.items[0].click(mouseX, mouseY, false)) {
          boss.leftHit=true;
          boss.leftTime=millis();
          clicked=true;
          boss.health1-=10;
        }
        if (boss.health2>0&&boss.items[1].click(mouseX, mouseY, false)) {
          boss.rightHit=true;
          boss.rightTime=millis();
          clicked=true;
          boss.health2-=10;
        }
        if (boss.health1<1&&boss.items[3].click(mouseX, mouseY, false)) {
          boss.health2-=10;
          boss.bodyHit=true;
          boss.bodyTime=millis();
          clicked=true;
        } else if (boss.health2<1&&boss.items[3].click(x, y, false)) {
          boss.health1-=10;
          boss.bodyHit=true;
          boss.bodyTime=millis();
        } else {
          if (boss.items[3].click(x, y, false)) {
            if (random(1)<.5f) {
              boss.health1-=5;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            } else {
              boss.health2-=5;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            }
          }
        }
        if (boss.health1<1&&boss.health2<1&&boss.health3>0&&boss.items[2].click(x, y, false)) {
          boss.headHit=true;
          boss.headTime=millis();
          clicked=true;
          boss.health3-=10;
        }
      } else {
        for (int k=ducks.size()-1; k>=0; k--) {
          Duck duck=ducks.get(k);
          if (duck.click(false, x, y)&&duck.alive) {
            killDork(duck);
          }
        }
        for (int a=planes.size()-1; a>=0; a--) {
          Plane p=planes.get(a);
          if (x>p.x&&x<(p.x+p.l)&&y>p.y&&y<(p.y+p.h)&&p.alive) {
            killPlane(p);
          }
        }
      }
    }
  }
}


public void W() {
  if (millis()-wTime>10000) {
    wActivation=1;
  } else {
    strokeWeight(1);
    stroke(0);
    fill(255, 255, 0);
    textSize(25);
    textAlign(CENTER);
    text("W effect", 820+115/2, 560);
    noFill();
    rect(820, 580, 115, 15);
    noStroke();
    fill(0, 200, 50);
    rect(821, 581, map(millis()-wTime, 0, 10000, 115, 0), 14);
  }
}

public void E() {
  if (millis()-eTime<6500) {
    if (!flags[0]&!eSound.isPlaying()) {
      eSound.loop();
    }
    strokeWeight(1);
    stroke(0);
    fill(255, 255, 0);
    textSize(25);
    textAlign(CENTER);
    text("E effect", 965+115/2, 560);
    noFill();
    rect(965, 580, 115, 15);
    noStroke();
    fill(0, 200, 50);
    rect(965, 581, map(millis()-eTime, 0, 6500, 115, 0), 14);
    if (frameCount%5==0) {
      if (mouseY<height-250) {
        bullets.add(new Bullet(mouseX, mouseY, 0));

        if (levelType!=3) {
          for (int k=ducks.size()-1; k>=0; k--) {
            Duck duck=ducks.get(k);
            if (duck.click(false, mouseX, mouseY)&&duck.alive) {
              killDork(duck);
            }
          }
          for (int i=planes.size()-1; i>=0; i--) {
            Plane p=planes.get(i);
            if (mouseX>p.x&&mouseX<(p.x+p.l)&&mouseY>p.y&&mouseY<(p.y+p.h)) {
              killPlane(p);
            }
          }
        } else {
          if (levelType==3) {

            if (boss.health1>0&&boss.items[0].click(mouseX, mouseY, false)) {
              boss.health1-=10;
              boss.leftHit=true;
              boss.leftTime=millis();
            }
            if (boss.health2>0&&boss.items[1].click(mouseX, mouseY, false)) {
              boss.health2-=10;
              boss.rightHit=true;
              boss.rightTime=millis();
            }
            if (boss.health1<1&&boss.items[3].click(mouseX, mouseY, false)) {
              boss.health2-=10;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            } else if (boss.health2<1&&boss.items[3].click(mouseX, mouseY, false)) {
              boss.health1-=10;
              boss.bodyHit=true;
              boss.bodyTime=millis();
            } else {
              if (boss.items[3].click(mouseX, mouseY, false)) {
                if (random(1)<.5f) {
                  boss.health1-=5;
                  boss.bodyHit=true;
                  boss.bodyTime=millis();
                } else {
                  boss.health2-=5;
                  boss.bodyHit=true;
                  boss.bodyTime=millis();
                }
              }
            }
            if (boss.health1<1&&boss.health2<1&&boss.health3>0&&boss.items[2].click(mouseX, mouseY, false)) {
              boss.health3-=10;
              boss.headHit=true;
              boss.headTime=millis();
            }
          }
        }
      }
    }
  } else {
    eActivation=false;
    if (eSound.isPlaying()) {
      eSound.pause();

      eSound.rewind();
    }
  }
}

public void R() {
  if (levelType!=3) {
    for (int i=ducks.size()-1; i>=0; i--) {
      Duck duck=ducks.get(i);
      points.add(new Score(duck.x, duck.y, 200, 0));
      ducks.remove(i);
      killCount++;
      score+=200;

      if (random(1)>0.5f+log(level)*0.1f) {
        chooseBonus();
      }
    }
    for (int i=planes.size()-1; i>=0; i--) {
      Plane p=planes.get(i);
      points.add(new Score(p.x, p.y, 1000, 0));
      planes.remove(i);
      if (!flags[0]) {
        UFOCrash.play(0);
      }
      score+=1000;
      killCount++;
      int reloadAmount;
      if (level%10==0) {
        reloadAmount=5;
        reload(reloadAmount);
      } else {
        reloadAmount=20;
        reload(reloadAmount);
      }
      points.add(new Score(235, height-84, reloadAmount, 1));
    }
  } else {

    if (bossSpawned) {
      if (boss.health1>0||boss.health2>0) {
        boss.health1-=100;
        boss.leftHit=true;
        boss.leftTime=millis();
        boss.rightHit=true;
        boss.rightTime=millis();
        boss.health2-=100;
        boss.bodyHit=true;
        boss.bodyTime=millis();
      } else {
        boss.health3-=80;
        boss.headHit=true;
        boss.headTime=millis();
      }
    }
  }
}
public void saveScores() {
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

public void resetScoresEasy() {
  String aux[]={"", "...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0"};
  saveStrings("data/info/highscoresEasy.txt", aux);
}

public void resetScoresHard() {
  String aux[]={"", "...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0-...-0"};
  saveStrings("data/info/highscoresHard.txt", aux);
}

public void loadFlags() {
  String[] aux=loadStrings("data/info/flags.txt");

  flags=new boolean[aux.length-1];
  flags=PApplet.parseBoolean(aux);
  cursorType=PApplet.parseInt(aux[aux.length-1]);
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

public void resetFlags() {
  String[] aux={"false", "false", "false", "false", "false", "false", "false", "false", "0"};
  saveStrings("data/info/flags.txt", aux);
}


public void saveFlags() {
  String[] aux=new String[9];
  aux=str(flags);
  aux[aux.length-1]=str(cursorType);
  saveStrings("data/info/flags.txt", aux);
}

public void loadHighScores() {
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

          scoreNum[floor(i/2)]=PApplet.parseInt(aux[i]);
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

          scoreNum[floor(i/2)]=PApplet.parseInt(aux[i]);
        }
      }
    }
  }
}

public void drawHighScores(int scl, float X, float Y) {
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
public void loadStuff() {


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

public void highScoreLeaderBoard() {
  if (score>0) {
    checkScore(score, scoreNum, scoreList); 
    saveScores();
  }
}

public void checkScore(int num, int[] list, String[] nameList) {
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
class Boss {
  PVector[] pos=new PVector[4];
  PVector[] acc=new PVector[4];
  PVector[] vel=new PVector[4];
  int bossType=1;
  float health1, health2, health3;
  float invulTime=200;
  int leftPieceNum=15;
  int rightPieceNum=15;
  int leftTime, rightTime, headTime, bodyTime;
  boolean leftD, rightD;
  boolean leftHit=false;
  boolean rightHit=false;
  boolean headHit=false;
  boolean bodyHit=false;


  Button[] items=new Button[4];

  Boss(PVector a, PVector b, PVector H) {
    leftD=false;
    rightD=false;
    pos[0]=a;
    pos[1]=b;
    pos[2]=H;
    pos[3]=new PVector(width/2-150, 150);
    for (int i=0; i < 4; i++) {
      acc[i]=new PVector(0, 0);
      vel[i]=new PVector(0, 0);
    }

    items[0]=new Button(false, pos[0].x, pos[0].y, 90, 150, 0, 0, 0xff000000, 0xffFFFFFF);//left
    items[1]=new Button(false, pos[1].x, pos[1].y, 90, 150, 0, 0, 0xff000000, 0xffFFFFFF);//right
    items[2]=new Button(false, pos[2].x, pos[2].y, 150, 100, 0, 0, 0xff000000, 0xffFFFFFF);//head
    items[3]=new Button(false, width/2-150, 250, 300, 600, 0, 0, 0xff000000, 0xffFFFFFF);//body
    health1=100+1.5f*level;
    health2=100+1.5f*level;
    health3=150+2*level;
  }

  public void show() {
    if (leftPieceNum>0||rightPieceNum>0) {
      if (!bodyHit) {
        image(bossIm[4], pos[3].x, pos[3].y+5*sin(angle));
      } else {
        pushStyle();
        tint(220, 0, 0);
        image(bossIm[4], pos[3].x, pos[3].y+5*sin(angle));
        popStyle();
      }
    }
    if (health3>0) {

      if (headHit) {
        pushStyle() ;
        tint(255, 0, 0);
        image(bossIm[0], items[2].x, items[2].y);
        popStyle();
      } else {
        image(bossIm[0], items[2].x, items[2].y);
      }
    }
    if (health1>0||leftPieceNum>0) {
      PVector auxS=new PVector(width/2-85, 300);
      PVector auxE=new PVector(items[0].x+50, items[0].y+50);
      PVector leftArm[]=arms(auxS, auxE, leftPieceNum);
      pushMatrix();
      for (int i=0; i<leftArm.length-1; i++) {
        pushMatrix();
        translate(leftArm[i].x, leftArm[i].y);
        rotate(map(pos[0].y, 30, height-400, 2*PI/3, PI/3));
        image(bossIm[3], 0, 0);
        popMatrix();
      }
      popMatrix();
      if (health1>0) {
        if (leftHit) {
          pushStyle();
          tint(255, 0, 0);
          image(bossIm[1], items[0].x, items[0].y);
          popStyle();
        } else {
          image(bossIm[1], items[0].x, items[0].y);
        }
      }
    }
    if (health2>0||rightPieceNum>0) {
      PVector auxS=new PVector(width/2+75, 330);
      PVector auxE=new PVector(items[1].x+20, items[1].y+75);
      PVector rightArm[]=arms(auxS, auxE, rightPieceNum);
      for (int i=0; i<rightArm.length; i++) {

        pushMatrix();
        translate(rightArm[i].x, rightArm[i].y);
        rotate(map(pos[1].y, 150, height-400, -radians(100), -PI/3));
        image(bossIm[3], 0, 0);
        popMatrix();
      }
      if (health2>0) {
        if (rightHit) {
          pushStyle();
          tint(255, 0, 0);
          image(bossIm[2], items[1].x, items[1].y);
          popStyle();
        } else {
          image(bossIm[2], items[1].x, items[1].y);
        }
      }
    }
  }

  public void update() {

    if (leftHit&&millis()-leftTime>invulTime) {
      leftHit=false;
    }
    if (rightHit&&millis()-rightTime>invulTime) {
      rightHit=false;
    }
    if (headHit&&millis()-headTime>invulTime) {
      headHit=false;
    }
    if (bodyHit&&millis()-bodyTime>invulTime) {
      bodyHit=false;
    }
    if (health1<1&&!leftD) {
      leftD=true;
      score+=1500*level;
      points.add(new Score(pos[0].x, pos[0].y, 1500*level, 0));
    }
    if (health2<1&&!rightD) {
      rightD=true;
      score+=1500*level;
      points.add(new Score(pos[1].x, pos[1].y, 1500*level, 0));
    }
    if (health3<1) {
      if (!flags[0]) {
        splatter.play(0);
      }
      bossSpawned=false;
    }
    if (health1>0) {
      partUpdater(0);
    }
    if (health2>0) {
      partUpdater(1);
    }
    if (leftPieceNum>0&&health1<1) {
      vel[0].y+=grav;
      items[0].y+=vel[0].y;
      if (frameCount%10==0) {
        leftPieceNum--;

        if (!flags[0]) {
          pieceBoom.play(0);
        }
      }
    }
    if (rightPieceNum>0&&health2<1) {
      vel[1].y+=grav;
      items[1].y+=vel[1].y;
      if (frameCount%10==0) {
        rightPieceNum--;
        items[1].y+=grav*2;
        if (!flags[0]) {
          pieceBoom.play(0);
        }
      }
    }
    partUpdater(2);
  }

  public void hit() {
    if (health1>0||health2>0) {
      if (items[0].click(mouseX, mouseY, true)&&!clicked&&!leftHit) {//damage left arm
        leftHit=true;
        leftTime=millis();
        clicked=true;
        health1-=10;
      }
      if (items[1].click(mouseX, mouseY, true)&&!clicked&&!rightHit) {//damage right arm
        rightHit=true;
        rightTime=millis();
        clicked=true;
        health2-=10;
      }
      if (items[3].click(mouseX, mouseY, true)&&!clicked&&!bodyHit) {//damage arms when hitting body
        bodyHit=true;
        bodyTime=millis();
        clicked=true;
        if (health1<1) {
          health2-=10;
        } else if (health2<1) {
          health1-=10;
        } else {
          if (random(1)<.5f) {
            health1-=5;
          } else {
            health2-=5;
          }
        }
      }
    } else if (leftPieceNum<1&&rightPieceNum<1) {//damage head
      if (items[2].click(mouseX, mouseY, true)&&!clicked&&!headHit) {
        headHit=true;
        headTime=millis();
        clicked=true;
        health3-=10;
      }
    }
  }


  public PVector[] arms(PVector s, PVector e, int num) {
    PVector dir=new PVector(e.x-s.x, e.y-s.y);
    pushMatrix();
    rotate(-dir.heading());
    PVector[] pos=new PVector[num];
    for (int i=0; i<num; i++) {
      PVector aux= PVector.fromAngle(dir.heading());
      aux.setMag(dir.mag()/15*i);
      pos[i]=aux;
      pos[i].x=s.x+aux.x;
      pos[i].y+=s.y+5*sin(angle+i*.5f);
    }
    popMatrix();

    return pos;
  }


  public void partUpdater(int selector) {
    if (bossType==1) {
      if (selector!=2) {
        if (frameCount%45==0) {
          acc[selector].add(PVector.random2D());
          acc[selector].setMag(10);
        } else {
          acc[selector].add(PVector.random2D());
        }
        vel[selector].add(acc[selector]);
        vel[selector].mult(.9f);
        pos[selector].add(vel[selector]);
        if (pos[selector].x>width/2-200+selector*(width/2+200-150)) {
          pos[selector].x=width/2-200+selector*(width/2+200-150);
        } else if (pos[selector].x<80+selector*(-80+width/2+50)) {
          pos[selector].x=80+selector*(width/2+50-80);
        }
        if (pos[selector].y<30+selector*100) {
          pos[selector].y=30+selector*100;
        } else if (pos[selector].y>height-400) {
          pos[selector].y=height-400;
        }
        items[selector].x=pos[selector].x;
        items[selector].y=pos[selector].y;
        acc[selector].mult(0);
      } else {
        if (health1<1&&health2<1) {
          if (frameCount%45==0) {
            acc[selector].add(PVector.random2D());
            acc[selector].setMag(12);
          } else {
            acc[selector].add(PVector.random2D());
          }
        } else {
          acc[selector].add(PVector.random2D());
          acc[selector].limit(.75f);
          PVector move=PVector.random2D();
          move.mult(.4f);
          acc[selector].add(move);
          vel[selector].add(acc[selector]);
          vel[selector].mult(.8f);
          pos[selector].add(vel[selector]);
          acc[selector].mult(0);
        }
        vel[selector].add(acc[selector]);
        vel[selector].mult(0.95f);
        pos[selector].add(vel[selector]);
        if (health1>0||health2>0) {
          if (pos[selector].x>width/2-50) {
            pos[selector].x=width/2-50;
          } else if (pos[selector].x<width/2-100) {
            pos[selector].x=width/2-100;
          }
          if (pos[selector].y<100) {
            pos[selector].y=100;
          } else if (pos[selector].y>150) {
            pos[selector].y=150;
          }
        } else {
          if (pos[selector].y<0) {
            pos[selector].y=0;
          } else if (pos[selector].y>height-350) {
            pos[selector].y=height-350;
          }
          if (pos[selector].x<0) {
            pos[selector].x=0;
          } else if (pos[selector].x>width-300) {
            pos[selector].x=width-300;
          }
        }

        items[selector].x=pos[selector].x;
        items[selector].y=pos[selector].y;
        acc[selector].mult(0);
      }
    }
  }
}
class Bullet {
  float x; 
  float y;
  float d;

  Bullet(float X, float Y, float D) {
    x=X;
    y=Y;
    d=D;
  }

  public void show() {
    fill(0xffFF8D00);
    noStroke();
    quad(x, y-15+d, x-15+d, y, x, y+15-d, x+15-d, y);
  }

  public boolean inside(Duck d) {
    if (x>d.x&&x<d.x+100/d.d&&y>d.y&&y<d.y+100/d.d) {
      return true;
    } else {
      return false;
    }
  }
}
class Button {//Asks whether changes color, for an X, Y, xlength, y length, corner radius, strokeWeight, inside fill, stroke color, text inside, text color 
  float x;
  float y;
  float Xl;
  float Yl;
  float corners;
  int rimWidth;
  int in;
  int out;
  int inside;
  int border;
  String content;
  int letter;
  boolean change;

  Button(boolean Ch, float x_, float y_, float Xlength, float Ylength, float c, int stroke, int inside, int rim) {
    x=x_;
    y=y_;
    Xl=Xlength;
    Yl=Ylength;
    corners=c;
    rimWidth=stroke;
    change=Ch;

    in=inside;
    out=rim;
    content="";
    letter=0;
  }
  Button(boolean Ch, float x_, float y_, float Xlength, float Ylength, float c, int stroke, int inside, int rim, String words, int l) {
    x=x_;
    y=y_;
    Xl=Xlength;
    Yl=Ylength;
    corners=c;
    change=Ch;
    rimWidth=stroke;
    in=inside;
    out=rim;
    content=words;
    letter=l;
  }


  public void show() {
    pushStyle();
    stroke(out);
    if (rimWidth==0) {
      noStroke();
    } else {
      strokeWeight(rimWidth);
    }

    fill(in);
    if (change) {
      if (mouseX>x&&mouseX<x+Xl&&mouseY>y&&mouseY<y+Yl) {
        in=PApplet.parseInt(map(in, 0xff000000, 0xffFFFFFF, 0xffC4C4C4, 0xffFFFFFF));
        fill(in);
      }
    }
    rect(x, y, Xl, Yl, corners);
    if (content.length()>0) {
      fill(letter);
      textAlign(CENTER, CENTER);
      text(content, x, y, Xl, Yl);
    }

    popStyle();
  }

  public boolean click(float X_, float Y_, boolean c) {
    if (!c) {
      if (X_>x&&X_<(x+Xl)) {
        if (Y_>y&&Y_<(y+Yl)) {
          return true;
        }
      } 
      return false;
    } else {
      if (X_>x&&X_<(x+Xl)) {
        if (Y_>y&&Y_<(y+Yl)) {
          if (mousePressed) {

            return true;
          }
        }
      } 
      return false;
    }
  }
}
class Duck {
  float x;
  float y;
  float d;
  float w=100;
  int lives, initLives;
  PVector speed= new PVector(0, 0);
  boolean alive=true;
  boolean flapA=true;
  boolean turned=false;
  int fCount=0;
  int alpha=255;
  float initD;
  float dir;
  float rotation;

  Duck(float X, float Y, float D, int L) {
    initD=D;
    x=X;
    y=Y;
    d=D;
    lives=L;
    initLives=L;
  }


  public void show() {
    pushStyle();
    if (y+(w*1/d)<height-250) {
      fCount++;
      if (!alive) {
        pushMatrix();
       
        translate(x+w/d/2, y+w/d/2);
        tint(255, alpha);
        alpha-=PApplet.parseInt(255/35);
         rotate(rotation);
        

        image(dorkExp, -w/d/2,-w/d/2, w/d, w/d);
        popMatrix();
      } else {
        if (dir>0) {//left
          if (flapA) {
            if (lives==1) {
              image(flapAleft, x, y, w/d, w/d);
            } else {
              tint(map(lives, 2, 3, 200, 150), map(lives, 2, 3, 80, 108), 0);
              image(flapAleft, x, y, w/d, w/d);
            }
          } else if (!flapA) {
            if (lives==1) {

              image(flapBleft, x, y, w/d, w/d);
            } else {
              tint(map(lives, 2, 3, 200, 150), map(lives, 2, 3, 80, 108), 0);
              image(flapBleft, x, y, w/d, w/d);
            }
          }
        } else {//right
          if (flapA) {
            if (lives==1) {
              image(flapAright, x, y, w/d, w/d);
            } else {
              tint(map(lives, 2, 3, 200, 150), map(lives, 2, 3, 80, 108), 0);
              image(flapAright, x, y, w/d, w/d);
            }
          } else if (!flapA) {
            if (lives==1) {
              image(flapBright, x, y, w/d, w/d);
            } else {
              tint(map(lives, 2, 3, 200, 150), map(lives, 2, 3, 80, 108), 0);
              image(flapBright, x, y, w/d, w/d);
            }
          }
        }
      }
    }
    if (y+(w/d)<0) {
      stroke(255);
      strokeWeight(2);
      fill(0xffFF8D00);
      triangle(x+w/(d*2), 10, x+w/(d*2)-15, 35, x+w/(d*2)+15, 35);
    }
    popStyle();
  }

  public void move() {
    if (fCount%20==0) {
      flapA=!flapA;
    }
    if (alive) {
      x+=speed.x*wActivation;
      y+=speed.y*wActivation;
      speed.y+=grav*wActivation;
      d+=.01f*wActivation;
    }
    else{
      speed.y+=grav*2;
      y+=speed.y;
    }
  }


  public void edges() {
    if (x<0||x+w/d>width) {
      speed.x*=-1;
    }
  }


  public void chooseDir() {
    if (x>width/2) {
      dir=random(-4, -2);
      speed.x=dir;
    } else {
      dir=random(2, 4);
      speed.x=dir;
    }
  }

  public boolean click(boolean c, float X_, float Y_) {
    if (c) {
      return(X_>=x&&X_<x+(w/d)&&Y_>=y&&Y_<y+(w/d))&&mousePressed&&!clicked;
    } else {
      return(X_>=x&&X_<x+(w/d)&&Y_>=y&&Y_<y+(w/d));
    }
  }
}
class Plane {
  float x;
  float y;
  PVector speed=new PVector(0, 0);
  int l=75;
  int h=40;
  boolean rightDir;
  boolean alive=true;
  int alpha=255;

  Plane(float X, float Y) {
    x=X;
    y=Y;
  }

  public void show() {
    pushStyle();
    if (alive) {
      image(plane, x, y+3*sin(angle*2), map(y, 50, height-250, 75, 50), map(y, 50, height-250, 40, 26.6f));
    } else {
      tint(255, alpha);
      image(planeBoom, x, y, map(y, 50, height-250, 100, 50), map(y, 50, height-250, 60, 30));
    }
    popStyle();
  }

  public void move() {
    if (alive) {
      x+=speed.x*wActivation;
      y+=speed.y*wActivation;
    }else{
      speed.y+=grav*2;
      y+=speed.y;
      x+=speed.x*wActivation/2;
    }
  }
}
class Score {//Needs x pos, y pos, score ammount and type
  float x;
  float y;
  float up=0;
  int points;
  boolean alive=false;
  int type;

  Score(float X, float Y, int Scr, int S) {
    x=X;
    y=Y;
    points=Scr;
    type=S;
  }

  public void show() {
    if (type==0) {//score points
      if (points>0) {
        fill(0, 255, 0);
        textSize(PApplet.parseInt(map(points, 0, 2000000, 25, 35)));
        textAlign(TOP, TOP);

        text("+"+ points, x+15, y+20-up);
      } else {
        fill(50, 0, 0);
        textSize(30);
        textAlign(LEFT);
        text( points, x, y+up);
      }
    } else if (type==1) {//ammo reloaded
      if (points>0) {
        fill(0, 255, 0);
        textSize(30);
        textAlign(TOP, TOP);

        text("+"+ points, x+15, y+20-up);
        if (points>9) {
          image(bullet, x+75, y+3-up);
        } else {
          image(bullet, x+60, y+3-up);
        }
      } else {
        fill(50, 0, 0);
        textSize(30);
        textAlign(TOP, TOP);

        text(points, x+15, y+20+up);
        if (points<9) {
          image(bullet, x+75, y+3+up);
        } else {
          image(bullet, x+60, y+3+up);
        }
      }
    } else if (type==2) {//enxt level banner
      textSize(35+up*3);
      fill(120, 0, 0);
      textAlign(CENTER);
      text("Next level", x, y);
    }
    up+=.1f;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DorkHunt" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

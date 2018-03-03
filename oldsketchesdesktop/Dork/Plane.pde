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

  void show() {
    pushStyle();
    if (alive) {
      image(plane, x, y+3*sin(angle*2), map(y, 50, height-250, 75, 50), map(y, 50, height-250, 40, 26.6));
    } else {
      tint(255, alpha);
      image(planeBoom, x, y, map(y, 50, height-250, 100, 50), map(y, 50, height-250, 60, 30));
    }
    popStyle();
  }

  void move() {
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
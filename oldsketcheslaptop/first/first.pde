//Mariah Vicary 9/6/2017
//Everyone has to start somewhere...
//Program draws an ellipse whenever and wherever the mouse is pressed
//Also chooses a random color when 'space' is pressed
//Also clears the screen when 'c' is pressed


boolean onPressed = false;
boolean newscreen = true;
color elcolor = color (204, 102, 0);

void setup() {
  size(900, 800); 
  background(#0198af);
}

void draw() {
  textSize(20);
  text("Clear Screen = C" + "\n" +
    "Random Color = SPACE" + "\n"
    , width*0.05, height*0.05);

  if (newscreen) {
    textSize(60);
    text("Hello" + "\n" +
      "World" + "\n"
      , width*0.2, height*0.3);
  }

  if (onPressed) {
    ellipse(mouseX, mouseY, 50, 50);
    fill(elcolor);
  }
}// end draw


void keyPressed() {
  newscreen = false;

  if (key == ' ') {
    elcolor = color(random(255), random(255), random(255));
  }

  if (key == 'c') {
    background(16);
  }
}   

void mousePressed() {
  onPressed = true;
}

void mouseReleased() {
  onPressed = false;
}
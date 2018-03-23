ArrayList<Dude> dudes;

int dudeWidth = 20;


void setup() {
size(1300,650);
//noStroke();

//fill(0);
dudes = new ArrayList<Dude>();

dudes.add(new Dude(width/2, 0, dudeWidth));
}

void draw (){
background(255);
//fill(0);
for (int i = dudes.size()-1; i>= 0; i--){
  Dude dude = dudes.get(i);
  dude.move();
  dude.display();
  if (dude.finished()){
   dudes.remove(i); 
  }
}
}

void mousePressed() {
  dudes.add(new Dude(mouseX, mouseY, dudeWidth));
}
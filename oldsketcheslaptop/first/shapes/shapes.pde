//global variables

int fr = 5;

void setup(){
size(640, 360);
}
  
    void draw(){
      //frameRate(fr);
 
 if (mousePressed == true)
  {
    quad(mouseX, mouseY, mouseX, mouseY*1.3, mouseX*2.5, mouseY*2.3, mouseX*4.2, mouseY);
  }
    }
    
    
    
    
void setup()
{
  size(1500, 900);
  colorMode(HSB, 360, 100, 100, 256);
  background(0);
  noFill();
  noLoop();
}

void draw()
{
  translate(width / 2, height / 2);
  float r = 0;
  float phi = 0;
  float col = random(255);
  while(r < width)
  {
    stroke(col + noise(r, phi) * 80, 100, 100, 75);
    beginShape();
    for(int i = 0; i < 100; i++)
    {
      r += .03f;
      phi = (phi + .1);
      float n = 2 * noise(pow(r/width, 3), phi) - 1;
      curveVertex(cos(phi) * r * n, sin(phi) * r * n);
    }
    endShape();
    phi %= 2 * PI; 
  }
}
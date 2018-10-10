
import oscP5.*;
import netP5.*;

PImage img;      // The source image
int cellsize = 2; // Dimensions of each cell in the grid
int columns, rows;

void setup() {
  size(720, 480);

  OscP5 oscP5 = new OscP5(this, 12001);

  img = loadImage("mequencer_logo.png");
  columns = img.width / cellsize;  // Calculate # of columns
  rows = img.height / cellsize;  // Calculate # of rows
  img.loadPixels();
  loadPixels();
  
}

boolean kickIn = false;
boolean snareIn = false;
boolean clapIn = false;
boolean hatClosedIn = false;
boolean reverbOn = false;

int alphaKick = 0;
int alphaSnare = 0;
int alphaClap = 0;
int alphaHatClosed = 0;

float ampKick = 0;
float ampSnare = 0;
float ampClap = 0;
float ampHatClosed = 0;
float[] reverbValues = new float[2];

void draw() {

  float revValMap = map(reverbValues[0], 0, 1, 0, 255-62);
  if (revValMap > 255-62)
    revValMap = 255-62;
  background(62 + ((int) revValMap));
  imageMode(CENTER);
  image(img, width/2, height/5, img.width*2/3, img.height*2/3);

  float randpos = 4;
  float displacementX = random(-randpos, + randpos);
  float displacementY = random(-randpos, + randpos);


  if (kickIn == true) {
    ampKick = 1;
    alphaKick = 200;
    kickIn = false;
  }

  if (ampKick < 0)
    ampKick = 0;

  if (snareIn == true) {
    ampSnare = 1;
    alphaSnare = 200;
    snareIn = false;
  }

  if (ampSnare < 0)
    ampSnare = 0;

  if (clapIn == true) {
    ampClap = 1;
    alphaClap = 200;
    clapIn = false;
  }

  if (ampClap < 0)
    ampClap = 0;

  if (hatClosedIn == true) {
    ampHatClosed = 0.3;
    alphaHatClosed = 200;
    hatClosedIn = false;
  }

  if (ampHatClosed < 0)
    ampHatClosed = 0;

  //KICK
  noStroke();
  rectMode(CENTER);
  fill(191, 61, 49);
  rect(width/5 + displacementX*ampKick, height/2 - displacementY*ampKick, 100, 100, 7);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaKick);
  rect(width/5 + displacementX*ampKick, height/2 - displacementY*ampKick, 100, 100, 7);

  //SNARE
  noStroke();
  rectMode(CENTER);
  fill(191, 98, 49);
  rect(width*2/5 + displacementX*ampSnare, height/2 + displacementY*ampSnare, 100, 100, 7);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaSnare);
  rect(width*2/5 + displacementX*ampSnare, height/2 + displacementY*ampSnare, 100, 100, 7);

  //CLAP
  noStroke();
  rectMode(CENTER);
  fill(191, 146, 49);
  rect(width*3/5 + displacementX*ampClap, height/2 + displacementY*ampClap, 100, 100, 7);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaClap);
  rect(width*3/5 + displacementX*ampClap, height/2 + displacementY*ampClap, 100, 100, 7);

  //HAT CLOSED
  noStroke();
  rectMode(CENTER);
  fill(183, 191, 49);
  rect(width*4/5 + displacementX*ampHatClosed, height/2 + displacementY*ampHatClosed, 100, 100, 7);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaHatClosed);
  rect(width*4/5 + displacementX*ampHatClosed, height/2 + displacementY*ampHatClosed, 100, 100, 7);

  alphaKick = alphaKick - 40;
  alphaSnare = alphaSnare - 40;
  alphaClap = alphaClap - 40;
  alphaHatClosed = alphaHatClosed - 40;

  ampKick -= 0.1;
  ampSnare -= 0.1;
  ampClap -= 0.1;
  ampHatClosed -= 0.1;
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  if (theOscMessage.addrPattern().equals("/kick")) {
    kickIn = true;
  }
  if (theOscMessage.addrPattern().equals("/snare")) {
    snareIn = true;
  }
  if (theOscMessage.addrPattern().equals("/clap")) {
    clapIn = true;
  }
  if (theOscMessage.addrPattern().equals("/hatclosed")) {
    hatClosedIn = true;
  }
  if (theOscMessage.addrPattern().equals("/reverb_values")) {
    println(theOscMessage.arguments());
    reverbOn = true;
    reverbValues[0] = (float) theOscMessage.arguments()[0];
  }
}

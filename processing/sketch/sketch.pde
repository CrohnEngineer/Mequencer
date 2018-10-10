
import oscP5.*;
import netP5.*;

PFont dodgeFont;

void setup() {
  size(720, 480);

  OscP5 oscP5 = new OscP5(this, 12001);

  dodgeFont= createFont("DODGE", 72);
  textFont(dodgeFont);

}

boolean kickIn = false;
boolean snareIn = false;
boolean clapIn = false;
boolean hatClosedIn = false;
boolean reverbOn = false;
boolean lpOn = false;

int alphaKick = 0;
int alphaSnare = 0;
int alphaClap = 0;
int alphaHatClosed = 0;

float ampKick = 0;
float ampSnare = 0;
float ampClap = 0;
float ampHatClosed = 0;
float[] reverbValues = new float[2];
float cutoffValue = 0;

void draw() {

  background(255);
  
  fill(0);
  textAlign(CENTER);
  text("MEQUENCER", width/2, height/4);

  if (lpOn == true) {
    float cutoffValMap = map(cutoffValue, 0, 1, 0, 255-62);
    if (cutoffValMap > 255-62) {
      cutoffValMap = 255-62;
    } else if (cutoffValMap < 0) {
      cutoffValMap = 0;
    }
    background(62 + ((int) cutoffValMap));
    
    fill(255- (int) cutoffValMap);
    textAlign(CENTER);
    text("MEQUENCER", width/2, height/4);
  }

  imageMode(CENTER);

  float randposX = 4;
  float randposY = 4;

  if (reverbOn == true) {
    randposX = map(reverbValues[1], 0, 2, 4, 40);
    randposY = map(reverbValues[0], 0, 2, 4, 40);
    reverbOn = false;
  }

  float displacementX = random(-randposX, + randposX);
  float displacementY = random(-randposY, + randposY);

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
    reverbValues[1] = (float) theOscMessage.arguments()[1];
  }
  if (theOscMessage.addrPattern().equals("/cutoff_value")) {
    lpOn = true;
    cutoffValue = (float) theOscMessage.arguments()[0];
  }
}

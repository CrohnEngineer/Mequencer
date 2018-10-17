
import oscP5.*;
import netP5.*;
import controlP5.*;
import java.util.*;

ControlP5 cp5;
controlP5.ScrollableList p1samples,p2samples,p3samples,p4samples,p1seq,p2seq,p3seq,p4seq;

PGraphics pg;

PFont dodgeFont,dodgeFontSmall;

//step button object
class StepButton {
  boolean isActive;
  boolean isPlaying;
  int xpos, ypos, wsize, hsize;
  int roundtl, roundtr, roundbr, roundbl;

  StepButton(int xpos, int ypos, int wsize, int hsize, boolean isActive, boolean isPlaying, int rtl, int rtr, int rbr, int rbl) {
    this.xpos = xpos;
    this.ypos = ypos;
    this.wsize = wsize;
    this.hsize = hsize;
    this.isActive = isActive;
    this.isPlaying = isPlaying;
    roundtl = rtl;
    roundtr = rtr;
    roundbr = rbr;
    roundbl = rbl;

  }

  void display() {
    if (isPlaying == false) {
      if (isActive == false) {
        noFill();
        strokeWeight(1);
        stroke(0);
      } else {
        fill(100);
        strokeWeight(1);
        stroke(255);
      }
    } else {
      fill(220);
      strokeWeight(1);
      stroke(191, 61, 49);
    }
    rect(xpos, ypos, wsize, hsize, roundtl, roundtr, roundbr, roundbl);
  }

  void blink() {
    fill(255);
    rect(xpos, ypos, wsize, hsize, roundtl, roundtr, roundbr, roundbl);
  }
}

class Sequence {
  boolean isPlaying;
  StepButton[] steps;
  int playingStep;
  
  Sequence(boolean isPlaying, StepButton[] steps, int playingStep){
    this.isPlaying = isPlaying;
    this.steps = steps;
    this.playingStep = playingStep;
  }
  
  void nextStep(){
    steps[playingStep].isPlaying = false; 
    if(playingStep <= 14)
      playingStep += 1;
    else
      playingStep = 0;
    steps[playingStep].isPlaying = true; 
  }
  
  void displayStep(){
    for(int i = 0; i<steps.length; i++){
      steps[i].display();
    }
  }
  
  void play(){
    playingStep = 0;
    isPlaying = true;
  }
  
  void stop(){
    isPlaying = false;  
  }
}

//class customScrollableList implements ControllerView<ScrollableList> {
    
//  PGraphics Applet;
  
//  public void display (PGraphics Applet, ScrollableList theList) {
//    Applet.pushMatrix();
//    Applet.fill(ControlP5.BLACK);
//    Applet.rect(0, 0, theList.getWidth(), theList.getHeight(), rectRound);
//    int x = theList.getWidth()/2 - theList.getCaptionLabel().getWidth()/2;
//    int y = theList.getHeight()/2 - theList.getCaptionLabel().getHeight()/2;
//    translate(x,y);
//    theList.getCaptionLabel().draw(Applet);
//    Applet.popMatrix();
//  }
  
//  public void setColor(color c){
//    Applet.fill(c);
//  }
//}

//class customLabel implements ControllerView<Label> {
    
//  PGraphics Applet;
  
//  public void display (PGraphics Applet, Label theLabel) {
//    Applet.pushMatrix();
//    Applet.fill(ControlP5.BLACK);
//    Applet.rect(0, 0, theLabel.getWidth(), theLabel.getHeight(), rectRound);
//    int x = theLabel.getWidth()/2;
//    int y = theLabel.getHeight()/2 - theLabel.getTextHeight()/2;
//    translate(x,y);
//    theLabel.draw(Applet);
//    Applet.popMatrix();
//  }
  
//  public void setColor(color c){
//    Applet.fill(c);
//  }
//}

//start position of first elements of the sequencers
int[] firstStepPos1 = new int[2];
int[] firstStepPos2 = new int[2];
int[] firstStepPos3 = new int[2];
int[] firstStepPos4 = new int[2];



int rows = 4;
int columns = 4;
int numberOfSteps = rows*columns;
int stepDimension = 22;
int stepSpacing = 4;

int rectDimension = 100;
int rectRound = 7;

Sequence sequence1;
Sequence sequence2;
Sequence sequence3;
Sequence sequence4;


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


void setup() {
  size(1080, 720);
  
  dodgeFont= createFont("DODGE", 72);
  dodgeFontSmall = createFont("DODGE",12);
  textFont(dodgeFont);
  
  
  firstStepPos1[0] = width/5 - 50;
  firstStepPos1[1] = height/2 + 75;
  
  firstStepPos2[0] = width*2/5 - 50;
  firstStepPos2[1] = height/2 + 75;
  
  firstStepPos3[0] = width*3/5 - 50;
  firstStepPos3[1] = height/2 + 75;
  
  firstStepPos4[0] = width*4/5 - 50;
  firstStepPos4[1] = height/2 + 75;
  
  cp5 = new ControlP5(this);
  List samples = Arrays.asList("Kick", "Clap", "Hat closed", "Snare", "e", "f", "g", "h");
  List sequences = Arrays.asList("Niggata", "Dritta", "Levare", "Clave 3/2", "Clave 2/3", "Tumbao", "Nenno", "Lello");
  
  /* Sample list for pattern A */
  p1samples = cp5.addScrollableList("Sample A")
     .setPosition(width/5 -50 , height/2 + 200)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(samples)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Sample A")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(191, 61, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sequences list for pattern B */
  p1seq = cp5.addScrollableList("Seqs A")
     .setPosition(width/5 -50 , height/2 + 300)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(sequences)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Seqs A")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(191, 61, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sample list for pattern B */
  p1samples = cp5.addScrollableList("Sample B")
     .setPosition(width*2/5 -50 , height/2 + 200)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(samples)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Sample B")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(191, 98, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sequences list for pattern B */
  p1seq = cp5.addScrollableList("Seqs B")
     .setPosition(width*2/5 -50 , height/2 + 300)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(sequences)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Seqs B")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(191, 98, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sample list for pattern C */
  p1samples = cp5.addScrollableList("Sample C")
     .setPosition(width*3/5 -50 , height/2 + 200)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(samples)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Sample C")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(191, 146, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sequences list for pattern C */
  p1seq = cp5.addScrollableList("Seqs C")
     .setPosition(width*3/5 -50 , height/2 + 300)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(sequences)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Seqs C")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(191, 146, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sample list for pattern D */
  p1samples = cp5.addScrollableList("Sample D")
     .setPosition(width*4/5 -50 , height/2 + 200)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(samples)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Sample D")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(183, 191, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);
  
  /* Sequences list for pattern D */
  p1seq = cp5.addScrollableList("Seqs D")
     .setPosition(width*4/5 -50 , height/2 + 300)
     .setSize(rectDimension, rectDimension)
     .setBarHeight(50)
     .setItemHeight(25)
     .addItems(sequences)
     //.setView(new customScrollableList())
     // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     ;
  cp5.getController("Seqs D")
  .getCaptionLabel()
  .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(183, 191, 49));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  OscP5 oscP5 = new OscP5(this, 12001);
  
  sequence1 = new Sequence(true, new StepButton[numberOfSteps], 0);  
  sequence2 = new Sequence(true, new StepButton[numberOfSteps], 0);  
  sequence3 = new Sequence(true, new StepButton[numberOfSteps], 0);  
  sequence4 = new Sequence(true, new StepButton[numberOfSteps], 0); 
  
  int index = 0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < columns; x++) {
      int roundtl = 0;
      int roundtr = 0;
      int roundbr = 0;
      int roundbl = 0;
      if(x == 0 && y == 0)
        roundtl = rectRound;
      else if(x == 0 && y == 3)
        roundbl = rectRound;
      else if(x == 3 && y == 0)
        roundtr = rectRound;
      else if(x == 3 && y == 3)
        roundbr = rectRound;
      sequence1.steps[index] = new StepButton(firstStepPos1[0] + x*(stepDimension + stepSpacing), 
                                      firstStepPos1[1] + y*(stepDimension + stepSpacing), 
                                      stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl);
      sequence2.steps[index] = new StepButton(firstStepPos2[0] + x*(stepDimension + stepSpacing), 
                                      firstStepPos2[1] + y*(stepDimension + stepSpacing), 
                                      stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl);  
      sequence3.steps[index] = new StepButton(firstStepPos3[0] + x*(stepDimension + stepSpacing), 
                                      firstStepPos3[1] + y*(stepDimension + stepSpacing), 
                                      stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl);  
      sequence4.steps[index] = new StepButton(firstStepPos4[0] + x*(stepDimension + stepSpacing), 
                                      firstStepPos4[1] + y*(stepDimension + stepSpacing), 
                                      stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl);   
     index++;
     }
  }
}



void draw() {

  background(255);
  //pg.beginDraw();
  //pg.rect(width/5 -50, height/2 - 200, rectDimension, rectDimension, rectRound);
  //pg.endDraw();
  //controlP5.ControllerView c1 = p1samples.getView();
  //c1.display(pg,p1samples);
  //p1samples.setView(c1);

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
  rect(width/5 + displacementX*ampKick, height/2 - displacementY*ampKick, rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaKick);
  rect(width/5 + displacementX*ampKick, height/2 - displacementY*ampKick, rectDimension, rectDimension, rectRound);

  //SNARE
  noStroke();
  rectMode(CENTER);
  fill(191, 98, 49);
  rect(width*2/5 + displacementX*ampSnare, height/2 + displacementY*ampSnare, rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaSnare);
  rect(width*2/5 + displacementX*ampSnare, height/2 + displacementY*ampSnare, rectDimension, rectDimension, rectRound);

  //CLAP
  noStroke();
  rectMode(CENTER);
  fill(191, 146, 49);
  rect(width*3/5 + displacementX*ampClap, height/2 + displacementY*ampClap, rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaClap);
  rect(width*3/5 + displacementX*ampClap, height/2 + displacementY*ampClap, rectDimension, rectDimension, rectRound);

  //HAT CLOSED
  noStroke();
  rectMode(CENTER);
  fill(183, 191, 49);
  rect(width*4/5 + displacementX*ampHatClosed, height/2 + displacementY*ampHatClosed, rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaHatClosed);
  rect(width*4/5 + displacementX*ampHatClosed, height/2 + displacementY*ampHatClosed, rectDimension, rectDimension, rectRound);
  
  rectMode(CORNER);
  sequence1.displayStep();
  sequence2.displayStep();
  sequence3.displayStep();
  sequence4.displayStep();
  
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
  if (theOscMessage.addrPattern().equals("/tempo")) {
    if (sequence1.isPlaying == true)
      sequence1.nextStep(); 
    if (sequence2.isPlaying == true)
      sequence2.nextStep(); 
    if (sequence3.isPlaying == true)
      sequence3.nextStep(); 
    if (sequence4.isPlaying == true)
      sequence4.nextStep();       
  }
  if (theOscMessage.addrPattern().equals("/seq_kick")) {
    if (theOscMessage.arguments()[0].equals("play"))
      sequence1.play();
    else if (theOscMessage.arguments()[0].equals("stop"))
      sequence1.stop();
  }  
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
    reverbOn = true;
    reverbValues[0] = (float) theOscMessage.arguments()[0];
    reverbValues[1] = (float) theOscMessage.arguments()[1];
  }
  if (theOscMessage.addrPattern().equals("/cutoff_value")) {
    lpOn = true;
    cutoffValue = (float) theOscMessage.arguments()[0];
  }
}

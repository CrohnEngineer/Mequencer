import oscP5.*;
import netP5.*;
import controlP5.*;
import java.util.*;

ControlP5 cp5;
controlP5.ScrollableList p1samples, p2samples, p3samples, p4samples, p1seq, p2seq, p3seq, p4seq;

OscP5 oscP5;
NetAddress supercollider;
int colStep = 0;

PGraphics pg;

PFont dodgeFont, dodgeFontSmall;

//step button object
class StepButton {
  boolean isActive;
  boolean isPlaying;
  int xpos, ypos, wsize, hsize;
  int roundtl, roundtr, roundbr, roundbl;
  int[] activeColor = new int[3];

  StepButton(int xpos, int ypos, int wsize, int hsize, boolean isActive, boolean isPlaying, int rtl, int rtr, int rbr, int rbl, int[] activeColor) {
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
    this.activeColor[0] = activeColor[0];
    this.activeColor[1] = activeColor[1];
    this.activeColor[2] = activeColor[2];

}

  void display() {
    if (isPlaying == false) {
      if (isActive == false) {
        noFill();
        strokeWeight(1);
        stroke(colStep);
      } else {
        fill(activeColor[0], activeColor[1], activeColor[2]);
        strokeWeight(1);
        stroke(activeColor[0], activeColor[1], activeColor[2]);
      }
    } else {
      fill(220);
      strokeWeight(1);
      stroke(activeColor[0], activeColor[1], activeColor[2]);
    }
    rect(xpos, ypos, wsize, hsize, roundtl, roundtr, roundbr, roundbl);
  }
}

class Sequence {
  boolean isPlaying;
  StepButton[] steps;
  int playingStep;

  Sequence(boolean isPlaying, StepButton[] steps, int playingStep) {
    this.isPlaying = isPlaying;
    this.steps = steps;
    this.playingStep = playingStep;
  }

  void nextStep() {
    steps[playingStep].isPlaying = false; 
    if (playingStep <= 14)
      playingStep += 1;
    else
      playingStep = 0;
    steps[playingStep].isPlaying = true;
  }

  void displaySteps() {
    for (int i = 0; i<steps.length; i++) {
      steps[i].display();
    }
  }

  void setSteps(int[] st) {
    reset();
    for (int i = 0; i < st.length; i++) {
      if (st[i] == 1)
        this.steps[i].isActive = true;
    }
  }

  void play() {
    playingStep = 0;
    isPlaying = true;
  }

  void stop() {
    isPlaying = false;
    steps[playingStep].isPlaying = false;
  }
  
  void reset(){
    for (int i = 0; i<steps.length; i++) {
      steps[i].isActive = false;;
    }
  }
}

int[] c1 = {191, 61, 49};
int[] c2 = {191, 98, 49};
int[] c3 = {191, 146, 49};
int[] c4 = {183, 191, 49};


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
int stepDimension = 27;
int stepSpacing = 4;

int rectDimension = 120;
int rectRound = 7;

Sequence sequence1;
Sequence sequence2;
Sequence sequence3;
Sequence sequence4;

int[][] patterns = {
  {1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0}, 
  {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0}, 
  {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}, 
  {0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0}, 
  {0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1}, 
  {1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0}, 
  {1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0}, 
  {1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1}, 
  {1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0}, 
  {0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0}
};


boolean[] sampleIn = {false, false, false, false};
boolean reverbOn = false;
boolean lpOn = false;

int[] alphaSample = {255, 255, 255, 255} ;

float[] ampSample = {0, 0, 0, 0};
float[] reverbValues = new float[2];
float cutoffValue = 0;

List<String> samples;
List<String> sequences;


void setup() {
  size(1080, 720);

  dodgeFont= createFont("DODGE", 72);
  dodgeFontSmall = createFont("DODGE", 12);
  textFont(dodgeFont);


  firstStepPos1[0] = width/5 - 60;
  firstStepPos1[1] = height/3 + 75;

  firstStepPos2[0] = width*2/5 - 60;
  firstStepPos2[1] = height/3 + 75;

  firstStepPos3[0] = width*3/5 - 60;
  firstStepPos3[1] = height/3 + 75;

  firstStepPos4[0] = width*4/5 - 60;
  firstStepPos4[1] = height/3 + 75;

  cp5 = new ControlP5(this);
  samples = Arrays.asList("Bell", "Clap", "Cymbal", "Hat Closed", "Hat Open", "High Clave", "High Tom", "Kick",
                               "Low Clave", "Low Tom", "Mid Clave", "Mid Tom", "Pluck", "Rimshot", "Shaker", "Snare");
  sequences = Arrays.asList("•___•___•___•___", 
                                 "•_•_•_•_•_•_•_•_", 
                                 "••••••••••••••••", 
                                 "•___•___•____••_",
                                 "•_____•_____•___", 
                                 "•_________•_____", 
                                 "__•___•___•___•_",
                                 "__••__••__••__••", 
                                 "•_•__•__•_•__•__", 
                                 "•__•__•__•______", 
                                 "____•_______•___", 
                                 "________•_______", 
                                 "•_______•_•_____", 
                                 "••••____•_••_•_•", 
                                 "•_•____••_•_____", 
                                 "__•__•___••_•___");


  /* Sample list for pattern A */
  p1samples = cp5.addScrollableList("sampleA")
    .setPosition(width/5 - 60, height/3 + 210)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(samples)
    .setLabel("Sample A")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("sampleA")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(c1[0], c1[1], c1[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sequences list for pattern B */
  p1seq = cp5.addScrollableList("seq1")
    .setPosition(width/5 - 60, height/3 + 325)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(sequences)
    .setLabel("Sequence A")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("seq1")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(c1[0], c1[1], c1[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sample list for pattern B */
  p1samples = cp5.addScrollableList("sampleB")
    .setPosition(width*2/5 - 60, height/3 + 210)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(samples)
    .setLabel("Sample B")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("sampleB")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(c2[0], c2[1], c2[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sequences list for pattern B */
  p1seq = cp5.addScrollableList("seq2")
    .setPosition(width*2/5 - 60, height/3 + 325)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(sequences)
    .setLabel("Sequence B")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("seq2")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(c2[0], c2[1], c2[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sample list for pattern C */
  p1samples = cp5.addScrollableList("sampleC")
    .setPosition(width*3/5 - 60, height/3 + 210)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(samples)
    .setLabel("Sample C")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("sampleC")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(c3[0], c3[1], c3[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sequences list for pattern C */
  p1seq = cp5.addScrollableList("seq3")
    .setPosition(width*3/5 - 60, height/3 + 325)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(sequences)
    .setLabel("Sequence C")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("seq3")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(c3[0], c3[1], c3[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sample list for pattern D */
  p1samples = cp5.addScrollableList("sampleD")
    .setPosition(width*4/5 - 60, height/3 + 210)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(samples)
    .setLabel("Sample D")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("sampleD")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1samples.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1samples.setColorBackground(color(c4[0], c4[1], c4[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  /* Sequences list for pattern D */
  p1seq = cp5.addScrollableList("seq4")
    .setPosition(width*4/5 - 60, height/3 + 325)
    .setSize(rectDimension, rectDimension)
    .setBarHeight(50)
    .setItemHeight(25)
    .addItems(sequences)
    .setLabel("Sequence D")
    //.setView(new customScrollableList())
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
  cp5.getController("seq4")
    .getCaptionLabel()
    .setFont(dodgeFontSmall);
  p1seq.getValueLabel().setFont(dodgeFontSmall);
  //p1samples.getView().setColor(color(191,61,49));
  p1seq.setColorBackground(color(c4[0], c4[1], c4[2]));
  //pg = createGraphics(rectDimension,rectDimension);
  //controlP5.ControllerView c1 = p1samples.getView();
  //p1samples.setView(c1);

  oscP5 = new OscP5(this, 12001);
  supercollider = new NetAddress("127.0.0.1", 12002); 

  sequence1 = new Sequence(false, new StepButton[numberOfSteps], 0);  
  sequence2 = new Sequence(false, new StepButton[numberOfSteps], 0);  
  sequence3 = new Sequence(false, new StepButton[numberOfSteps], 0);  
  sequence4 = new Sequence(false, new StepButton[numberOfSteps], 0); 

  int index = 0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < columns; x++) {
      int roundtl = 0;
      int roundtr = 0;
      int roundbr = 0;
      int roundbl = 0;
      if (x == 0 && y == 0)
        roundtl = rectRound;
      else if (x == 0 && y == 3)
        roundbl = rectRound;
      else if (x == 3 && y == 0)
        roundtr = rectRound;
      else if (x == 3 && y == 3)
        roundbr = rectRound;
      sequence1.steps[index] = new StepButton(firstStepPos1[0] + x*(stepDimension + stepSpacing), 
        firstStepPos1[1] + y*(stepDimension + stepSpacing), 
        stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl, c1);
      sequence2.steps[index] = new StepButton(firstStepPos2[0] + x*(stepDimension + stepSpacing), 
        firstStepPos2[1] + y*(stepDimension + stepSpacing), 
        stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl, c2);  
      sequence3.steps[index] = new StepButton(firstStepPos3[0] + x*(stepDimension + stepSpacing), 
        firstStepPos3[1] + y*(stepDimension + stepSpacing), 
        stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl, c3);  
      sequence4.steps[index] = new StepButton(firstStepPos4[0] + x*(stepDimension + stepSpacing), 
        firstStepPos4[1] + y*(stepDimension + stepSpacing), 
        stepDimension, stepDimension, false, false, roundtl, roundtr, roundbr, roundbl, c4);   
      index++;
    }
  }
  
  sequence1.setSteps(patterns[0]);
  sequence2.setSteps(patterns[6]);
  sequence3.setSteps(patterns[10]);
  sequence4.setSteps(patterns[3]);

}



void draw() {

  background(255);

  fill(0);
  textAlign(CENTER);
  text("MEQUENCER", width/2, height/6);

  if (lpOn == true) {
    float cutoffValMap = map(cutoffValue, 0, 1, 0, 255-62);
    if (cutoffValMap > 255-62) {
      cutoffValMap = 255-62;
    } else if (cutoffValMap < 0) {
      cutoffValMap = 0;
    }
    background(62 + ((int) cutoffValMap));
    colStep = 255 - (int) cutoffValMap;
    

    fill(255 - (int) cutoffValMap);
    textAlign(CENTER);
    text("MEQUENCER", width/2, height/6);
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

  if (sampleIn[0] == true) {
    ampSample[0] = 1;
    alphaSample[0] = 200;
    sampleIn[0] = false;
  }

  if (ampSample[0] < 0)
    ampSample[0] = 0;

  if (sampleIn[1] == true) {
    ampSample[1] = 1;
    alphaSample[1] = 200;
    sampleIn[1] = false;
  }

  if (ampSample[1] < 0)
    ampSample[1] = 0;

  if (sampleIn[2] == true) {
    ampSample[2] = 1;
    alphaSample[2] = 200;
    sampleIn[2] = false;
  }

  if (ampSample[2] < 0)
    ampSample[2] = 0;

  if (sampleIn[3] == true) {
    ampSample[3] = 1;
    alphaSample[3] = 200;
    sampleIn[3] = false;
  }

  if (ampSample[3] < 0)
    ampSample[3] = 0;

  //KICK
  noStroke();
  rectMode(CENTER);
  fill(c1[0], c1[1], c1[2]);
  rect(width/5 + displacementX*ampSample[0], height/3 - displacementY*ampSample[0], rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaSample[0]);
  rect(width/5 + displacementX*ampSample[0], height/3 - displacementY*ampSample[0], rectDimension, rectDimension, rectRound);

  //SNARE
  noStroke();
  rectMode(CENTER);
  fill(c2[0], c2[1], c2[2]);
  rect(width*2/5 + displacementX*ampSample[1], height/3 + displacementY*ampSample[1], rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaSample[1]);
  rect(width*2/5 + displacementX*ampSample[1], height/3 + displacementY*ampSample[1], rectDimension, rectDimension, rectRound);

  //CLAP
  noStroke();
  rectMode(CENTER);
  fill(c3[0], c3[1], c3[2]);
  rect(width*3/5 + displacementX*ampSample[2], height/3 + displacementY*ampSample[2], rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaSample[2]);
  rect(width*3/5 + displacementX*ampSample[2], height/3 + displacementY*ampSample[2], rectDimension, rectDimension, rectRound);

  //HAT CLOSED
  noStroke();
  rectMode(CENTER);
  fill(c4[0], c4[1], c4[2]);
  rect(width*4/5 + displacementX*ampSample[3], height/3 + displacementY*ampSample[3], rectDimension, rectDimension, rectRound);

  noStroke();
  rectMode(CENTER);
  fill(255, alphaSample[3]);
  rect(width*4/5 + displacementX*ampSample[3], height/3 + displacementY*ampSample[3], rectDimension, rectDimension, rectRound);

  rectMode(CORNER);
  sequence1.displaySteps();
  sequence2.displaySteps();
  sequence3.displaySteps();
  sequence4.displaySteps();

  alphaSample[0] -= 40;
  alphaSample[1] -= 40;
  alphaSample[2] -= 40;
  alphaSample[3] -= 40;

  ampSample[0] -= 0.1;
  ampSample[1] -= 0.1;
  ampSample[2] -= 0.1;
  ampSample[3] -= 0.1;
}

void seq1(int n) {
  sequence1.setSteps(patterns[n]);
  println(n);
  println(patterns[n]);
  OscMessage msg = new OscMessage("/pattern");
  msg.add(1);
  msg.add(n);
  oscP5.send(msg, supercollider);
  //cp5.getController((String) p1seq.getItem(n).get("name")).setMousePressed(true);
}

void seq2(int n) {
  sequence2.setSteps(patterns[n]);
  OscMessage msg = new OscMessage("/pattern");
  msg.add(2);
  msg.add(n);
  oscP5.send(msg, supercollider);
}

void seq3(int n) {
  sequence3.setSteps(patterns[n]);
  OscMessage msg = new OscMessage("/pattern");
  msg.add(3);
  msg.add(n);
  oscP5.send(msg, supercollider);
}

void seq4(int n) {
  sequence4.setSteps(patterns[n]);
  OscMessage msg = new OscMessage("/pattern");
  msg.add(4);
  msg.add(n);
  oscP5.send(msg, supercollider);
}

void sampleA(int n) {
  OscMessage msg = new OscMessage("/sample");
  println(n);
  msg.add(1);
  msg.add(n);
  oscP5.send(msg, supercollider);
  //cp5.getController((String) p1samples.getItem(n).get("name")).setMousePressed(true);
}

void sampleB(int n) {
  OscMessage msg = new OscMessage("/sample");
  msg.add(2);
  msg.add(n);
  oscP5.send(msg, supercollider);
}

void sampleC(int n) {
  OscMessage msg = new OscMessage("/sample");
  msg.add(3);
  msg.add(n);
  oscP5.send(msg, supercollider);
}

void sampleD(int n) {
  OscMessage msg = new OscMessage("/sample");
  msg.add(4);
  msg.add(n);
  oscP5.send(msg, supercollider);
}

void oscEvent(OscMessage theOscMessage) {
  switch (theOscMessage.addrPattern()) {
  case "/tempo":
    if (sequence1.isPlaying == true)
      sequence1.nextStep(); 
    if (sequence2.isPlaying == true)
      sequence2.nextStep(); 
    if (sequence3.isPlaying == true)
      sequence3.nextStep(); 
    if (sequence4.isPlaying == true)
      sequence4.nextStep();       
    break;
  case "/seq1":
    if (theOscMessage.arguments()[0].equals("play"))
      sequence1.play();
    else if (theOscMessage.arguments()[0].equals("stop"))
      sequence1.stop();
    break;
  case "/seq2":
    if (theOscMessage.arguments()[0].equals("play"))
      sequence2.play();
    else if (theOscMessage.arguments()[0].equals("stop"))
      sequence2.stop();
    break;   
  case "/seq3":
    if (theOscMessage.arguments()[0].equals("play"))
      sequence3.play();
    else if (theOscMessage.arguments()[0].equals("stop"))
      sequence3.stop();
    break;
  case "/seq4":
    if (theOscMessage.arguments()[0].equals("play"))
      sequence4.play();
    else if (theOscMessage.arguments()[0].equals("stop"))
      sequence4.stop();
    break;    
  case "/sample1":
    sampleIn[0] = true;
    break;
  case "/sample2":
    sampleIn[1] = true;
    break;
  case "/sample3":
    sampleIn[2] = true;
    break;
  case "/sample4":
    sampleIn[3] = true;
    break;
  case "/reverb_values":
    reverbOn = true;
    reverbValues[0] = (float) theOscMessage.arguments()[0];
    reverbValues[1] = (float) theOscMessage.arguments()[1];
    break;
  case "/cutoff_value":
    lpOn = true;
    cutoffValue = (float) theOscMessage.arguments()[0];
    break;
  case "/change_sample":
    switch((int) theOscMessage.arguments()[0]) {
      case 1:
        sampleA((int) theOscMessage.arguments()[1]);
        cp5.getController("sampleA").setLabel(samples.get((int) theOscMessage.arguments()[1]));
        break;
      case 2:
        sampleB((int) theOscMessage.arguments()[1]);
        cp5.getController("sampleB").setLabel(samples.get((int) theOscMessage.arguments()[1]));
        break;
      case 3:
        sampleC((int) theOscMessage.arguments()[1]);
        cp5.getController("sampleC").setLabel(samples.get((int) theOscMessage.arguments()[1]));
        break;
      case 4:
        sampleD((int) theOscMessage.arguments()[1]);
        cp5.getController("sampleD").setLabel(samples.get((int) theOscMessage.arguments()[1]));
        break;
      default:
        break;
    }
  break;
  case "/change_sequence":
      switch((int) theOscMessage.arguments()[0]) {
      case 1:
        seq1((int) theOscMessage.arguments()[1]);
        cp5.getController("seq1").setLabel(sequences.get((int) theOscMessage.arguments()[1]));
        break;
      case 2:
        seq2((int) theOscMessage.arguments()[1]);
        cp5.getController("seq2").setLabel(sequences.get((int) theOscMessage.arguments()[1]));
        break;
      case 3:
        seq3((int) theOscMessage.arguments()[1]);
        cp5.getController("seq3").setLabel(sequences.get((int) theOscMessage.arguments()[1]));
        break;
      case 4:
        seq4((int) theOscMessage.arguments()[1]);
        cp5.getController("seq4").setLabel(sequences.get((int) theOscMessage.arguments()[1]));
        break;
      default:
        break;
      }
  break;
  default:
  break;
  }
}

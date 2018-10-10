/**
 * Color Variables (Homage to Albers). 
 * 
 * This example creates variables for colors that may be referred to 
 * in the program by a name, rather than a number. 
 */

import oscP5.*;
import netP5.*;

float ins = 255;
float mid = 100;
float out = 50;

void setup(){
  size(640, 360);
  noStroke();
  background(51, 0, 0);
  
  OscP5 oscP5 = new OscP5(this, 12001);

}

void draw() {
  
  color inside = color(ins);
  color middle = color(mid);
  color outside = color(out);
  
  pushMatrix();
  translate(80, 80);
  fill(outside);
  rect(0, 0, 200, 200);
  fill(middle);
  rect(40, 60, 120, 120);
  fill(inside);
  rect(60, 90, 80, 80);
  popMatrix();

  pushMatrix();
  translate(360, 80);
  fill(inside);
  rect(0, 0, 200, 200);
  fill(outside);
  rect(40, 60, 120, 120);
  fill(middle);
  rect(60, 90, 80, 80);
  popMatrix();

}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println("");
  ins = random(255);
}

// These statements are equivalent to the statements above.
// Programmers may use the format they prefer.
//color inside = #CC6600;
//color middle = #CC9900;
//color outside = #993300;

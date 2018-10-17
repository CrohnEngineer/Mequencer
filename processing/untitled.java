class StepButton {
	boolean isActive;
	boolean isPlaying;
	float xpos, ypos, wsize, hize;

	StepButton(float xpos, float ypos, float wsize, float hsize, boolean isActive){
		this.xpos = xpos;
		this.ypos = ypos;
		this.wsize = wsize;
		this.hsize = hsize;
		this.isActive = isActive;
	}

	void display() {
	  if (state == 0) {
	    noFill();
	    strokeWeight(4);
	    stroke(255);
	  } else if (state == 1) {
	    fill(100);
	    strokeWeight(4);
	    stroke(255);
	  } else if (state == 2) {
	    fill(200);
	    strokeWeight(4);
	    stroke(255);
	  }
	  rect(xpos, ypos, wsize, hsize);
	}

	void blink() {
    	fill(255);
    	rect(xpos, ypos, wsize, hsize);
  	}
}

StepButton[] steps1;
StepButton[] steps2;
StepButton[] steps3;
StepButton[] steps4;

float xFirstStepPos1 = width/5 - 50;
float yFirstStepPos1 = height/3 + 75;


int rows = 4;
int columns = 4;
int numberOfSteps = rows*columns;
int stepDimension = 22;
int stepSpacing = 4;

void setup() {
	//setup the steps/buttons
  steps = new StepButton[numberOfSteps];
  int index = 0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < columns; x++) {
      steps[index++] = new StepButton((x * stepSize) + stepSpacing*7, (y * stepSize) + stepSpacing*3, stepSize, stepSize, 0);
    }
  }
}

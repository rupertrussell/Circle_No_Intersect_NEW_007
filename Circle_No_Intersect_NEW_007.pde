// A Fork by Rupert Russell of 
// Circle No Intersect NEW
// by Michael Pinn  
// https://www.openprocessing.org/sketch/176094
// 22 September 2018

ArrayList<Circle> circles = new ArrayList<Circle>();

float num = 2500; // size of boundary to fill

int min = 10;
int max = 1000; // maximum size of circles 
int lastSave = 0;

float testX;
float testY;

/* Our object */
Circle c = new Circle(new PVector(0, 0), (float)random(min, max));

void setup() {
  size(7740, 7740);
  //  noStroke();
  stroke(0);
  circles.add(c);
}

void draw() {
  background(0);

  for (int i = 0; i < circles.size(); i++) {
    Circle c = (Circle) circles.get(i);
    c.draw();
  }
  PVector newLoc = new PVector(random(width/2-num, width/2+num), random(height/2-num, height/2+num));
  float newD = (float) random(min, max);


  while (detectAnyCollision (circles, newLoc, newD)) {
    /* If the new circle interectes with any existing circle try a new random circle */

    testX = random(width/2-num, width/2+num);
    testY = random(height/2-num, height/2+num);

    newLoc = new PVector(testX, testY);
   newD = (int) random(min, max);
 //   newD = abs(dist(testX, testY, width/2, height/2) - width* 2);
  }

  c = new Circle(newLoc, newD);
  if (circles.size() < 100000) {  // maximum number of circles to place
    circles.add(c);
  }

  if (frameCount == lastSave + 1500) {
    lastSave = frameCount;
    save("packing_"+frameCount + ".png");
  }
 // println(frameCount);
}

static boolean detectAnyCollision(ArrayList<Circle> circles, PVector newLoc, float newR) {
  for (Circle c : circles) {
    if (c.detectCollision(newLoc, newR)) {
      return true;
    }
  }
  return false;
}


class Circle {
  PVector loc;
  float d;

  Circle(PVector loc, float d) {
    this.loc = loc;
    this.d = d;
  } 

  void draw() {
    float r = dist(loc.x, loc.y, width/2, height/2);  // find the distance from the center of the screen
    float c = abs(cos(radians(r+frameCount/100)));
    float s = abs(sin(radians(r+frameCount/100)));
    fill((c-s)*255, c*255, s*255);
    if (r < num) {  // only draw ellipses if they are not too far from the center of the screen. This makes the circular shape
      stroke(0);
      ellipse(loc.x, loc.y, d, d);
    } else {
      noFill();
      stroke(255, 255, 0);
      ellipse(loc.x, loc.y, d, d);
    }
  }

  boolean detectCollision(PVector newLoc, float newD) {
    /* 
     We must divide d + newD because they are both diameters. We want to find what both radius's values are added on. 
     However without it gives the balls a cool forcefeild type gap.
     */
    return dist(loc.x, loc.y, newLoc.x, newLoc.y) < ((d + newD)*.55);
  }
}

void mouseClicked() {

  save("packing_"+frameCount + ".png");
  println(" saved packing_"+frameCount + ".png");
}

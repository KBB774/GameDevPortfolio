class Laser {
  // Member Variables
  int x, y, w, h, speed;
  PImage laser1;

  // Constructor
  Laser(int x, int y) {
    this.x = x;
    this.y = y;
    y = -100;
    w = 4;
    h = 10;
    laser1 = loadImage("laser.png");
    speed = 10;
  }

  // Member Methods
  void display() {
    imageMode(CENTER);
    image(laser1, x, y);
    laser1.resize(60, 75);
  }

  void move() {
    y = y - speed;
  }

  boolean reachedTop() {
    if (y<0-10) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Rock r) {
    float d = dist(x, y, r.x, r.y);
    if (d<45) {
      return true;
    } else {
      return false;
    }
  }
}

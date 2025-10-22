class PowerUp {
  // Member Variables
  int x, y, w, diam, speed;
  char type;
  PImage rock1;
  color c1;

  // Constructor
  PowerUp() {
    x = int(random(width));
    y = -100;
    diam = 100;
    speed = int(random(1, 5));

    if (random(10)>5) {
      rock1 = loadImage("Ammo.png");
      rock1.resize (diam,diam);
      type = 'a'; //THIS IS AMMO
      c1 = color(255, 0, 0);
    } else {
      rock1 = loadImage("Health.png");
            rock1.resize (diam,diam);
      type = 'h'; //THIS IS HEALTH
    }
    
  }

  // Member Methods
  void display() {
  imageMode(CENTER);
    image(rock1, x, y);
    
  }

  void move() {
    y = y + speed;
  }

  boolean reachedBottom() {
    if (y>height+100) {
      return true;
    } else {
      return false;
    }
  }

  boolean intersect(Spaceship s) {
    float d = dist(x, y, s.x, s.y);
    if (d<50) {
      return true;
    } else {
      return false;
    }
  }
}

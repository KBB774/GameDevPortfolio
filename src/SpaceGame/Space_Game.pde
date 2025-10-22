// Kellen Brim | 17 Sept 2025 | Space Game
Spaceship ship;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<PowerUp> powups = new ArrayList<PowerUp>();


import processing.sound.*;
import ddf.minim.*;
Minim minim;
AudioPlayer bgMusic;
Timer rockTimer, puTimer;
int score, rocksPassed, health;
SoundFile laserSound;
PImage start, lose, h, a;
boolean play;
PFont font;

void setup () {
  size(1920, 1080);
  font = createFont("Times New Roman", 30);
  textFont(font);
  // fullScreen();
  {
  }
  background(20);
  minim = new Minim(this);
   bgMusic = minim.loadFile("fast-glitchy-edm-282231.mp3");
   bgMusic.loop();
  ship = new Spaceship();
  rockTimer = new Timer(800);
  rockTimer.start();
  puTimer = new Timer(5000);
  puTimer.start();
  score = 0;
  rocksPassed = 0;
  health = 100;
  start = loadImage("SpaceStart-1.png");
  lose = loadImage("Untitled-1.png");
  h = loadImage("Health.png");
  a = loadImage("Ammo.png");
  loadImage("laser.png");
  laserSound = new SoundFile(this, "laser-104024.wav");
  play = false;
}

void draw () {
  if (!play) {
    startScreen();
  } else {
    background(20);

    // Distribution of PowerUps
    if (puTimer.isFinished()) {
      powups.add(new PowerUp());
      puTimer.start();
    }

    // Displays and Moves PowerUps
    for (int i = 0; i<powups.size(); i++) {
      PowerUp pu = powups.get(i);
      pu.display();
      pu.move();
      // Check Bottom

      // Check Ship Collision
      if (pu.intersect(ship)) {
        powups.remove(pu);
        // Health
        if (pu.type == 'h') {
          ship.health+=10;
          //Ammo
        } else if (pu.type == 'a') {
          ship.laserCount+=30;
          if (ship.laserCount<5) {
            ship.laserCount = 5;
          }
        }
      }
    }
    // Distributes stars
    stars.add(new Star());
    // Display and Remove Stars
    for (int i = 0; i < stars.size(); i++) {
      Star star = stars.get(i);
      star.move();
      star.display();
      if (star.reachedBottom()) {
        stars.remove(star);
        i--;
      }
      println(stars.size());
    }

    // Distribution of Rocks
    if (rockTimer.isFinished()) {
      rocks.add(new Rock());
      rockTimer.start();
    }

    // Display and moves all the rocks
    for (int i = 0; i < rocks.size(); i++) {
      Rock rock = rocks.get(i);
      rock.move();
      rock.display();

      if (ship.intersect(rock)) {
        rocks.remove(rock);
        score-=rock.diam;
        ship.health-=10;
      }

      if (rock.reachedBottom()) {
        rocksPassed ++;
        rocks.remove(rock);
        i--;
      }
      println("Rocks: " + rocks.size());
    }

    // Display and remove unwanted lasers
    for (int i = 0; i < lasers.size(); i++) {
      Laser laser = lasers.get(i);
      for (int j = 0; j<rocks.size(); j++) {
        Rock r = rocks.get(j);
        if (laser.intersect(r)) {
          lasers.remove(laser);
          r.diam -=10;
          if (r.diam<50) {
            rocks.remove(r);
          }
          score+=r.diam;
        }
      }
      laser.display();
      laser.move();
      if (laser.reachedTop()) {
        lasers.remove(laser);
      }
      println("Lasers: " + lasers.size());
    }
    ship.display();
    ship.move(mouseX, mouseY);
    infoPanel();
    if (ship.health<1) {
      gameOver();
    }
  }
}
void mousePressed() {
  if (ship.fire()) {
    lasers.add(new Laser(ship.x, ship.y));
    ship.laserCount--;
    ship.shotsFired++;
  }
  if (laserSound.isPlaying()) {
    laserSound.play();
  } else {
    laserSound.stop();
    laserSound.play();
  }
}
//Powerup for Double Shot
//void mouseReleased() {
// lasers.add(new Laser(ship.x, ship.y));
//}

void infoPanel() {
  //rectMode(CENTER);
  // fill(127,127);
  // noStroke();
  // rect(width/2,height-25,width,50);
  fill(57, 255, 20);
  textSize(45);
  text("Score: " + score, 30, height-300, width+1);
text("Shots Fired: " + ship.shotsFired, 30, height-400, width+1);
  text("HEALTH: " + ship.health, 30, height-250, width+55);
  text("AMMO: " + ship.laserCount, 30, height-200, width+55);
}

void startScreen() {
  background (start);
  fill(255);
  if (mousePressed) {
    play = true;
  }
}

void gameOver() {
  background(lose);
  fill(255, 0, 0);
  text("Score: " + score, width-1080, height-200);
  noLoop();
}

void stop() {
  bgMusic.close();
  minim.stop();
  super.stop();
}

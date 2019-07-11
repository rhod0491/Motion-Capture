import processing.video.*;
import processing.sound.*;

Movie monkeyMovie;
Bender bender;

PImage background;
PImage collisionFlameImg;
PImage portalImg;

SoundFile explosionSound;
SoundFile warpSound;
SoundFile dingSound;

ArrayList<PImage> enemySprites = new ArrayList<PImage>();
ArrayList<EnemyObject> activeEnemyObjects = new ArrayList<EnemyObject>();

void setup() {
  background = loadImage("resources/images/background.png");
  surface.setSize(background.width, background.height);

  surface.setTitle("Motion Capture");

  imageMode(CENTER);  

  monkeyMovie = new Movie(this, sketchPath("resources/video/monkey.mov"));

  Object leftHand = new Object(loadImage("resources/images/bender/lefthand.png"));
  Object rightHand = new Object(loadImage("resources/images/bender/righthand.png"));
  Object leftFoot = new Object(loadImage("resources/images/bender/leftfoot.png"));
  Object rightFoot = new Object(loadImage("resources/images/bender/rightfoot.png"));
  Object body = new Object(loadImage("resources/images/bender/body.png"));

  ArrayList<SoundFile> audioClips = new ArrayList<SoundFile>();
  audioClips.add(new SoundFile(this, sketchPath("resources/audio/bite_my.mp3")));
  audioClips.add(new SoundFile(this, sketchPath("resources/audio/magnificent.mp3")));
  audioClips.add(new SoundFile(this, sketchPath("resources/audio/oh_your_god.mp3")));

  bender = new Bender(leftHand, rightHand, leftFoot, rightFoot, body, audioClips);

  enemySprites.add(loadImage("resources/images/enemies/planet_express_ship.png"));
  enemySprites.add(loadImage("resources/images/enemies/richard_nixon.png"));
  enemySprites.add(loadImage("resources/images/enemies/ugly_guy.png"));
  enemySprites.add(loadImage("resources/images/enemies/brain.png"));
  enemySprites.add(loadImage("resources/images/enemies/catship.png"));

  collisionFlameImg = loadImage("resources/images/flame.png");
  portalImg = loadImage("resources/images/portal.png");

  explosionSound = new SoundFile(this, sketchPath("resources/audio/explosion.wav"));
  warpSound = new SoundFile(this, sketchPath("resources/audio/warp.mp3"));
  dingSound = new SoundFile(this, sketchPath("resources/audio/ding.mp3"));
  SoundFile backgroundMusic = new SoundFile(this, sketchPath("resources/audio/Futurama_Theme_Song.mp3"));

  monkeyMovie.play();
  backgroundMusic.play();
}

void draw() {

  if (monkeyMovie.time() >= monkeyMovie.duration()) {
    exit();
  }
  
  image(background, (background.width / 2), (background.height / 2));

  PImage binaryMonkeyFrame = binariseMarkers(monkeyMovie);
  bender.updatePositon(binaryMonkeyFrame);

  // randomly generate enemy objects at a variable average rate.
  int randomEnemyCreationDraw = int(random(0, 50));
  if (randomEnemyCreationDraw < enemySprites.size()) { 
    createNewEnemyObject(randomEnemyCreationDraw);
  }

  for (int i = activeEnemyObjects.size() - 1; i >= 0; i--) {
    EnemyObject enemyObject = activeEnemyObjects.get(i);

    if (enemyObject.hasFlownAcross()) {
      activeEnemyObjects.remove(i);
    } else if (bender.isColliding(enemyObject)) {

      // randomly destroy or teleport the object if it collides with bender.
      int pickEnemyInteraction = int(random(0, 2));
      
      if (pickEnemyInteraction == 0) {
        enemyObject.teleport();
      } else {
        dingSound.play();
        enemyObject.explode();

        bender.playAudio();

        activeEnemyObjects.remove(i);
      }
    } else if (enemyObject.isInBackground()) {

      // check for a background collision.
      for (int j = activeEnemyObjects.size() - 1; j >= 0; j--) {

        EnemyObject otherEnemyObject = activeEnemyObjects.get(j);

        if (otherEnemyObject.isInBackground() && enemyObject.isColliding(otherEnemyObject)) {
          enemyObject.explode();
          otherEnemyObject.explode();

          activeEnemyObjects.remove(enemyObject);
          activeEnemyObjects.remove(otherEnemyObject);

          i--;
          break;
        }
      }
    }
  }

  for (EnemyObject object : activeEnemyObjects) { 
    object.render();
  }

  bender.render();
}

void movieEvent(Movie m) {
  m.read();
}

// Possibly generate a random new object
public void createNewEnemyObject(int index) {
  EnemyObject newEnemyObject = new EnemyObject(enemySprites.get(index).copy());

  // put background enemies at front so they are rendered first, rest are rendered ontop
  if (newEnemyObject.inBackground) {
    activeEnemyObjects.add(0, newEnemyObject);
  } else {
    activeEnemyObjects.add(newEnemyObject);
  }
}

// make binary image of only markers, erode to remove noise, dilate to close graps
PImage binariseMarkers(PImage frame) {
  PImage newFrame = new PImage(frame.width, frame.height);

  for (int i = 0; i < frame.width * frame.height; i++) {
    color pixel = frame.pixels[i];
    boolean isMarker = red(pixel) > 180 && green(pixel) < 140 && blue(pixel) < 150;

    if (isMarker) {
      newFrame.pixels[i] = color(255);
    }
  }

  newFrame = erosion(newFrame); 

  for (int i = 0; i < 8; i++) {
    newFrame = dilation(newFrame);
  }

  return newFrame;
}


PImage dilation(PImage frame) {
  PImage dilatedFrame = new PImage(frame.width, frame.height);

  for (int x = 1; x < frame.width - 1; x++) {
    for (int y = 1; y < frame.height - 1; y++) {

      int left = (x - 1) + y * frame.width;
      int right = (x + 1) + y * frame.width;
      int center = x + y * frame.width;
      int top = x + (y - 1) * frame.width;
      int bottom = x + (y + 1) * frame.width;

      if (frame.pixels[left] == color(255) || 
        frame.pixels[right] == color(255) ||
        frame.pixels[center] == color(255) ||
        frame.pixels[top] == color(255) ||
        frame.pixels[bottom] == color(255)) {

        dilatedFrame.pixels[center] = color(255);
      }
    }
  }

  return dilatedFrame;
}

PImage erosion(PImage frame) {
  PImage erodedFrame = new PImage(frame.width, frame.height);

  for (int x = 1; x < frame.width - 1; x++) {
    for (int y = 1; y < frame.height - 1; y++) {

      int left = (x - 1) + y * frame.width;
      int right = (x + 1) + y * frame.width;
      int center = x + y * frame.width;
      int top = x + (y - 1) * frame.width;
      int bottom = x + (y + 1) * frame.width;

      if (frame.pixels[left] == color(255) && 
        frame.pixels[right] == color(255) &&
        frame.pixels[center] == color(255) &&
        frame.pixels[top] == color(255) &&
        frame.pixels[bottom] == color(255)) {

        erodedFrame.pixels[center] = color(255);
      }
    }
  }

  return erodedFrame;
}

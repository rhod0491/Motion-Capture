public class Bender {

  private Object leftHand;
  private Object rightHand;
  private Object leftFoot;
  private Object rightFoot;
  private Object body;

  private ArrayList<SoundFile> audioClips;

  public Bender(Object leftHand, Object rightHand, Object leftFoot, Object rightFoot, Object body, ArrayList<SoundFile> audioClips) {
    this.leftHand = leftHand;
    this.rightHand = rightHand;
    this.leftFoot = leftFoot;
    this.rightFoot = rightFoot;
    this.body = body;

    this.audioClips = audioClips;
  }

  public void playAudio() {

    for (SoundFile audioClip : audioClips) {
      if (audioClip.isPlaying()) {
        return;
      }
    }

    audioClips.get(int(random(0, audioClips.size()))).play();
  }

  public int getLeftEdge() {
    return min(leftHand.getLeftEdge(), leftFoot.getLeftEdge());
  }

  public int getRightEdge() {
    return max(rightHand.getRightEdge(), rightFoot.getRightEdge());
  }

  // Check if bender is colloding an enemy object
  boolean isColliding(EnemyObject enemy) {  
    if (enemy.isInBackground()) {
      return false;
    }

    return leftHand.overlaps(enemy) ||
      rightHand.overlaps(enemy) ||
      leftFoot.overlaps(enemy) ||
      rightFoot.overlaps(enemy);
  }

  // Split frame into quarters and search each region for a white pixel
  public void updatePositon(PImage frame) {
    int monkeyRight = 0;
    int monkeyBottom = 0;
    int monkeyLeft = frame.width - 1;
    int monkeyTop = frame.height - 1;

    for (int x = 0; x < frame.width; x++) {
      for (int y = 0; y < frame.height; y++) {
        color pixel = frame.pixels[x + y * frame.width];
        if (pixel == color(255)) {

          if (x < monkeyLeft) {
            monkeyLeft = x;
          }

          if (x > monkeyRight) {
            monkeyRight = x;
          }

          if (y < monkeyTop) {
            monkeyTop = y;
          }

          if (y > monkeyBottom) {
            monkeyBottom = y;
          }
        }
      }
    }

    int xCenter = (monkeyLeft + monkeyRight) / 2;
    int yCenter = (monkeyTop + monkeyBottom) / 2;
    int bodyOffset = 15;

    boolean foundLeftHand = false;
    boolean foundRightHand = false;
    boolean foundLeftFoot = false;
    boolean foundRightFoot = false;

    int shiftX = (background.width / 2) - (frame.width / 2);
    int shiftY = (background.height / 2) - (frame.height / 2);

  leftHandSearch:
    for (int x = monkeyLeft; x < (xCenter - bodyOffset); x++) {
      for (int y = monkeyTop; y < (yCenter - bodyOffset); y++) {
        color pixel = frame.pixels[x + y * frame.width];
        if (pixel == color(255)) {
          leftHand.setPosition(x + shiftX, y + shiftY);
          foundLeftHand = true;
          break leftHandSearch;
        }
      }
    }

  rightHandSearch:
    for (int x = monkeyRight; x > (xCenter + bodyOffset); x--) {
      for (int y = monkeyTop; y < (yCenter - bodyOffset); y++) {
        color pixel = frame.pixels[x + y * frame.width];
        if (pixel == color(255)) {
          rightHand.setPosition(x + shiftX, y + shiftY);
          foundRightHand = true;
          break rightHandSearch;
        }
      }
    }

  leftFootSearch:
    for (int x = monkeyLeft; x < (xCenter - bodyOffset); x++) {
      for (int y = monkeyBottom; (y > yCenter + bodyOffset); y--) {
        color pixel = frame.pixels[x + y * frame.width];
        if (pixel == color(255)) {
          leftFoot.setPosition(x + shiftX, y + shiftY);
          foundLeftFoot = true;
          break leftFootSearch;
        }
      }
    }

  rightFootSearch:
    for (int x = monkeyRight; x > (xCenter + bodyOffset); x--) {
      for (int y = monkeyBottom; y > (yCenter + bodyOffset); y--) {
        color pixel = frame.pixels[x + y * frame.width];
        if (pixel == color(255)) {
          rightFoot.setPosition(x + shiftX, y + shiftY);
          foundRightFoot = true;
          break rightFootSearch;
        }
      }
    }

    if (!foundLeftHand) {
      leftHand.setPosition(monkeyLeft + 25 + shiftX, monkeyTop + 25 + shiftY);
    }

    if (!foundRightHand) {
      rightHand.setPosition(monkeyRight - 25 + shiftX, monkeyTop + 25 + shiftY);
    }

    if (!foundLeftFoot) {
      leftFoot.setPosition(monkeyLeft + 25 + shiftX, monkeyBottom - 25 + shiftY);
    }

    if (!foundRightFoot) {
      rightFoot.setPosition(monkeyRight - 25 + shiftX, monkeyBottom - 25 + shiftY);
    }

    body.setPosition(xCenter + shiftX, yCenter + shiftY);
  }
  
  // draw bender to a new frame and render that frame in th center.
  public void render() {
    PGraphics benderFrame = createGraphics(background.width, background.height);

    benderFrame.imageMode(CENTER);

    benderFrame.beginDraw();

    // draw black border along arms and legs
    benderFrame.stroke(0);
    benderFrame.strokeWeight(17);

    benderFrame.line(body.getPosition().x - 10, body.getPosition().y - 10, leftHand.getPosition().x + 10, leftHand.getPosition().y + 10);
    benderFrame.line(body.getPosition().x + 10, body.getPosition().y - 10, rightHand.getPosition().x - 10, rightHand.getPosition().y + 10);
    benderFrame.line(body.getPosition().x - 10, body.getPosition().y + 30, leftFoot.getPosition().x, leftFoot.getPosition().y);
    benderFrame.line(body.getPosition().x + 10, body.getPosition().y + 30, rightFoot.getPosition().x, rightFoot.getPosition().y); 

    // draw arms and legs
    benderFrame.stroke(199, 213, 226);
    benderFrame.strokeWeight(15);

    benderFrame.line(body.getPosition().x - 10, body.getPosition().y - 10, leftHand.getPosition().x + 10, leftHand.getPosition().y + 10);
    benderFrame.line(body.getPosition().x + 10, body.getPosition().y - 10, rightHand.getPosition().x - 10, rightHand.getPosition().y + 10);
    benderFrame.line(body.getPosition().x - 10, body.getPosition().y + 30, leftFoot.getPosition().x, leftFoot.getPosition().y);
    benderFrame.line(body.getPosition().x + 10, body.getPosition().y + 30, rightFoot.getPosition().x, rightFoot.getPosition().y); 

    // render hands/feet/body
    benderFrame.image(leftHand.getTexture(), leftHand.getPosition().x, leftHand.getPosition().y);
    benderFrame.image(rightHand.getTexture(), rightHand.getPosition().x, rightHand.getPosition().y);
    benderFrame.image(leftFoot.getTexture(), leftFoot.getPosition().x, leftFoot.getPosition().y);
    benderFrame.image(rightFoot.getTexture(), rightFoot.getPosition().x, rightFoot.getPosition().y);
    benderFrame.image(body.getTexture(), body.getPosition().x, body.getPosition().y - 50);       

    benderFrame.endDraw();

    image(benderFrame, background.width / 2, background.height / 2);
  }
  
}

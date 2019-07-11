public class EnemyObject extends Object {

  private boolean inBackground;
  private boolean movingLeft;
  private int speed;

  // Generate random values for each variable
  public EnemyObject(PImage texture) {
    super(texture.get());

    speed = int(random(5, 10));

    // 2/3 chance to be in background
    int pickDepth = int(random(0, 3));
    if (pickDepth >= 1) {
      this.texture.resize(this.texture.width / 4, 0);
      inBackground = true;
    }

    int pickDirection = int(random(0, 2));
    if (pickDirection == 0) {
      position.x = -(getWidth() / 2);
    } else {
      position.x = background.width + (getWidth() / 2);
      movingLeft = true;
    }

    position.y = int(random((getHeight() / 2), background.height - (getHeight() / 2) + 1));
  }

  public int getWidth() {
    return texture.width;
  }

  public int getHeight() {
    return texture.height;
  }

  public boolean isInBackground() {
    return inBackground;
  }

  public boolean isMovingLeft() {
    return movingLeft;
  }

  // Draw the object to the canvas, scale(-1, 1) to flip image horizontally
  public void render() {
    if (movingLeft) {
      position.x -= speed;
      scale(-1, 1);
      image(texture, -position.x, position.y);
      scale(-1, 1);
    } else {
      position.x += speed;
      image(texture, position.x, position.y);
    }
  }

  boolean isColliding(EnemyObject otherObject) {
    if (this == otherObject || 
      inBackground != otherObject.isInBackground() || 
      movingLeft == otherObject.isMovingLeft()) 
    {
      return false;
    }

    return this.overlaps(otherObject);
  }

  // render the object teleport sequence
  public void teleport() {
    image(portalImg, position.x, position.y);
    warpSound.play();
    
    if (movingLeft) {
      position.x = bender.getLeftEdge() - getWidth();
    } else {
      position.x = bender.getRightEdge() + getWidth();
    }
    
    image(portalImg, position.x, position.y);
  }

  // render the object explode sequence
  public void explode() {
    if (movingLeft) {
      image(collisionFlameImg, position.x - (getWidth() / 2), position.y);
    } else {
      image(collisionFlameImg, position.x + (getWidth() / 2), position.y);
    }

    explosionSound.play();
  }

  public boolean hasFlownAcross() {
    if (movingLeft) {
      return position.x + (getWidth() / 2) <= 0;
    } else {
      return position.x - (getWidth() / 2) >= background.width;
    }
  }
  
}

private class Object {

  protected PImage texture;
  protected PVector position;

  public Object() {
    position = new PVector(0, 0);
  }

  public Object(PImage texture) {
    this();
    this.texture = texture;
  }

  public PImage getTexture() {
    return texture;
  }

  public PVector getPosition() {
    return position;
  }

  public void setPosition(int x, int y) {
    this.position.x = x;
    this.position.y = y;
  }

  public int getLeftEdge() {
    return int(position.x - (texture.width / 2));
  }

  public int getRightEdge() {
    return int(position.x + (texture.width / 2));
  }

  public int getTopEdge() {
    return int(position.y - (texture.height / 2));
  }

  public int getBottomEdge() {
    return int(position.y + (texture.height / 2));
  }

  public boolean overlaps(Object other) {

    int thisLeft = this.getLeftEdge();
    int thisRight = this.getRightEdge();
    int thisTop = this.getTopEdge();
    int thisBottom = this.getBottomEdge();

    int otherLeft = other.getLeftEdge();
    int otherRight = other.getRightEdge();
    int otherTop = other.getTopEdge();
    int otherBottom = other.getBottomEdge();

    boolean widthOverlap = (thisLeft <= otherLeft && otherLeft <= thisRight) ||       // this overlaps other from the left
      (thisLeft <= otherRight && otherRight <= thisRight) ||                          // this overlaps other from the right
      (thisLeft <= otherLeft && otherRight <= thisRight) ||                           // this overlaps other completely
      (otherLeft <= thisLeft && thisRight <= otherRight);                             // other overlaps this completely

    boolean heightOverlap = (thisTop <= otherTop && otherTop <= thisBottom) ||        // this overlaps other from the top
      (thisTop <= otherBottom && otherBottom <= thisBottom) ||                        // this overlaps other from the bottom
      (thisTop <= otherTop && otherBottom <= thisBottom) ||                           // this overlaps other completely
      (otherTop <= thisTop && thisBottom <= otherBottom);                             // other overlaps this completely

    return widthOverlap && heightOverlap;
  }
  
}

class Bait implements Comparable<Bait> {
  int position;
  int baitSizeX, baitSizeY;
  int baitWaveCount;
  int baitWaveLength;
  int baitWaveHeight;
  int eyeSize;
  color baitColor;
  
  int animValue;
  int animDir;
  
  public Bait(int baitSizeX, int baitSizeY, int position, color baitColor) {
    this.position = position;
    this.baitSizeX = baitSizeX;
    this.baitSizeY = baitSizeY;
    this.baitColor = baitColor;

    animValue = 0;
    animDir = 1;

    baitWaveCount = 3;
    baitWaveLength = 2 * baitSizeX / baitWaveCount;
    baitWaveHeight = baitSizeY / 3;
    eyeSize = baitSizeX / 2;
  }

  public int compareTo(Bait b) {
    if (position < b.position)
      return -1;
    else if (position > b.position)
      return 1;
    else
      return 0;
  }
  
  public boolean equals(Object o) {
    if (this == o)
        return true;
    if (o == null)
        return false;
    if (getClass() != o.getClass())
        return false;
    
    Bait bait = (Bait) o;
    return bait.position == position;
}

  public void  drawBait() {
    int xPos = position % BOX_COUNT_IN_ONE_ROW * BOX_WIDTH + BOX_WIDTH / 2;
    int yPos = position / BOX_COUNT_IN_ONE_ROW * BOX_HEIGHT + BOX_HEIGHT / 2;

    xPos += animValue;
    animValue += animDir;
    if(animValue > 3 || animValue < -3) 
      animDir *= -1;

    fill(baitColor);
    stroke(255);
    strokeWeight(2);
    bezier(xPos - baitSizeX, yPos + baitSizeY, 
      xPos - baitSizeX, yPos - baitSizeY * 2, 
      xPos + baitSizeX, yPos - baitSizeY * 2, 
      xPos + baitSizeX, yPos + baitSizeY);

    fill(0);
    for (int i = 0; i < baitWaveCount; i++) {
      bezier(xPos - baitSizeX + i * baitWaveLength, yPos + baitSizeY, 
        xPos - baitSizeX + baitWaveLength / 2 + i * baitWaveLength, yPos + baitSizeY - baitWaveHeight, 
        xPos - baitSizeX + baitWaveLength / 2 + i * baitWaveLength, yPos + baitSizeY - baitWaveHeight, 
        xPos - baitSizeX + baitWaveLength + i * baitWaveLength, yPos + baitSizeY);
    }

    fill(255);
    ellipse(xPos - eyeSize, yPos, eyeSize, eyeSize);
    ellipse(xPos + eyeSize, yPos, eyeSize, eyeSize);

    fill(0, 0, 255);
    ellipse(xPos - eyeSize, yPos, eyeSize - 1, eyeSize - 1);
    ellipse(xPos + eyeSize, yPos, eyeSize - 1, eyeSize - 1);
  }
}

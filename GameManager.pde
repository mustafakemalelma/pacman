class GameManager implements PacmanMoveListener {

  final static int STATUS_IDLE = 1;
  final static int STATUS_PLAYING = 2;
  final static int STATUS_DEAD = 3;
  final static int STATUS_WON = 4;

  int score;
  int status;

  public GameManager() {
    this.score = 0;
    this.status = STATUS_IDLE;
  }

  public int getStatus() {
    return status;
  }

  public void setStatus(int status) {
    this.status = status;
  }

  public int getScore() {
    return score;
  }

  public void drawWinScreen() {
    background(0);

    fill(255, 255, 0);
    noStroke();
    arc(width / 2, height / 2 - 100, 150, 150, 
      radians(30), 
      radians(330));


    fill(255, 0, 0);
    int startCenterX = width / 2 + 20;
    int startCenterY = height / 2 - 140;
    int innerLength = 5;
    int outerLength = 15;
    beginShape();
    for (int i = 0; i < 360; i += 72) {
      vertex(startCenterX + innerLength * cos(radians(i - 36)), startCenterY + innerLength * sin(radians(i - 36)));
      vertex(startCenterX + outerLength * cos(radians(i)), startCenterY + outerLength * sin(radians(i)));

      vertex(startCenterX + outerLength * cos(radians(i)), startCenterY + outerLength * sin(radians(i)));
      vertex(startCenterX + innerLength * cos(radians(i + 36)), startCenterY + innerLength * sin(radians(i + 36)));
    }
    endShape(CLOSE);


    textAlign(CENTER);
    textSize(40);
    fill(255);
    text("YOU WON", width / 2, height / 2 + 50);
    textSize(20);
    text("Score: " + gm.getScore(), width / 2, height / 2 + 100);

    textSize(14);
    text("to play again just click with mouse", width / 2, height - 120);
  }

  public void drawDeadScreen() {
    background(0);

    fill(255, 255, 0);
    noStroke();
    arc(width / 2, height / 2 - 100, 150, 150, 
      radians(30), 
      radians(330));

    textAlign(CENTER);
    textSize(40);
    fill(0);
    text("X", width / 2 + 20, height / 2 - 130);

    textSize(40);
    fill(255);
    text("GAME OVER", width/2, height / 2 + 50);
    textSize(20);
    text("Score: " + gm.getScore(), width/2, height / 2 + 100);

    textSize(14);
    text("to play again just click with mouse", width / 2, height - 20);
  }

  public void onTheBox(int boxNum) {
    if (status == STATUS_IDLE || boxNum == 0)
      return;

    if (baitMng.isThereBait(boxNum)) {
      status = STATUS_DEAD;
      return;
    }

    if (baitMng.consumeDot(boxNum))
      score += 2;
    else
      score -= 1;

    if (baitMng.isAllDotsConsumed())
      status = STATUS_WON;
  }
}

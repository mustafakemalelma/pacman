class Grid {
  public void drawGrids() {
    background(0);
    stroke(255);
    strokeWeight(1);
    fill(0);

    for (int i = 0; i <= width; i += BOX_WIDTH) {
      for (int j = 0; j <= height; j += BOX_HEIGHT) {
        rect(i, j, BOX_WIDTH, BOX_HEIGHT);
      }
    }
  }
} 

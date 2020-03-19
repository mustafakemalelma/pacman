class BaitManager {
  AVLTree<Bait> baits;
  int dots[];

  public BaitManager(int count) {
    baits = new AVLTree<Bait>();

    dots = new int[TOTAL_BOX_COUNT];
    dots[0] = 0;
    for (int i = 1; i < TOTAL_BOX_COUNT; i++) {
      dots[i] = 1;
    }

    for (int i = 0; i < count; i++) {
      boolean isInserted = false;
      do {
        try {
          int boxNum = (int) random(TOTAL_BOX_COUNT);
          if (boxNum == 0) throw new Exception();

          color baitColor = color(random(255), random(255), random(255));
          baits.root = baits.insert(baits.root, new Bait(10, 8, boxNum, baitColor));
          dots[boxNum] = 0;
          isInserted = true;
        } 
        catch(Exception e) {
          isInserted = false;
        }
      } while (!isInserted);
    }
  }
  
  public boolean isAllDotsConsumed() {
    for(int dot : dots) {
      if(dot == 1) return false;
    }
    
    return true;
  }

  public boolean isThereBait(int boxNum) {
    Bait temp = new Bait(-1, -1, boxNum, color(0));
    Node<Bait> searchedRoot = baits.search(baits.root, temp);

    if (searchedRoot != null && temp.equals(searchedRoot.key))
      return true;
    else
      return false;
  }

  public boolean consumeDot(int boxNum) {
    if (dots[boxNum] == 1) {
      dots[boxNum] = 0;
      return true;
    }

    return false;
  }

  public void drawBaits() {
    for (Bait bait : baits) {
      bait.drawBait();
    }
  }

  public void drawDots() {
    stroke(255);
    strokeWeight(5);
    for (int i = 0; i < TOTAL_BOX_COUNT; i++) {
      if (dots[i] == 1) {
        int xPos = i % BOX_COUNT_IN_ONE_ROW * BOX_WIDTH + BOX_WIDTH / 2;
        int yPos = i / BOX_COUNT_IN_ONE_ROW * BOX_HEIGHT + BOX_HEIGHT / 2;

        point(xPos, yPos);
      }
    }
  }
}

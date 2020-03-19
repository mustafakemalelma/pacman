final int ACTION_GO_UP = 1;
final int ACTION_GO_DOWN = 2;
final int ACTION_GO_LEFT = 3;
final int ACTION_GO_RIGHT = 4;

class Action<T> {
  int aType;
  T payload;

  public Action(int t, T payload) {
    this.aType = t;
    this.payload = payload;
  }
}

public interface PacmanMoveListener {
  public void onTheBox(int boxNum);
}

class Pacman {
  private int animDirection = 1;
  private int mouthOpenDegree = 30;
  private int lookAngle = 0;

  private ArrayList<PacmanMoveListener> moveListeners;

  private Action<Integer> nextAction;

  int pSize, xPos, yPos, pSpeedX, pSpeedY;

  public Pacman(int initialX, int initialY, int pSize) {
    this.pSize = pSize;
    this.xPos = initialX;
    this.yPos = initialY;

    pSpeedX = 0;
    pSpeedY = 0;

    moveListeners = new ArrayList<PacmanMoveListener>();
  }

  public void drawPacman() {
    noStroke();
    fill(255, 255, 0);

    mouthOpenDegree -= animDirection * 2;

    arc(xPos, yPos, pSize, pSize, 
      radians(lookAngle + mouthOpenDegree), 
      radians(lookAngle + 360 - mouthOpenDegree));

    xPos += pSpeedX;
    if (xPos < -pSize / 2) 
      xPos = BOX_COUNT_IN_ONE_ROW * BOX_WIDTH + pSize / 2;
    else if (xPos > BOX_COUNT_IN_ONE_ROW * BOX_WIDTH + pSize  / 2)
      xPos = -pSize / 2;


    yPos += pSpeedY;
    if (yPos < -pSize / 2) 
      yPos = BOX_COUNT_IN_ONE_COLUMN * BOX_HEIGHT + pSize / 2;
    else if (yPos > BOX_COUNT_IN_ONE_COLUMN * BOX_HEIGHT + pSize / 2)
      yPos = -pSize / 2;

    if (mouthOpenDegree == 0 || mouthOpenDegree == 30)
      animDirection *= -1;

    if (xPos % BOX_WIDTH == BOX_WIDTH / 2 && yPos % BOX_HEIGHT == BOX_HEIGHT / 2) {
      int boxNum = xPos / BOX_WIDTH + (yPos / BOX_HEIGHT) * BOX_COUNT_IN_ONE_ROW;
      performNextAction();
      notifyListeners(boxNum);
    }
  }
  
  public void teleport(int x, int y) {
    xPos = x - (x % BOX_WIDTH) + BOX_WIDTH / 2;
    yPos = y - (y % BOX_HEIGHT) + BOX_HEIGHT / 2;
  }

  private void performNextAction() {
    if (nextAction == null) return;

    switch(nextAction.aType) {
    case ACTION_GO_UP:
      pSpeedX = 0;
      pSpeedY = nextAction.payload;
      lookAngle = 270;
      break;
    case ACTION_GO_DOWN:
      pSpeedX = 0;
      pSpeedY = nextAction.payload;
      lookAngle = 90;
      break;
    case ACTION_GO_LEFT:
      pSpeedY = 0;
      pSpeedX = nextAction.payload;
      lookAngle = 180;
      break;
    case ACTION_GO_RIGHT:
      pSpeedY = 0;
      pSpeedX = nextAction.payload;
      lookAngle = 0;
      break;
    }
  }

  private void notifyListeners(int boxNum) {
    for (PacmanMoveListener pml : moveListeners)
      pml.onTheBox(boxNum);
  }

  public void addMoveListener(PacmanMoveListener pml) {
    moveListeners.add(pml);
  }

  public void setSpeedX(int speedX) {
    int aType = speedX < 0 ? ACTION_GO_LEFT : ACTION_GO_RIGHT;
    nextAction = new Action<Integer>(aType, speedX);
  }

  public void setSpeedY(int speedY) {
    int aType = speedY < 0 ? ACTION_GO_UP : ACTION_GO_DOWN;
    nextAction = new Action<Integer>(aType, speedY);
  }
}

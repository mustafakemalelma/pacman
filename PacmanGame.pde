GameManager gm;
Grid grid;
BaitManager baitMng;
Pacman pacman;

final int BOX_WIDTH = 40;
final int BOX_HEIGHT = 40;
int BOX_COUNT_IN_ONE_ROW;
int BOX_COUNT_IN_ONE_COLUMN;
int TOTAL_BOX_COUNT;

final int PACMAN_SPEED = 2;

void setup() {
  size(800, 800);
  //fullScreen(P2D, 1);

  BOX_COUNT_IN_ONE_ROW = (int) width / BOX_WIDTH;
  BOX_COUNT_IN_ONE_COLUMN = (int) height / BOX_HEIGHT;
  TOTAL_BOX_COUNT = BOX_COUNT_IN_ONE_ROW * BOX_COUNT_IN_ONE_COLUMN;

  startGame();
}

void startGame() {
  gm = new GameManager();
  grid = new Grid();
  baitMng = new BaitManager(10); // bait count
  pacman = new Pacman(BOX_WIDTH / 2, BOX_HEIGHT / 2, 20); // xpos, ypos, size
  pacman.addMoveListener(gm);
}

void draw() {
  int gameStatus = gm.getStatus();
  
  if(gameStatus == GameManager.STATUS_WON)
    gm.drawWinScreen();
  else if (gameStatus != GameManager.STATUS_DEAD) {
    grid.drawGrids();
    baitMng.drawBaits();
    baitMng.drawDots();
    pacman.drawPacman();
  } else {
    gm.drawDeadScreen();
  }
}

void keyPressed() {
  int gameStatus = gm.getStatus();
  
  if (gameStatus == GameManager.STATUS_DEAD)
    return;
  else if (gameStatus == GameManager.STATUS_IDLE)
    gm.setStatus(GameManager.STATUS_PLAYING);

  if (key == CODED) {
    if (keyCode == UP) {
      pacman.setSpeedY(-PACMAN_SPEED);
    } else if (keyCode == DOWN) {
      pacman.setSpeedY(PACMAN_SPEED);
    } else if (keyCode == LEFT) {
      pacman.setSpeedX(-PACMAN_SPEED);
    } else if (keyCode == RIGHT) {
      pacman.setSpeedX(PACMAN_SPEED);
    }
  }
}

void mouseClicked() {
  if(gm.getStatus() == GameManager.STATUS_DEAD) {
    startGame();
    return;
  }
  
  pacman.teleport(mouseX, mouseY);
}

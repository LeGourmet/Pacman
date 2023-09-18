import java.util.Arrays;
import java.util.Collections;
import javax.swing.JOptionPane;

void setup() {
  size(800, 700);
  
  // ------ INIT GLOBALS VARIABLES ------
  SPRITES = loadImage("./images/sprites.png");
  LOGO    = loadImage("./images/logo.png");
  PACFONT = createFont("./font/PacFont.ttf", 32, true);
  
  mainMenu       = new MainMenu();
  highScoreMenu  = new HighScoreMenu();
  level          = new Level();
  pauseMenu      = new PauseMenu();
  loseMenu       = new LoseMenu();
  winMenu        = new WinMenu();

  gameState = GameState.MAIN_MENU;

  // ------ INIT DISPLAY MODE ------
  frameRate(60);
  
  imageMode(CENTER);
  shapeMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  textFont(PACFONT);
}

void draw() {
  switch(gameState){
    case MAIN_MENU        : mainMenu.drawIt();                  break;
    case HIGH_SCORE_MENU  : highScoreMenu.drawIt();             break;
    case LEVEL            : level.drawIt(); level.update();     break;
    case PAUSE_MENU       : level.drawIt(); pauseMenu.drawIt(); break;
    case LOSE_MENU        : loseMenu.drawIt();                  break;
    case WIN_MENU         : winMenu.drawIt();                   break;
  }
}

void keyPressed() {
  int aKey = (key == CODED) ? keyCode : key;
  
  if(key=='i') println(frameRate);

  switch(gameState){
    case MAIN_MENU        : mainMenu.handleKey(aKey);       break;
    case HIGH_SCORE_MENU  : highScoreMenu.handleKey(aKey);  break;
    case LEVEL            : level.handleKey(aKey);          break;
    case PAUSE_MENU       : pauseMenu.handleKey(aKey);      break;
    case LOSE_MENU        : loseMenu.handleKey(aKey);       break;
    case WIN_MENU         : winMenu.handleKey(aKey);        break;
  }
  
  if(aKey == ESC) { key = 0; } // do not close window if escape button is pressed 
}

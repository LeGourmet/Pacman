// --------------------------------------------------------------------
// ------------------------------ GLOBAL ------------------------------
// --------------------------------------------------------------------
PImage SPRITES;
PImage LOGO;
PFont  PACFONT;

MainMenu       mainMenu;
HighScoreMenu  highScoreMenu;
Level          level;
PauseMenu      pauseMenu;
LoseMenu       loseMenu;
WinMenu        winMenu;

GameState gameState;

// --------------------------------------------------------------------
// ----------------------------- CONSTANT -----------------------------
// --------------------------------------------------------------------
final String DEMO_MAZE       = "./levels/demoMaze.txt";
final String SAVE_MAZE       = "./saves/saveMaze.txt";
final String SAVE_DATA       = "./saves/saveData.txt";
final String SAVE_SCOREBOARD = "./saves/scoreBoard.txt";

final color COLOR_WHITE               = #FFFFFF;
final color COLOR_BLACK               = #000000;
final color COLOR_GREY                = #777777;
final color COLOR_RED                 = #FF0000;
final color COLOR_GREEN               = #00FF00;
final color COLOR_BLUE                = #0000FF;
final color COLOR_DARK_BLUE           = #000099;
final color COLOR_YELLOW              = #FFFF00;
final color COLOR_ORANGE              = #FF7800;
final color COLOR_PINK                = #FF7777;
final color COLOR_PACGUM              = #FFDDAA;

final int SPRITE_SIZE                 = 50; 
final int SPRITE_POS_PACMAN_X         = 850;
final int SPRITE_POS_PACMAN_RIGHT     = 0;
final int SPRITE_POS_PACMAN_DOWN      = 150;
final int SPRITE_POS_PACMAN_LEFT      = 300;
final int SPRITE_POS_PACMAN_UP        = 450;
final int SPRITE_POS_PACMAN_DEAD_X    = 350;
final int SPRITE_POS_BLINKY_X         = 650;
final int SPRITE_POS_PINKY_X          = 700;
final int SPRITE_POS_INKY_X           = 750;
final int SPRITE_POS_CLYDE_X          = 800;
final int SPRITE_POS_GHOST_RIGHT      = 0;
final int SPRITE_POS_GHOST_DOWN       = 100;
final int SPRITE_POS_GHOST_LEFT       = 200;
final int SPRITE_POS_GHOST_UP         = 300;
final int SPRITE_POS_GHOST_FEAR_1_X   = 0;
final int SPRITE_POS_GHOST_FEAR_2_X   = 50;
final int SPRITE_POS_GHOST_FEAR_Y     = 850;
final int SPRITE_POS_GHOST_EAT_X      = 300;
final int SPRITE_POS_GHOST_EAT_RIGHT  = 250;
final int SPRITE_POS_GHOST_EAT_DOWN   = 300;
final int SPRITE_POS_GHOST_EAT_LEFT   = 350;
final int SPRITE_POS_GHOST_EAT_UP     = 400;
final int SPRITE_POS_FRUIT_X          = 600;

final int SCORE_DOT                   = 10;
final int SCORE_SUPER_DOT             = 50;
final int SCORE_BONUS                 = 100;
final int SCORE_LIFE_REMAIN           = 400;
final int SCORE_GHOST_EAT             = 500;
final int SCORE_WIN                   = 1000;

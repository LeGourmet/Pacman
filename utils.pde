enum CellType { EMPTY, WALL, DOT, SUPER_DOT, BARRIER, BONUS }
enum GameState { MAIN_MENU, HIGH_SCORE_MENU, LEVEL, PAUSE_MENU, LOSE_MENU, WIN_MENU }
enum GhostState { SPAWN, CHASE, FEAR, EAT }

public class Pair<A,B>{
  public A first;
  public B second;
  
  public Pair(A p_first, B p_second){
    this.first = p_first;
    this.second = p_second;
  }
}

public class Vec2i{
  public int x;
  public int y;
  
  public Vec2i(){ set(0,0); }
  public Vec2i(int p_x, int p_y){ set(p_x,p_y); }
  
  public void set(int p_x, int p_y){
    this.x = p_x;
    this.y = p_y;
  }
  
  public void set(Vec2i p_that){
    this.x = p_that.x;
    this.y = p_that.y;
  }
}

void drawSprite(int p_posSpriteX, int p_posSpriteY, float p_posDisplayX, float p_posDisplayY, float displaySize){
  image(SPRITES.get(p_posSpriteX, p_posSpriteY, SPRITE_SIZE, SPRITE_SIZE), p_posDisplayX, p_posDisplayY, displaySize, displaySize);
}

public class Hero{
  private Vec2i   _initialPositionInMaze;
  private Vec2i   _positionInMaze;
  private Vec2i   _movementDirection;
  private Vec2i   _bufferInput;
  private int     _spriteCount;
  
  public Hero(Vec2i p_initialPosition, Vec2i p_position, Vec2i p_movementDirection, Vec2i p_bufferInput, int p_spriteCount){
    this._initialPositionInMaze = p_initialPosition;
    this._positionInMaze = p_position;
    this._movementDirection = p_movementDirection;
    this._bufferInput = p_bufferInput;
    this._spriteCount = p_spriteCount;
  }
  
  public Vec2i getPositionInMaze(){ return _positionInMaze; }
  public Vec2i getMovementDirection(){ return _movementDirection; }
  
  public String toString(){
    return (_positionInMaze.x+","+_positionInMaze.y+","+_movementDirection.x+","+_movementDirection.y+","+_bufferInput.x+","+_bufferInput.y+","+_spriteCount);
  }
  
  public void reset(){
    this._positionInMaze = new Vec2i(_initialPositionInMaze.x,_initialPositionInMaze.y);
    this._bufferInput = new Vec2i(0,0);
    this._movementDirection = new Vec2i(0,0);
    this._spriteCount = 0;
  }
  
  public void launchMove(int p_x, int p_y) { _bufferInput.set(p_x,p_y); }
  
  public void update(Maze p_maze){    
    // -------------------- update movement direction --------------------
    if(_bufferInput.x+_bufferInput.y != 0){
      switch(p_maze.getCell(_positionInMaze.x+_bufferInput.x,_positionInMaze.y+_bufferInput.y)){
        case WALL:
        case BARRIER:
          break;
        
        default: 
          if (!(_movementDirection.x+_bufferInput.x == 0 && _movementDirection.y+_bufferInput.y == 0 )){
            _movementDirection.set(_bufferInput); 
            _bufferInput.set(0,0);
          }
          break;
      }
    }
    
    // -------------------- update position --------------------
    switch(p_maze.getCell(_positionInMaze.x+_movementDirection.x,_positionInMaze.y+_movementDirection.y)){
      case WALL:
      case BARRIER: 
        _movementDirection.set(0,0);
        break;
      
      default: 
        _positionInMaze.set(p_maze.getCellCoords(_positionInMaze.x+_movementDirection.x,_positionInMaze.y+_movementDirection.y));
        break;
    }
  }
  
  public void updateSpriteCount(){ if(_movementDirection.x!=0 || _movementDirection.y!=0) _spriteCount++; }
  
  public void drawIt(float p_centerMazeX, float p_centerMazeY, int p_nbCellsMazeX, int p_nbCellsMazeY, float p_cellSize, int p_gameSpeed){
    float centerX = p_centerMazeX+p_cellSize*(_positionInMaze.x-(p_nbCellsMazeX-1.f)*0.5f) + _movementDirection.x*p_cellSize*((_spriteCount%p_gameSpeed)/float(p_gameSpeed)-1.f);
    float centerY = p_centerMazeY+p_cellSize*(_positionInMaze.y-(p_nbCellsMazeY-1.f)*0.5f) + _movementDirection.y*p_cellSize*((_spriteCount%p_gameSpeed)/float(p_gameSpeed)-1.f);
    int numSprite = int(2.*_spriteCount/p_gameSpeed)%3;
    int spritePosY = SPRITE_POS_PACMAN_RIGHT;
   
         if (_movementDirection.x ==  1 && _movementDirection.y ==  0) { spritePosY = SPRITE_POS_PACMAN_RIGHT+numSprite*SPRITE_SIZE; }
    else if (_movementDirection.x ==  0 && _movementDirection.y ==  1) { spritePosY = SPRITE_POS_PACMAN_DOWN+numSprite*SPRITE_SIZE; }
    else if (_movementDirection.x == -1 && _movementDirection.y ==  0) { spritePosY = SPRITE_POS_PACMAN_LEFT+numSprite*SPRITE_SIZE; }
    else if (_movementDirection.x ==  0 && _movementDirection.y == -1) { spritePosY = SPRITE_POS_PACMAN_UP+numSprite*SPRITE_SIZE; }
    
    drawSprite(SPRITE_POS_PACMAN_X, spritePosY, centerX, centerY, p_cellSize*1.5f);
  }
  
  public void drawItDeath(float p_centerMazeX, float p_centerMazeY, int p_nbCellsMazeX, int p_nbCellsMazeY, float p_cellSize, int p_gameSpeed, int p_spriteCount){
    float centerX = p_centerMazeX+p_cellSize*(_positionInMaze.x-(p_nbCellsMazeX-1.f)*0.5f) + _movementDirection.x*p_cellSize*((_spriteCount%p_gameSpeed)/float(p_gameSpeed)-1.f);
    float centerY = p_centerMazeY+p_cellSize*(_positionInMaze.y-(p_nbCellsMazeY-1.f)*0.5f) + _movementDirection.y*p_cellSize*((_spriteCount%p_gameSpeed)/float(p_gameSpeed)-1.f);
    drawSprite(SPRITE_POS_PACMAN_DEAD_X, SPRITE_SIZE*p_spriteCount, centerX, centerY, p_cellSize*1.5f);
  }
  
}

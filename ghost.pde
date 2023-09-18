public abstract class Ghost {
  protected Vec2i      _initialPositionInMaze;
  protected Vec2i      _positionInMaze;
  protected Vec2i      _movementDirection;
  protected Vec2i      _target;
  protected GhostState _state;
  protected int        _spriteCount;
  protected int        _posSpriteNormalX;
  
  public Ghost(Vec2i p_initialPosition, Vec2i p_position, Vec2i p_movementDirection, Vec2i p_target, GhostState p_state, int p_spriteCount, int p_posSpriteNormalX){
    this._initialPositionInMaze = p_initialPosition;
    this._positionInMaze = p_position;
    this._movementDirection = p_movementDirection;
    this._target = p_target;
    this._state = p_state;
    this._spriteCount = p_spriteCount;
    this._posSpriteNormalX = p_posSpriteNormalX;
  }
  
  public Vec2i getPositionInMaze(){ return _positionInMaze; }
  public Vec2i getMovementDirection(){ return _movementDirection; }
  public GhostState getState(){ return _state; }
  
  public String toString(){
    String state = (_state==GhostState.CHASE ? "CHASE" : (_state==GhostState.FEAR ? "FEAR" : (_state==GhostState.EAT ? "EAT" : "SPAWN")));
    return (_positionInMaze.x+","+_positionInMaze.y+","+_movementDirection.x+","+_movementDirection.y+","+_target.x+","+_target.y+","+state+","+_spriteCount);
  }
  
  public void reset(){
    this._positionInMaze = new Vec2i(_initialPositionInMaze.x,_initialPositionInMaze.y);
    this._movementDirection = new Vec2i(0,0);
    this._target = new Vec2i(0,0);
    this._state = GhostState.SPAWN;
    this._spriteCount = 0;
  }
  
  public void setState(GhostState p_state){ 
    _state = p_state; 
    if(p_state==GhostState.FEAR)
      _movementDirection.set(-_movementDirection.x,-_movementDirection.y);
  }
  
  public abstract void chooseTarget(Level p_level);
  
  public void update(Level p_level){
    // -------------------- update target --------------------
    _target.set(p_level.getMaze().getPosSpawn());
    if(_state == GhostState.FEAR && p_level.getTimeFearCount()>=5) _state = GhostState.CHASE;
    if(_state == GhostState.CHASE) chooseTarget(p_level);
    
    // -------------------- update movement direction --------------------
    ArrayList<Vec2i> dir = new ArrayList<>(Arrays.asList(new Vec2i(0,-1), new Vec2i(-1,0), new Vec2i(0,1), new Vec2i(1,0)));
    if(_state == GhostState.FEAR) Collections.shuffle(dir);
    
    int   id = -1;
    float min_dist = Float.MAX_VALUE;
    
    for(int i=0; i<4 ;i++){
      Vec2i    posNextCell  = new Vec2i(dir.get(i).x+_positionInMaze.x, dir.get(i).y+_positionInMaze.y);
      CellType typeNextCell = p_level.getMaze().getCell(posNextCell.x,posNextCell.y);
      float    distNextCell = dist(_target.x,_target.y,posNextCell.x,posNextCell.y);
      boolean   goBack      = (_movementDirection.x+dir.get(i).x == 0 && _movementDirection.y+dir.get(i).y == 0 );
      
      if( !(goBack) && typeNextCell!=CellType.WALL && (_state==GhostState.SPAWN || _state==GhostState.EAT || typeNextCell!=CellType.BARRIER) && (_state==GhostState.FEAR || distNextCell<min_dist) ){
          min_dist = distNextCell; id = i;
       }
    }
    
    // -------------------- update position --------------------
    if(id!=-1) {
      if(_positionInMaze.x==p_level.getMaze().getPosSpawn().x && _positionInMaze.y==p_level.getMaze().getPosSpawn().y) _state = (_state==GhostState.EAT) ? GhostState.SPAWN : GhostState.CHASE;
      _movementDirection.set(dir.get(id));
      _positionInMaze.set(p_level.getMaze().getCellCoords(_positionInMaze.x+_movementDirection.x,_positionInMaze.y+_movementDirection.y));
    }else{
      _movementDirection.set(0,0);
    }
  }
  
  public void updateSpriteCount(){ _spriteCount++; }
  
  public void drawIt(int p_timeFearCount, float p_centerMazeX, float p_centerMazeY, int p_nbCellsMazeX, int p_nbCellsMazeY, float p_cellSize, int p_gameSpeed){
    int nbSpriteAnim = 1;
    int spritePosX = _posSpriteNormalX;
    int spritePosY = SPRITE_POS_GHOST_RIGHT;
        
    switch(_state){
      case EAT:
        spritePosX = SPRITE_POS_GHOST_EAT_X; spritePosY = SPRITE_POS_GHOST_EAT_RIGHT; nbSpriteAnim = 1; 
             if (_movementDirection.x ==  1 && _movementDirection.y ==  0) { spritePosY = SPRITE_POS_GHOST_EAT_RIGHT; }
        else if (_movementDirection.x ==  0 && _movementDirection.y ==  1) { spritePosY = SPRITE_POS_GHOST_EAT_DOWN ; }
        else if (_movementDirection.x == -1 && _movementDirection.y ==  0) { spritePosY = SPRITE_POS_GHOST_EAT_LEFT ; }
        else if (_movementDirection.x ==  0 && _movementDirection.y == -1) { spritePosY = SPRITE_POS_GHOST_EAT_UP   ; }
        break;
      
      case SPAWN:
      case CHASE:
        spritePosX = _posSpriteNormalX; spritePosY = SPRITE_POS_GHOST_RIGHT; nbSpriteAnim = 2; 
             if (_movementDirection.x ==  1 && _movementDirection.y ==  0) { spritePosY = SPRITE_POS_GHOST_RIGHT; }
        else if (_movementDirection.x ==  0 && _movementDirection.y ==  1) { spritePosY = SPRITE_POS_GHOST_DOWN ; }
        else if (_movementDirection.x == -1 && _movementDirection.y ==  0) { spritePosY = SPRITE_POS_GHOST_LEFT ; }
        else if (_movementDirection.x ==  0 && _movementDirection.y == -1) { spritePosY = SPRITE_POS_GHOST_UP   ; }
        break;
        
      case FEAR:
        if(p_timeFearCount<3 || _spriteCount%8<4) { 
          spritePosX = SPRITE_POS_GHOST_FEAR_1_X; spritePosY = SPRITE_POS_GHOST_FEAR_Y; nbSpriteAnim = 2; 
        } else {
          spritePosX = SPRITE_POS_GHOST_FEAR_2_X; spritePosY = SPRITE_POS_GHOST_FEAR_Y; nbSpriteAnim = 2;
        }
        break;
    }
    drawIt(spritePosX, spritePosY, nbSpriteAnim, p_centerMazeX, p_centerMazeY, p_nbCellsMazeX, p_nbCellsMazeY, p_cellSize, p_gameSpeed);
  };
  
  private void drawIt(int p_spritePosX, int p_spritePosY, int p_spriteNbFrame, float p_centerMazeX, float p_centerMazeY, int p_nbCellsMazeX, int p_nbCellsMazeY, float p_cellSize, int p_gameSpeed){
    float centerX = p_centerMazeX+p_cellSize*(_positionInMaze.x-(p_nbCellsMazeX-1.f)*0.5f) + _movementDirection.x*p_cellSize*((_spriteCount%p_gameSpeed)/float(p_gameSpeed)-1.f);;
    float centerY = p_centerMazeY+p_cellSize*(_positionInMaze.y-(p_nbCellsMazeY-1.f)*0.5f) + _movementDirection.y*p_cellSize*((_spriteCount%p_gameSpeed)/float(p_gameSpeed)-1.f);;
    int numSprite = int(2.*_spriteCount/p_gameSpeed)%p_spriteNbFrame;
    drawSprite(p_spritePosX, p_spritePosY+numSprite*SPRITE_SIZE, centerX, centerY, p_cellSize*1.5f);
  }
}

public class Blinky extends Ghost{
  public Blinky(Vec2i p_initialPosition, Vec2i p_position, Vec2i p_movementDirection, Vec2i p_target, GhostState p_state, int p_spriteCount){
    super(p_initialPosition,p_position,p_movementDirection,p_target,p_state,p_spriteCount,SPRITE_POS_BLINKY_X);
  }
  
  public void chooseTarget(Level p_level){ 
    Vec2i heroPos = p_level.getHero().getPositionInMaze(); 
    _target.set(heroPos); 
  }
}

public class Pinky extends Ghost{
  public Pinky(Vec2i p_initialPosition, Vec2i p_position, Vec2i p_movementDirection, Vec2i p_target, GhostState p_state, int p_spriteCount){
    super(p_initialPosition,p_position,p_movementDirection,p_target,p_state,p_spriteCount,SPRITE_POS_PINKY_X);
  }
  
  public void chooseTarget(Level p_level){
    Vec2i heroDir = p_level.getHero().getMovementDirection();
    Vec2i heroPos = p_level.getHero().getPositionInMaze(); 
    _target.set(heroDir.x*4 + heroPos.x, heroDir.y*4 + heroPos.y); }
}

public class Inky extends Ghost{
  public Inky(Vec2i p_initialPosition, Vec2i p_position, Vec2i p_movementDirection, Vec2i p_target, GhostState p_state, int p_spriteCount){
    super(p_initialPosition,p_position,p_movementDirection,p_target,p_state,p_spriteCount,SPRITE_POS_INKY_X);
  }
  
  public void chooseTarget(Level p_level){
    Vec2i heroPos = p_level.getHero().getPositionInMaze();
    Vec2i heroDir = p_level.getHero().getMovementDirection();
    Vec2i BlinkyPos = p_level.getGhosts().get(0).getPositionInMaze();
    _target.set(heroPos.x+2*(heroPos.x+2*heroDir.x-BlinkyPos.x),heroPos.y+2*(heroPos.y+2*heroDir.y-BlinkyPos.y));
  }
}

public class Clyde extends Ghost{
  public Clyde(Vec2i p_initialPosition, Vec2i p_position, Vec2i p_movementDirection, Vec2i p_target, GhostState p_state, int p_spriteCount){
    super(p_initialPosition,p_position,p_movementDirection,p_target,p_state,p_spriteCount,SPRITE_POS_CLYDE_X);
  }
  
  public void chooseTarget(Level p_level){
    Vec2i heroPos = p_level.getHero().getPositionInMaze(); 
    if (dist(heroPos.x,heroPos.y,_positionInMaze.x,_positionInMaze.y)<=8) { _target.set(0,0); }
    else { _target.set(heroPos); }
  }
}

public class Level{
  private Maze             _maze;
  private Hero             _hero;
  private ArrayList<Ghost> _ghosts;
  
  private String           _levelName;
  private int              _nbLifeRemaining;
  private int              _score;
  private int              _gameSpeed;
  private int              _frameCount;
  private int              _frameCountDeath;
  private int              _frameCountGhostsFear;
  private boolean          _heroDeadAnimation;
  
  public Level(){ reset(false); }
  
  public Maze getMaze(){ return _maze; }
  public Hero getHero(){ return _hero; }
  public ArrayList<Ghost> getGhosts(){ return _ghosts; }
  public int getScore() { return _score; }
  public int getTime() { return int(_frameCount/60.f); }
  public int getTimeFearCount() { return int(_frameCountGhostsFear/60.f); }
  
  public void reset(boolean p_loadSave){
    String[] fileMazeData = loadStrings(p_loadSave ? SAVE_MAZE : DEMO_MAZE);
    char[][] mazeCellData = new char[fileMazeData[1].length()][fileMazeData.length-1];
    
    Vec2i posHero   = new Vec2i();
    Vec2i posBlinky = new Vec2i();
    Vec2i posPinky  = new Vec2i();
    Vec2i posInky   = new Vec2i(); 
    Vec2i posClyde  = new Vec2i();
        
    for(int i=0; i<fileMazeData[1].length() ;i++)
      for(int j=0; j<fileMazeData.length-1 ;j++){
        char cell = fileMazeData[j+1].charAt(i);
        switch(cell){
          case 'H': posHero.set(i,j); break;
          case 'B': posBlinky.set(i,j); break;
          case 'P': posPinky.set(i,j); break;
          case 'I': posInky.set(i,j); break;
          case 'C': posClyde.set(i,j); break;
          default : break;
        }
        mazeCellData[i][j] = cell;
      }
      
    _levelName = fileMazeData[0];
    
    String[] fileSaveData = (p_loadSave ? 
                              loadStrings(SAVE_DATA) : 
                              new String[]{"3,0,8,0,0,0,false", "0",
                               posHero.x  +","+posHero.y  +",0,0,0,0,0",
                               posBlinky.x+","+posBlinky.y+",0,0,0,0,SPAWN,0",
                               posPinky.x +","+posPinky.y +",0,0,0,0,SPAWN,0",
                               posInky.x  +","+posInky.y  +",0,0,0,0,SPAWN,0",
                               posClyde.x +","+posClyde.y +",0,0,0,0,SPAWN,0"}
                            );
    
    String[] levelData = fileSaveData[0].split(",");
    _nbLifeRemaining      = Integer.parseInt(levelData[0]);
    _score                = Integer.parseInt(levelData[1]);
    _gameSpeed            = Integer.parseInt(levelData[2]);
    _frameCount           = Integer.parseInt(levelData[3]);
    _frameCountDeath      = Integer.parseInt(levelData[4]);
    _frameCountGhostsFear = Integer.parseInt(levelData[5]);
    _heroDeadAnimation    = Boolean.parseBoolean(levelData[6]);
      
    String[] mazeData = fileSaveData[1].split(",");
    _maze = new Maze(mazeCellData, Integer.parseInt(mazeData[0]));
      
    String[] heroData = fileSaveData[2].split(",");
    _hero = new Hero(posHero,
                     new Vec2i(Integer.parseInt(heroData[0]),Integer.parseInt(heroData[1])),
                     new Vec2i(Integer.parseInt(heroData[2]),Integer.parseInt(heroData[3])),
                     new Vec2i(Integer.parseInt(heroData[4]),Integer.parseInt(heroData[5])),
                     Integer.parseInt(heroData[6]));
      
    _ghosts = new ArrayList<>();
    
    String[] blinkyData = fileSaveData[3].split(",");
    _ghosts.add(new Blinky(posBlinky,
                           new Vec2i(Integer.parseInt(blinkyData[0]),Integer.parseInt(blinkyData[1])),
                           new Vec2i(Integer.parseInt(blinkyData[2]),Integer.parseInt(blinkyData[3])),
                           new Vec2i(Integer.parseInt(blinkyData[4]),Integer.parseInt(blinkyData[5])),
                           (blinkyData[6].equals("CHASE") ? GhostState.CHASE : (blinkyData[6].equals("FEAR") ? GhostState.FEAR : (blinkyData[6].equals("EAT") ? GhostState.EAT : GhostState.SPAWN))),
                           Integer.parseInt(blinkyData[7])));
      
    String[] pinkyData = fileSaveData[4].split(",");
    _ghosts.add(new Pinky(posPinky,
                          new Vec2i(Integer.parseInt(pinkyData[0]),Integer.parseInt(pinkyData[1])),
                          new Vec2i(Integer.parseInt(pinkyData[2]),Integer.parseInt(pinkyData[3])),
                          new Vec2i(Integer.parseInt(pinkyData[4]),Integer.parseInt(pinkyData[5])),
                          (pinkyData[6].equals("CHASE") ? GhostState.CHASE : (pinkyData[6].equals("FEAR") ? GhostState.FEAR : (pinkyData[6].equals("EAT") ? GhostState.EAT : GhostState.SPAWN))),
                          Integer.parseInt(pinkyData[7])));
      
    String[] inkyData = fileSaveData[5].split(",");
    _ghosts.add(new Inky(posInky,
                         new Vec2i(Integer.parseInt(inkyData[0]),Integer.parseInt(inkyData[1])),
                         new Vec2i(Integer.parseInt(inkyData[2]),Integer.parseInt(pinkyData[3])),
                         new Vec2i(Integer.parseInt(inkyData[4]),Integer.parseInt(inkyData[5])),
                         (inkyData[6].equals("CHASE") ? GhostState.CHASE : (inkyData[6].equals("FEAR") ? GhostState.FEAR : (inkyData[6].equals("EAT") ? GhostState.EAT : GhostState.SPAWN))),
                         Integer.parseInt(inkyData[7])));
      
    String[] clydeData = fileSaveData[6].split(",");
    _ghosts.add(new Clyde(posClyde,
                          new Vec2i(Integer.parseInt(clydeData[0]),Integer.parseInt(clydeData[1])),
                          new Vec2i(Integer.parseInt(clydeData[2]),Integer.parseInt(clydeData[3])),
                          new Vec2i(Integer.parseInt(clydeData[4]),Integer.parseInt(clydeData[5])),
                          (clydeData[6].equals("CHASE") ? GhostState.CHASE : (clydeData[6].equals("FEAR") ? GhostState.FEAR : (clydeData[6].equals("EAT") ? GhostState.EAT : GhostState.SPAWN))),
                          Integer.parseInt(inkyData[7])));
  }
  
  public void save(){
    PrintWriter txtData = createWriter(SAVE_DATA);
    txtData.println(_nbLifeRemaining+","+_score+","+_gameSpeed+","+_frameCount+","+_frameCountDeath+","+_frameCountGhostsFear+","+_heroDeadAnimation);
    txtData.println(_maze.toString());
    txtData.println(_hero.toString());
    txtData.println(_ghosts.get(0).toString());
    txtData.println(_ghosts.get(1).toString());
    txtData.println(_ghosts.get(2).toString());
    txtData.println(_ghosts.get(3).toString());
    txtData.flush();
    txtData.close();
    
    PrintWriter txtMaze = createWriter(SAVE_MAZE);
    String[] fileMazeData = loadStrings(DEMO_MAZE);
    txtMaze.print(_levelName);
    for(int j=0; j<fileMazeData.length-1 ;j++){
      txtMaze.println();
      for(int i=0; i<fileMazeData[1].length() ;i++){
        char cell = fileMazeData[j+1].charAt(i);
        switch(cell){
          case 'o': txtMaze.print((_maze.getCell(i,j)==CellType.DOT) ? "o" : " "); break;
          case 'O': txtMaze.print((_maze.getCell(i,j)==CellType.SUPER_DOT) ? "O" : " "); break;
          default : txtMaze.print(cell);
        }
      }
    }
    txtMaze.flush();
    txtMaze.close();
  }
  
  public void update(){
    _frameCount++;
    _frameCountGhostsFear++;
    if(_frameCount%_gameSpeed != 0) return;
    
    if(_heroDeadAnimation){
      _frameCountDeath++;
      if(_frameCountDeath<12) return;
      if(_nbLifeRemaining<0) gameState = GameState.LOSE_MENU;
       
      _frameCountDeath = 0;
      _heroDeadAnimation = false;
      _hero.reset();
      _ghosts.forEach(a -> a.reset());
    }
        
    _maze.update(getTime());
    _hero.update(_maze);
    
    for(Ghost g : _ghosts){
      g.update(this);
      if(_hero.getPositionInMaze().x== g.getPositionInMaze().x && _hero.getPositionInMaze().y== g.getPositionInMaze().y 
          || ( dist(g.getPositionInMaze().x,g.getPositionInMaze().y,_hero.getPositionInMaze().x,_hero.getPositionInMaze().y)==1
              && g.getMovementDirection().x*_hero.getMovementDirection().x+g.getMovementDirection().y*_hero.getMovementDirection().y == -1)){
        if(g.getState()==GhostState.FEAR){ g.setState(GhostState.EAT); _score += SCORE_GHOST_EAT; }
        if(g.getState()==GhostState.CHASE){ 
          _heroDeadAnimation = true;
          _nbLifeRemaining--;          
        }
      } 
    }
    
    switch(_maze.getCell(_hero.getPositionInMaze().x,_hero.getPositionInMaze().y)){
      case DOT:
        _score += SCORE_DOT; 
        _maze.setCell(_hero.getPositionInMaze().x,_hero.getPositionInMaze().y,CellType.EMPTY); 
        break;
      
      case SUPER_DOT: 
        _score += SCORE_SUPER_DOT; 
        _maze.setCell(_hero.getPositionInMaze().x,_hero.getPositionInMaze().y,CellType.EMPTY); 
        _ghosts.forEach(g -> g.setState(GhostState.FEAR));
        _frameCountGhostsFear = 0;
        break;
      
      case BONUS: 
        _score += SCORE_BONUS; 
        _maze.setCell(_hero.getPositionInMaze().x,_hero.getPositionInMaze().y,CellType.EMPTY); 
        break;
      
      default: break;
    }
    
    if(_maze.getNbPacGum()<=0) gameState = GameState.WIN_MENU;
  }
  
  public void handleKey(int p_key) {
    switch(p_key){
      case UP:
      case 'z':
      case 'Z': _hero.launchMove(0, -1); break;
      
      case DOWN:
      case 's':
      case 'S': _hero.launchMove(0, 1); break;
      
      case RIGHT:
      case 'd':
      case 'D': _hero.launchMove(1, 0); break;
      
      case LEFT:
      case 'q':
      case 'Q': _hero.launchMove(-1, 0); break;
    
      case ESC: gameState = GameState.PAUSE_MENU; break;
    }
  }
  
  public void drawIt(){
    background(0);
    
    float cellSize = min(width/float(_maze.getNbCellsX()), 3.f*height/(4.f*float(_maze.getNbCellsY())));
    _maze.drawIt(width/2.f,height/2.f,cellSize,_gameSpeed);
    if(!_heroDeadAnimation){
      _hero.drawIt(width/2.f,height/2.f,_maze.getNbCellsX(),_maze.getNbCellsY(),cellSize,_gameSpeed);
      _ghosts.forEach(g -> g.drawIt(getTimeFearCount(),width/2.f,height/2.f,_maze.getNbCellsX(),_maze.getNbCellsY(),cellSize,_gameSpeed));
      if(gameState != GameState.PAUSE_MENU){
        _maze.updateSpriteCount();
        _hero.updateSpriteCount();
        _ghosts.forEach(g -> g.updateSpriteCount());
      }
    }else{ _hero.drawItDeath(width/2.f,height/2.f,_maze.getNbCellsX(),_maze.getNbCellsY(),cellSize,_gameSpeed,_frameCountDeath); }
    
    stroke(COLOR_YELLOW);
    strokeWeight(4);
    line(0.f,height/8.f,width,height/8.f);
    line(0.f,7.f*height/8.f,width,7.f*height/8.f);
    
    fill(COLOR_WHITE);
    textSize(25);
    
    text(_levelName,width/2.f,height/16.f);
    textAlign(LEFT, CENTER);
    text("SCORE: "+_score,20.f,7.5f*height/8.f);
    textAlign(CENTER, CENTER);
    text(getTime()/60+" : "+getTime()%60,width/2.f,7.5f*height/8.f);
    textAlign(RIGHT, CENTER);
    text("LIFES: "+_nbLifeRemaining,width-20.f,7.5f*height/8.f);
    textAlign(CENTER, CENTER);
  }
  
}

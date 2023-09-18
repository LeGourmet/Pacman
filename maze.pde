public class Maze {
  private CellType         _cells[][];
  private ArrayList<Vec2i> _posBonus;
  private Vec2i            _posSpawn;
  private int              _nbPacGum;
  private int              _spriteCount;

  public Maze(char[][] p_mazeData, int p_spriteCount) {
    _cells = new CellType[p_mazeData.length][p_mazeData[0].length];
    _posBonus = new ArrayList<>();
    _posSpawn = new Vec2i(0,0);
    _nbPacGum = 0;
    
    for (int i=0; i<p_mazeData.length; i++)
      for (int j=0; j<p_mazeData[i].length; j++)
        switch(p_mazeData[i][j]){
          case 'x': _cells[i][j] = CellType.WALL;                          break;
          case 'o': _cells[i][j] = CellType.DOT;       _nbPacGum++;        break;
          case 'O': _cells[i][j] = CellType.SUPER_DOT;                     break;
          case '-': _cells[i][j] = CellType.BARRIER;   _posSpawn.set(i,j); break;
          case 'b': _posBonus.add(new Vec2i(i,j));                  
          default : _cells[i][j] = CellType.EMPTY;                         break;
        }
  
    _spriteCount = p_spriteCount;
  }
  
  public int getNbPacGum(){ return _nbPacGum; }
  public int getNbCellsX(){ return _cells.length; }
  public int getNbCellsY(){ return _cells[0].length; }
  public Vec2i getPosSpawn() { return _posSpawn; }
  
  public String toString() { return ""+_spriteCount; }

  public CellType getCell(int p_x, int p_y){
    Vec2i coords = getCellCoords(p_x,p_y);
    return _cells[coords.x][coords.y];
  }
  
  public Vec2i getCellCoords(int p_x, int p_y){
    if(p_x<0) p_x=_cells.length-1;
    if(p_y<0) p_y=_cells[0].length-1;
    return new Vec2i(p_x%_cells.length,p_y%_cells[0].length);
  }

  public void setCell(int p_x, int p_y, CellType p_value){ 
    if(_cells[p_x][p_y] == CellType.DOT) _nbPacGum--;
    if(p_value          == CellType.DOT) _nbPacGum++;
    _cells[p_x][p_y] = p_value;
  }

  public void update(int p_time) {
    if (p_time%15 == 0)
     for(Vec2i pos : _posBonus) _cells[pos.x][pos.y] = CellType.BONUS;
          
    if (p_time%15 == 5)
      for(Vec2i pos : _posBonus) _cells[pos.x][pos.y] = CellType.EMPTY;
  }
  
  public void updateSpriteCount(){ _spriteCount++; }
  
  public void drawIt(float p_centerMazeX, float p_centerMazeY, float p_cellSize, int p_gameSpeed) {   
    noStroke();
    fill(COLOR_BLACK);
    rect(p_centerMazeX, p_centerMazeY, p_cellSize*_cells.length, p_cellSize*_cells[0].length);
    
    for (int i=0; i<_cells.length; i++)
      for (int j=0; j<_cells[i].length; j++) {
        float centerCellX = p_centerMazeX+p_cellSize*(i-(_cells.length-1.f)*0.5f);
        float centerCellY = p_centerMazeY+p_cellSize*(j-(_cells[i].length-1.f)*0.5f);
        
        switch(_cells[i][j]){
          case WALL : 
            float cellSize_6 = p_cellSize/6.f;
            float cellSize_3 = p_cellSize/3.f;
          
            float vertexSides[] = new float[16]; 
            boolean cellsArroundIsWall[] = new boolean[8];
            Vec2i dirSides[]   = {new Vec2i( 1, 0), new Vec2i( 0, 1), new Vec2i(-1, 0), new Vec2i( 0,-1)};
            Vec2i dirCorners[] = {new Vec2i( 1,-1), new Vec2i( 1, 1), new Vec2i(-1, 1), new Vec2i(-1,-1)};
            for(int k=0; k<8 ;k++){
              int id_side   = (3+(k+k%2)/2)%4;
              int id_corner = (k-k%2)/2;
              cellsArroundIsWall[k] = getCell(i+dirSides[id_side].x,j+dirSides[id_side].y)==CellType.WALL;
              vertexSides[k*2]   = centerCellX + dirCorners[id_corner].x*cellSize_6 + dirSides[id_side].x*((cellsArroundIsWall[k]) ? cellSize_3 : cellSize_6);
              vertexSides[k*2+1] = centerCellY + dirCorners[id_corner].y*cellSize_6 + dirSides[id_side].y*((cellsArroundIsWall[k]) ? cellSize_3 : cellSize_6);
            }
            
            noStroke();
            fill(COLOR_DARK_BLUE);
            
            beginShape();
              for(int k=0; k<4 ;k++){
                vertex(vertexSides[k*4],vertexSides[k*4+1]);
                  
                if(getCell(i+dirCorners[k].x,j+dirCorners[k].y)==CellType.WALL){
                  vertex(vertexSides[k*4  ]+((k%2==0) ? dirCorners[k].x*cellSize_6 : 0), vertexSides[k*4+1]+((k%2==1) ? dirCorners[k].y*cellSize_6 : 0));
                  if(k%2==0){ vertex(vertexSides[k*4+2], vertexSides[k*4+1]); }
                  else{       vertex(vertexSides[k*4  ], vertexSides[k*4+3]); }
                  vertex(vertexSides[k*4+2]+((k%2==1) ? dirCorners[k].x*cellSize_6 : 0), vertexSides[k*4+3]+((k%2==0) ? dirCorners[k].y*cellSize_6 : 0));
                } else {
                  if(cellsArroundIsWall[k*2])   vertex(vertexSides[k*4  ]+((k%2==0) ? dirCorners[k].x*cellSize_6 : 0), vertexSides[k*4+1]+((k%2==1) ? dirCorners[k].y*cellSize_6 : 0));
                  if(cellsArroundIsWall[k*2+1]) vertex(vertexSides[k*4+2]+((k%2==1) ? dirCorners[k].x*cellSize_6 : 0), vertexSides[k*4+3]+((k%2==0) ? dirCorners[k].y*cellSize_6 : 0));
                }
                  
                vertex(vertexSides[k*4+2],vertexSides[k*4+3]);
              }
            endShape(CLOSE);
            break;
          
          case DOT :
            noStroke();
            fill(COLOR_PACGUM); 
            circle(centerCellX, centerCellY, p_cellSize *0.33);
            break;
            
          case SUPER_DOT:
            noStroke();
            fill(COLOR_PACGUM);
            circle(centerCellX, centerCellY, p_cellSize*0.8);
            break;
            
          case BARRIER:
            noStroke();
            fill(COLOR_GREY);
            rect(centerCellX, centerCellY, p_cellSize, p_cellSize);
            break;
            
          case BONUS:
            drawSprite(SPRITE_POS_FRUIT_X,int(_spriteCount/p_gameSpeed)%7*SPRITE_SIZE,centerCellX,centerCellY,p_cellSize); // todo virer
            break;
            
          default :
            stroke(COLOR_BLACK);
            strokeWeight(1);
            fill(COLOR_BLACK);
            rect(centerCellX, centerCellY, p_cellSize, p_cellSize);
            break;
        }
      }
  }
  
}

public interface Button{ public void pushIt(); }

public abstract class Menu {
  protected ArrayList<Pair<Button,String>> _buttons;
  protected int                            _buttonSelected;
  
  public Menu(){
    this._buttons = new ArrayList<>();
    this._buttonSelected = 0;
  }
  
  public abstract void drawIt();
  
  public void handleKey(int p_key){
    switch(p_key){     
      case UP:
      case 'z':
      case 'Z': _buttonSelected--; if(_buttonSelected<0) _buttonSelected=_buttons.size()-1;  break;
      
      case DOWN:
      case 's':
      case 'S': _buttonSelected++; if(_buttonSelected>=_buttons.size()) _buttonSelected=0; break;
    
      case ENTER: if(_buttons.size()>0) _buttons.get(_buttonSelected).first.pushIt(); break;
    }
  }
  
  protected void _gotoMainMenu()  { gameState = GameState.MAIN_MENU; }
  protected void _gotoHighScore() { gameState = GameState.HIGH_SCORE_MENU; }
  protected void _gotoLevel()     { gameState = GameState.LEVEL; }
  protected void _saveLevel()     { level.save(); }
  protected void _loadLevel()     { level.reset(true); _gotoLevel(); }
  protected void _resetLevel()    { level.reset(false); _gotoLevel(); }
  protected void _exit()          { exit(); }
}

// --------------------------------------------------------------------
// ---------------------------- MAIN MENU -----------------------------
// --------------------------------------------------------------------
public class MainMenu extends Menu {
  public MainMenu(){ 
    super(); 
    _buttons.add(new Pair((Button)this::_resetLevel,"New Game"));
    _buttons.add(new Pair((Button)this::_loadLevel,"Load Save"));
    _buttons.add(new Pair((Button)this::_gotoHighScore,"High Score"));  
    _buttons.add(new Pair((Button)this::_exit,"Exit"));  
  }
  
  public void drawIt(){
    background(COLOR_BLACK);
    
    image(LOGO,width/2.f,height/6.f,width,height/3.f);
    
    int n = _buttons.size();
    float b = (8.f*height/15.f) / (2.f*(n+1.f)/5.f+n);
    float e = 2.f*b/5.f;
    float total = 2.f*height/3.f - 4.f*height/15.f;
    
    stroke(COLOR_YELLOW);
    strokeWeight(2);
    textSize(b/2.5f);
    
    for(int i=0; i<n ;i++){
      total+=e;
      fill( (i==_buttonSelected) ? 60 : 0 );
      rect(width/2.f,total+b/2.f,300.f,b,10.f);
      fill(COLOR_YELLOW);
      text(_buttons.get(i).second, width/2.f,total+b/2.f);
      total+=b;
    }
  }
}

// --------------------------------------------------------------------
// ------------------------- HIGH SCORE MENU --------------------------
// --------------------------------------------------------------------
public class HighScoreMenu extends Menu {
  public HighScoreMenu(){ super(); }
  
  public void drawIt(){
    background(COLOR_BLACK);
    
    fill(COLOR_YELLOW); textSize(65);
    text("HighScores",width/2.f,height/16.f);
    
    stroke(COLOR_YELLOW); strokeWeight(10);
    line(width/10.f,height/6.f,9.f*width/10.f,height/6.f);
    stroke(COLOR_BLACK); strokeWeight(3);
    line(width/10.f,height/6.f,9.f*width/10.f,height/6.f);
    
    String[] fileData = loadStrings(SAVE_SCOREBOARD);
    int[] col = {#ffcc00,#aeaeae,#dd5700,#d20a00,#d20a00};
    for(int i=0; i<5 ;i++){
      if(fileData.length<=i) continue;
      textSize(max(0,3-i)*10+20); fill(col[i]);
      text(i+1+" - "+fileData[i].split(" ")[0]+" : "+fileData[i].split(" ")[1], width/2.f, i*height/8.f+height/3.3f); 
    }
    
    fill(COLOR_WHITE); textSize(10);
    text("press echap TO LEAVE THIS MENU",width/6.f,49.f*height/50.f);
  }
  
  public void handleKey(int p_key){
    super.handleKey(p_key);
    switch(p_key){
      case ESC: _gotoMainMenu(); break;
    }
  }
}

// --------------------------------------------------------------------
// --------------------------- PAUSE MENU -----------------------------
// --------------------------------------------------------------------
public class PauseMenu extends Menu {
  public PauseMenu(){ 
    super(); 
    _buttons.add(new Pair((Button)this::_gotoLevel,"Resume"));
    _buttons.add(new Pair((Button)this::_resetLevel,"Restart"));
    _buttons.add(new Pair((Button)this::_saveLevel,"Save Level"));
    _buttons.add(new Pair((Button)this::_loadLevel,"Load Save"));
    _buttons.add(new Pair((Button)this::_gotoMainMenu,"Main Menu"));
  }
  
  public void drawIt(){
    noStroke();
    fill(COLOR_GREY,100);
    rect(width/2.f,height/2.f,width,height);
    
    stroke(COLOR_YELLOW);
    strokeWeight(2);
    
    fill(COLOR_BLACK);
    rect(width/2.f,height/2.f,3.f*width/5.f,13.f*height/15.f,50.f);
    
    fill(COLOR_YELLOW);
    textSize(height/12.f);
    text("PAUSE",width/2.f,2.5f*height/15.f);
    
    
    line(1.3f*width/5.f,4.f*height/15.f,3.7f*width/5.f,4.f*height/15.f);
    
    int n = _buttons.size();
    float b = (2.f*height/3.f) / (3.f*(n+1.f)/5.f+n);
    float e = 3.f*b/5.f;
    float total = 4.f*height/15.f;
    
    textSize(b/2.5f);
    
    for(int i=0; i<n ;i++){
      total+=e;
      fill( (i==_buttonSelected) ? 60 : 0 );
      rect(width/2.f,total+b/2.f,300.f,b,10.f);
      fill(255,255,0);
      text(_buttons.get(i).second, width/2.f,total+b/2.f);
      total+=b;
    }
  }
  
  public void handleKey(int p_key){   
    super.handleKey(p_key);
    switch(p_key){      
      case ESC: _gotoLevel(); break;
    }
  }
}

// --------------------------------------------------------------------
// ---------------------------- LOSE MENU -----------------------------
// --------------------------------------------------------------------

public class LoseMenu extends Menu {
  public LoseMenu(){ super(); }
  
  public void drawIt(){
    background(COLOR_BLACK);
    
    noStroke();
    fill(COLOR_GREY,100);
    rect(width/2.f,height/2.f,width,height);
    
    fill(COLOR_BLACK);
    rect(width/2.f,height/2.f,width,height/3.5f);
    
    fill(COLOR_WHITE);
    textSize(40);
    text("YOU LOSE",width/2.f,height/2.f);
    
    fill(COLOR_WHITE); textSize(10);
    text("PRESS ECHAP TO LEAVE",width/2.f,height/1.7f);
  }
  
  public void handleKey(int p_key){
    super.handleKey(p_key);
    switch(p_key){
      case ESC: _gotoMainMenu(); break;
    }
  }
}

// --------------------------------------------------------------------
// ---------------------------- WIN MENU ------------------------------
// --------------------------------------------------------------------

public class WinMenu extends Menu {
  public WinMenu(){ super(); }
  
  public void drawIt(){
    background(COLOR_BLACK);
    
    noStroke();
    fill(COLOR_GREY,100);
    rect(width/2.f,height/2.f,width,height);
    
    fill(COLOR_BLACK);
    rect(width/2.f,height/2.f,width,height/3.5f);
    
    fill(COLOR_WHITE);
    textSize(40);
    text("YOU WIN",width/2.f,height/2.f);
    
    fill(COLOR_WHITE); textSize(10);
    text("PRESS ECHAP TO LEAVE",width/2.f,height/1.7f);
  }
  
  public void handleKey(int p_key){
    super.handleKey(p_key);
    switch(p_key){
      case ESC: 
        _gotoMainMenu(); 
        String name = JOptionPane.showInputDialog("You win, please enter your name: ").replace(" ","");
        String[] tab = loadStrings(SAVE_SCOREBOARD);
        PrintWriter txt = createWriter(SAVE_SCOREBOARD);
        for(int i=0; i<5 ;i++){
          String[] scoreRegister = tab[i].split(" ");
          if (int(scoreRegister[1]) < level.getScore()) { txt.println(name+" "+level.getScore()); }
          else                                          { txt.println(scoreRegister[0]+" "+scoreRegister[1]); }
        }
        txt.flush();
        txt.close();
        
        break;
    }
  }
  
}

int GAMESTATE = 0;
int INTRO = 0;
int PLAY = 1;
int END = 2;
ArrayList<Platform> plats = new ArrayList();
Player p1 = new Player(400, 400, 50, 50);

void setup(){
  size(800, 800);
  rectMode(CENTER);
  imageMode(CENTER);
  mapGen();
}

void draw(){
  if(GAMESTATE == INTRO){
    drawIntro();
  }else if(GAMESTATE == PLAY){
    drawPlay();
  }else if(GAMESTATE == END){
    drawEnd();
  }
  
}

void mapGen(){
  plats.add(new Platform(200, 600, 400, 50));
}

void drawIntro(){
  background(0, 0, 250);
}

void drawPlay(){
  background(0, 10, 150);
  if(p1.pressL){
   p1.vx -= 5; 
  }
  if(p1.pressR){
    p1.vx += 5;
  }
  if(p1.pressU){
    p1.vy -= 10;
  }
  p1.vy += 4;
  for(int i = 0; i < plats.size(); i++){
    Platform p = plats.get(i);
    if(p.doesCol(p1)){
      p1.colLogic(p);
    }
  }
  for(int i = 0; i < plats.size(); i++){
    Platform p = plats.get(i);
    p.display(p.x - p1.vx, p.y-p1.vy);
  }
  p1.display();
}

void drawEnd(){
  background(0, 0, 0);
}

void keyPressed(){
  if(GAMESTATE == INTRO && key == ' '){//transition
    GAMESTATE = PLAY;
  }
  if(GAMESTATE == PLAY && key == 'a'){//left
    p1.pressL = true;
  }
  if(GAMESTATE == PLAY && key == 'd'){//right
    p1.pressR = true;
  }
  if(GAMESTATE == PLAY && key == 'w'){//jump
    p1.pressU = true;
  }
}

void keyReleased(){
  if(GAMESTATE == PLAY && key == 'a'){//left
    p1.pressL = false;
  }
  if(GAMESTATE == PLAY && key == 'd'){//right
    p1.pressR = false;
  }
  if(GAMESTATE == PLAY && key == 'w'){//jump
    p1.pressU = false;
  }
}



class Platform{
  float x, y, w, h;
  color c = color(100, 20, 0);
  Platform(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  boolean doesCol(Player p){
    float dx = abs(x-p.x);
    float dy = abs(y-p.y);
    return dx < (p.w + w)/2 && dy < (p.h + h)/2;
  }
  void display(float xPos,float yPos){
    fill(c);
    rect(xPos, yPos, w, h);
  }
  
}

class Player{
  float x, y, w, h;
  float vx = 0;
  float vy = 0;
  boolean pressL;
  boolean pressU;
  boolean pressR;
  boolean canJump;
  color c;
  Player(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  void move(){
    x += vx;
    y += vy;
  }
  void display(){
    fill(c);
    rect(400, 400, w, h);
  }
  void colLogic(Platform p){
    float dx = abs(x - p.x);//moves player to the correct position based on collision point
    float dy = abs(y - p.y);
    float gapx = dx-(p.w+w)/2;
    float gapy = dy-(p.h+h)/2; 
    if (gapx < gapy) {
      if (p.y > y) {//hit top
        canJump = true;
        vy = 0;
        y = p.y - p.h/2 - h/2;
      } else {//hit bottom
        vy = 0;
        y = p.y + p.h/2 + h/2 + 1;
      }
    } else {
      if (p.x > x) {//hit left
        vx = 0;
        x = p.x - p.w/2 - w/2;
      } else {//hit right
        vx = 0;
        x = p.x + p.w/2 + w/2;
      }
  }
  }
}
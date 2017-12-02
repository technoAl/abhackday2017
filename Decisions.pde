int GAMESTATE = 0;
int INTRO = 0;
int PLAY = 1;
int END = 2;
ArrayList<Platform> plats = new ArrayList();
ArrayList<Integer> genObst = new ArrayList();
ArrayList<Integer> genDiff = new ArrayList();
Player p1 = new Player(400, 400, 50, 50);

void setup() {
  size(800, 800);
  rectMode(CENTER);
  imageMode(CENTER);
  noStroke();
  build(5);
  mapGen();
}

void draw() {
  if (GAMESTATE == INTRO) {
    drawIntro();
  } else if (GAMESTATE == PLAY) {
    drawPlay();
  } else if (GAMESTATE == END) {
    drawEnd();
  }
}

void build(int num) {
  for (int i= 0; i < num; i++) {
    genDiff.add(int(random(0, 5)));
    genObst.add(int(random(0, 5)));
  }
}

void mapGen() {
  int btwn = 100;
  int shift = 300;
  plats.add(new Platform(0+ shift, 700, 200, 25 ));
  for (int i = 0; i < genObst.size(); i++) {
    int ww = (genDiff.get(i) + 3) * 100;
    plats.add(new Platform(btwn + ww + 100 + shift, 700, 200, 25));
    btwn += ww + 100;
  }
}

void drawIntro() {
  background(0, 0, 250);
}

void drawPlay() {
  background(0, 100, 250);
  if (p1.pressL) {
    p1.vx = -10;
  }
  if (p1.pressR) {
    p1.vx = 10;
  }
  if (p1.pressU && p1.canJump) {
    p1.vy -= 15;
    p1.canJump = false;
  }
  if(!p1.canJump)
  p1.vy += 0.4;
   for (int i = 0; i < plats.size(); i++) {
    Platform p = plats.get(i);
    p.x = p.x - p1.vx;
    p.y = p.y - p1.vy;
    p.display();
  }
  for (int i = 0; i < plats.size(); i++) {
    Platform p = plats.get(i);
    //if (!p1.canJump) {
      if (p.doesCol(p1)) {
        p1.colLogic(p);
      }
    //}
  }

  p1.display();
}

void drawEnd() {
  background(0, 0, 0);
}

void keyPressed() {
  if (GAMESTATE == INTRO && key == ' ') {//transition
    GAMESTATE = PLAY;
  }
  if (GAMESTATE == PLAY && key == 'a') {//left
    p1.pressL = true;
  }
  if (GAMESTATE == PLAY && key == 'd') {//right
    p1.pressR = true;
  }
  if (GAMESTATE == PLAY && key == 'w') {//jump
    p1.pressU = true;
  }
}

void keyReleased() {
  if (GAMESTATE == PLAY && key == 'a') {//left
    p1.pressL = false;
    p1.vx = 0;
  }
  if (GAMESTATE == PLAY && key == 'd') {//right
    p1.pressR = false;
    p1.vx = 0;
  }
  if (GAMESTATE == PLAY && key == 'w') {//jump
    p1.pressU = false;
  }
}

void genPit(int start, int end) {
  plats.add(new Platform(start + 125/2, 700, 125, 25));
  plats.add(new Platform(end - 125/2, 700, 125, 25));
  plats.add(new Platform((start+end)/2, 750, 50, 25));
}

class Platform {
  float x, y, w, h;
  color c = color(250, 0, 0);
  Platform(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  boolean doesCol(Player p) {
    float dx = abs(x-p.x);
    float dy = abs(y-p.y);
    if (dx < (p.w + w)/2 && dy < (p.h + h)/2) {
      println(p.y + " " + y + " " + p.vy);
    }
    return dx < (p.w + w)/2 && dy < (p.h + h)/2;
  }
  void display() {
    fill(c);
    rect(x, y, w, h);
  }
}

class Player {
  float x, y, w, h;
  float vx = 0;
  float vy = 0;
  boolean pressL;
  boolean pressU;
  boolean pressR;
  boolean canJump;
  color c;
  Player(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  void move() {
    x += vx;
    y += vy;
  }
  void display() {
    fill(c);
    rect(400, 400, w, h);
  }
  void colLogic(Platform p) {
    float dx = abs(x - p.x);//moves player to the correct position based on collision point
    float dy = abs(y - p.y);
    float gapx = dx-(p.w+w)/2;
    float gapy = dy-(p.h+h)/2; 
    if (gapx < gapy) {
      if (p.y > y) {//hit top
        canJump = true;
        vy = 0;
        println(p.y);
        float y_top = p.y-p.h/2;
        float y_bot_player = y+h/2;
        println(y_top, y_bot_player);
        float proper_y_plat = y_bot_player+p.h/2;
        p.y = proper_y_plat;
        float dist = (-y_top+y_bot_player);
        println(dist);
        adjust(0, dist,p);
      } else {//hit bottom
        vy = 0;
        float dist = p.y -( y - p.h/2 - h/2);
        adjust(0, dist, p);
      }
    } else {
      if (p.x > x) {//hit left
        vx = 0;
        float dist = p.x -( x - p.w/2 - w/2);
        adjust(1, dist, p);
      } else {//hit right
        vx = 0;
        float dist = p.x - (x+ p.w/2 + w/2);
        adjust(1, dist, p);
      }
    }
  }
}

void adjust(int j, float dist, Platform p) {
  if (j == 0) {
    println(dist);
    for (int i = 0; i < plats.size(); i++) {
      if(plats.get(i) != p){
        plats.get(j).y += dist;
      }
    }
  } else if (j==1) {
    for (int i = 0; i < plats.size(); i++) {
      if(plats.get(i) == p){
        plats.get(j).x += dist;
      }
    }
  }
}
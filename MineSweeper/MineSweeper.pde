int[][]mines;
boolean[][]flags;
boolean[][]revealed;

int gridW=16;
int gridH=16;
int cellSize=50;
int numMines=40;

void settings(){
  size(gridW*cellSize,gridH*cellSize);
}
void setup(){
  mines=new int[gridW][gridH];
  flags=new boolean[gridW][gridH];
  revealed=new boolean[gridW][gridH];
  
  for(int x=0;x<gridW;x++){
    for(int y=0;y<gridH;y++){
      mines[x][y]=0;
      flags[x][y]=false;
      revealed[x][y]=false;
    }
  }
}
void placeMines(){
  for(int i=0;i<numMines;i++){
    mines[int(random(gridW))][int(random(gridH))]=1;
  }
}
void clearMines(){
  for(int x=0;x<gridW;x++){
    for(int y=0;y<gridH;y++){
      mines[x][y]=0;
    }
  }
}
boolean firstClick=true;
void mousePressed(){
  int x=int(mouseX/cellSize);
  int y=int(mouseY/cellSize);
  if(mouseButton==RIGHT){
    flags[x][y]=!flags[x][y];
    return;
  }else{
    if(firstClick){
      firstClick=false;
      do{
        clearMines();
        placeMines();
      }while(mines[x][y]!=0);
    }
      
    if(mines[x][y]!=0){
      println("Dang!");
      exit();
    }else{
      reveal(x,y);
    }
  }
}
boolean outBounds(int x,int y){
  return x<0||y<0||x>=gridW||y>=gridH;
}
int calcNear(int x,int y){
  if(outBounds(x,y))return 0;
  int i=0;
  for(int oX=-1;oX<=1;oX++){
    for(int oY=-1;oY<=1;oY++){
      if(outBounds(oX+x,oY+y))continue;
      i+=mines[oX+x][oY+y];
    }
  }
  return i;
}

void reveal(int x,int y){
  if(outBounds(x,y))return;
  if(revealed[x][y])return;
  revealed[x][y]=true;
  if(calcNear(x,y)>0)return;
  
  reveal(x-1,y-1);
  reveal(x-1,y+1);
  reveal(x+1,y-1);
  reveal(x+1,y+1);
  
  reveal(x-1,y);
  reveal(x+1,y);
  reveal(x,y-1);
  reveal(x,y+1);
}

void draw(){
  background(0);
  for(int x=0;x<gridW;x++){
    for(int y=0;y<gridH;y++){
      
      color col1=color(2*255/5);
      color col2=color(3*255/5);
      
      color txtColor=color(0);
      
      int near=calcNear(x,y);
      
      if(flags[x][y]){
        col1=color(255,0,0);
        col2=color(4*255/5,255/5,255/5);
      }else if(revealed[x][y]){
        col1=color(255/2);
        col2=color(255/2);
      }
      
      if(near==1)txtColor=color(255*1/4,255*1/4,255*3/4);
      if(near==2)txtColor=color(255*1/4,255*3/4,155*1/4);
      if(near==3)txtColor=color(255,0,0);
      if(near==4)txtColor=color(0,0,255);
      if(near==5)txtColor=color(255,0,0);
      
      boolean alternate=(x+y)%2==0;
      if(alternate){
        fill(col2);
        stroke(col2);
      }else{
        fill(col1);
        stroke(col1);
      }
      
      //if(mines[x][y]>0){
        //fill(0,255,0);
        //stroke(0,255,0);
      //}
      
      rect(x*cellSize,y*cellSize,cellSize,cellSize);
      
      if(near>0&&revealed[x][y]){
        fill(txtColor);
        noStroke();
        textAlign(LEFT,TOP);
        textSize(cellSize);
        text(""+near,x*cellSize,y*cellSize);
      }
      
    }
  }
}

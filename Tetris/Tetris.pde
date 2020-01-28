final int fieldWidth = 12;
final int fieldHeight = 22;
int[][] fieldData = new int[fieldHeight][fieldWidth];
int[][] fieldBuffer = new int[fieldHeight][fieldWidth];
Cell[][] cells = new Cell[fieldHeight][fieldWidth];
int time = int(frameRate);

 int[][][] minoShape = {
  {{0, 1, 0, 0},
   {0, 1, 0, 0},
   {0, 1, 0, 0},
   {0, 1, 0, 0}},  //I (0)
 
  {{2, 2},
   {2, 2}},  //O (1)
 
  {{0, 3, 3},
   {3, 3, 0},
   {0, 0, 0}},  //S (2)
 
  {{4, 4, 0},
   {0, 4, 4},
   {0, 0, 0}},  //Z (3)
   
  {{0, 5, 0},
   {0, 5, 0},
   {5, 5, 0}},  //J (4)
   
  {{0, 6, 0},
   {0, 6, 0},
   {0, 6, 6}},  //L (5)
   
  {{0, 7, 0},
   {7, 7, 7},
   {0, 0, 0}},  //T (6)
};

void setup(){
  size(480, 880);
  //Fieldの初期化
  for(int i=0; i<fieldHeight; i++){
    for(int j=0; j<fieldWidth; j++){
      fieldData[i][j] = 0;
    }
  }
  //壁
  for(int i=0; i<fieldHeight; i++){
    fieldData[i][0] = 99;
    fieldData[i][11] = 99;
  }
  for(int i=0; i<fieldWidth; i++){
    fieldData[21][i] = 99;
  }
  //Cellの初期化
  for(int i=0; i<fieldHeight; i++){
    for(int j=0; j<fieldWidth; j++){
      cells[i][j] = new Cell(j*40, i*40, 0);
    }
  }
  //println(minoShape[0][2][1]);
}
//ミノの左上の座標
int x = 5, y = 0,   minoType = int(random(0, minoShape.length));
int minoLenW, minoLenH;
void draw(){
  minoLenW = minoShape[minoType][0].length;
  minoLenH = minoShape[minoType].length;
  if(time>=frameRate){
    //描画処理
    background(255);
    Update();
    Display();
    if(!IsHit(x, y+1)){
      y++;
    }else{
      for(int i=0; i<minoLenH; i++){
        for(int j=0; j<minoLenW; j++){
          //ミノの描画部分でなければ飛ばす
          if(minoShape[minoType][i][j] == 0)continue;
          fieldData[y+i][x+j] |= minoShape[minoType][i][j];
        }
      }
      for(int i=0; i<fieldHeight-1; i++){
        boolean fillLine = true;
        for(int j=1; j<fieldWidth-1; j++){
          if(fieldData[i][j] == 0) fillLine = false;
        }
        if(fillLine){
          for(int j=i; j>0; j--){
            fieldData[j] = fieldData[j-1];
          }
        }
      }
      ResetMino();
    }
    time = 0;
  }
  time++;
}

void keyPressed(){
  switch(key){
    case 'w': break;
    case 's': if(!IsHit(x, y+1))y++; break;
    case 'a': if(!IsHit(x-1, y))x--; break;
    case 'd': if(!IsHit(x+1, y))x++; break;
    case ' ': RotateMino(); break;
  }
  //更新毎に描画する
  Update();
  Display();
  //PrintMino();
}

void Update(){
  //描画バッファにフィールドデータを代入
  for(int i=0; i<fieldHeight; i++){
    for(int j=0; j<fieldWidth; j++){
      fieldBuffer[i][j] = fieldData[i][j];
    }
  }
  //描画バッファにミノを反映
  for(int i=0; i<minoLenH; i++){
    for(int j=0; j<minoLenW; j++){
      if(minoShape[minoType][i][j] != 0){
        fieldBuffer[y+i][x+j] |= minoShape[minoType][i][j];
      }
    }
  }
  //Cellデータの更新
  for(int i=0; i<fieldHeight; i++){
    for(int j=0; j<fieldWidth; j++){
      cells[i][j].type = fieldBuffer[i][j];
    }
  }
}

void Display(){
  //Cellの描画
  for(int i=0; i<fieldHeight; i++){
    for(int j=0; j<fieldWidth; j++){
      cells[i][j].Draw();
    }
  }
}

void RotateMino(){
  //Swap用のミノ格納配列
  int[][] tmp = new int[minoLenH][minoLenW];
  //Swap
  for(int i=0; i<minoLenH; i++){
    for(int j=0; j<minoLenW; j++){
      tmp[i][j] = minoShape[minoType][i][j];
    }
  }
 
  //ミノのデータを反映
  for(int i=0; i<minoLenH; i++){
    for(int j=0; j<minoLenW; j++){
      minoShape[minoType][i][j] = tmp[j][minoLenW-1-i];
    }
  }
  //回転した時干渉していたら書き直す
  if(IsHit(x, y)){
    for(int i=0; i<minoLenH; i++){
      for(int j=0; j<minoLenW; j++){
        minoShape[minoType][i][j] = tmp[i][j];
      }
    }
  }
}

void ResetMino(){
  x = 5;
  y = 0;
  minoType = int(random(0, minoShape.length));
}

boolean IsHit(int minoX, int minoY){
  for(int i=0; i<minoLenH; i++){
    for(int j=0; j<minoLenW; j++){
      //ミノの描画部分でなければ飛ばす
      if(minoShape[minoType][i][j] == 0)continue;
      //フィールド上のミノの場所が埋まっていたらtrue
      if((fieldData[minoY+i][minoX+j] != 0)) {
        return true;
      }
    }
  }
  return false;
}

//Developer Tool
void PrintMino(){
  for(int i=0; i<minoLenH; i++){
    for(int j=0; j<minoLenW; j++){
      print(minoShape[minoType][i][j]);
    }
    println();
  }
  println();
  
}

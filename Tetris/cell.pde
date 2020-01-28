class Cell{
  int x, y, w, h, type;
  
  Cell(int x, int y, int type){
    this.x = x;
    this.y = y;
    w = 40;
    h = 40;
    this.type = type;
  }
  
  void Draw(){
    switch(type){
      case 0: fill(255); stroke(0, 100); break;
      case 1: fill(100); stroke(0); break;
      case 2: fill(0, 0, 255); stroke(0); break;
      case 3: fill(0, 255, 0); stroke(0); break;
      case 4: fill(255, 0, 0); stroke(0); break;
      case 5: fill(255, 0, 255); stroke(0); break;
      case 6: fill(200, 100, 0); stroke(0); break;
      case 7: fill(0, 255, 255); stroke(0); break;
      case 99: fill(255, 255, 0); stroke(0); break;
    }
    rect(x, y, w, h);
  }
}

import UI.*;
import UI.App.*;
App app;
View MAIN_MENU;


Integer[] gray = {127};
Integer[] red = {255,0,0};
Integer[] green = {0,255,0};
Integer[] blue = {0,0,255};
Integer[][] colors;
int rows;
int columns;


Player empty, p1, p2, p3;
HashMap<Integer[], Player> players = new HashMap<Integer[], Player>();
HashMap<Player, Integer> points = new HashMap<Player, Integer>();

StateBoxGrid board;
Label SCORE;

void setup() {
  size(700, 500);
  frameRate(20);
  app = new App(this, true);
  MAIN_MENU = app.new View("Main menu");
  MAIN_MENU.add(app.new Button(new Two_Player(),"Two Player", 255, new Point(width/2-100, height/2-52), new Dimensions(200,50)));
  MAIN_MENU.add(app.new Button(new Three_Player(),"Three Player", 255, new Point(width/2-100, height/2 + 2), new Dimensions(200,50)));
  empty = new Player("Empty", gray);
}

void draw() {

}

void newGameOthello() {
  View OTHELLO_BOARD = app.new View("Othello");
  board = new StateBoxGrid(new Point(), new Dimensions(height,height), rows, columns); 
  OTHELLO_BOARD.add(board);
  SCORE = app.new Label(new Point(550, 150), "Hello");
  OTHELLO_BOARD.add(SCORE);
  OTHELLO_BOARD.add(app.new Button(app.new ChangeView(MAIN_MENU),"New Game", 255, new Point(502, 452), new Dimensions(196,46)));
  app.activate(OTHELLO_BOARD);
  updateScore();
  
}
class Two_Player extends New_Game {
  Two_Player() {
    super();
  }
  void execute() {
    super.execute();
    /*Two-player game*/
    rows = 8;
    columns = 8;
    colors = new Integer[3][3];
    colors[0] = gray;
    colors[1] = red;
    colors[2] = green;
    p1 = new Player("Red", red);
    p2 = new Player("Green", green);
    players.put(empty.getColor(), empty);
    players.put(p1.getColor(), p1);
    players.put(p2.getColor(), p2);
    points.put(empty, rows * columns);
    points.put(p1, 0);
    points.put(p2, 0);
    newGameOthello();
  }
}

class Reset extends AbstractCommand {
  Reset() {
    app.super();
  }
  void execute() {
    players.clear();
    points.clear();
  }
}

class New_Game extends AbstractCommand {
  Reset reset = new Reset();
  New_Game() {
    app.super();
  }
  void execute() {
    reset.execute();
  }
}
class Three_Player extends New_Game {
  
  Three_Player() {
    super();
  }
  void execute() {
    super.execute();
    /*3-player*/
    rows = 9;
    columns = 9;
    colors = new Integer[4][3];
    colors[0] = gray;
    colors[1] = red;
    colors[2] = green;
    colors[3] = blue;
    p1 = new Player("Red", red);
    p2 = new Player("Green", green);
    p3 = new Player("Blue", blue);
    players.put(empty.getColor(), empty);
    players.put(p1.getColor(), p1);
    players.put(p2.getColor(), p2);
    players.put(p3.getColor(), p3);
    points.put(empty, rows * columns);
    points.put(p1, 0);
    points.put(p2, 0);
    points.put(p3, 0);
    newGameOthello();
  }
}

void updateScore() {
  SCORE.name = "";
  for(Player player: points.keySet()) {
    SCORE.name += player.name + ": " + points.get(player) + "\n";
  }
}

class Player {
  String name;
  Integer[] idcolor;
  Player(String name, Integer[] idcolor) {
    this.name = name;
    this.idcolor = idcolor;
  }
  Integer[] getColor() {
    return this.idcolor;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
class StateBoxGrid extends Grid {
  StateBoxGrid(Point point, Dimensions dimensions, int x, int y) {
    app.super(point, dimensions, x, y);
    for(Container[] row: this.cells) {
      for(Container container: row) {
        container.add(new Cell(new Point(container.point), new Dimensions(container.dimensions), 
        colors
        ));
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////

public class Cell extends StateBox {
  public Cell(Point point, Dimensions dimensions, Integer[]... states) {
    app.super(point, dimensions, states);
  }
  public void onMouseRelease() {
    Player player = players.get(this.states[this.state]); 
    points.put(player, points.get(player) - 1);
    super.onMouseRelease();
    player = players.get(this.states[this.state]); 
    points.put(player, points.get(player) + 1);
    updateScore();
  }
}

import java.awt.Robot;
import java.awt.*;
import java.awt.event.InputEvent;
import java.awt.AWTException;
import com.onformative.leap.*;
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.Type;
import java.util.*;
import controlP5.*;
import http.requests.*;
import ddf.minim.*;

int x_ball, y_ball, x_direction, y_direction, x_paddle, y_paddle;
boolean pauze, gameOver, canPost, b_showScore, b_showHowTo, b_showSetting, playMusic;
int x_leap, y_leap;
int score;
int lives, mode, combo;
int level;
String name;
PImage img;
PImage bg;
JSONArray json;
Minim minim;
AudioPlayer backgroundsong;
AudioPlayer bounce;
AudioPlayer dead;
LeapMotionP5 leap;
ControlP5 cp5;
Robot robot = null;
int rows = 7; //Number of bricks per row
int columns = 7; //Number of columns
int total = rows * columns; //Total number of bricks
Brick[] box = new Brick[total];
 
void setup()
{
    size(800,500);

    background(255);
    playMusic = false;
    minim = new Minim(this);
    bounce = minim.loadFile("sound/bounce.mp3");
    dead = minim.loadFile("sound/dead.wav");
    backgroundsong = minim.loadFile("sound/backgroundsong.mp3");

    PFont pong = createFont("Arial", 20);
    leap = new LeapMotionP5(this);
    leap.enableGesture(Type.TYPE_SCREEN_TAP);
    try {
    	robot = new Robot();
    }catch(AWTException awt){
    	println("failed to load robot");
    }
    

    for (int i = 0; i < rows; i++){
    	for (int j = 0; j< columns; j++){
    	  box[i*rows + j] = new Brick((i+1) *width/(rows + 2), 20 + (j+1) * 30); //places all the bricks into the array, properly labelled.
    	}
    }


    cp5 = new ControlP5(this);

    cp5.setAutoDraw(false);

    cp5.setColorBackground(color(255,255,255));

    cp5.addTextfield("Name")
     .setPosition(width/2 - 100, height/2 - 50)
     .setSize(200,40)
     .setFont(pong)
     .setFocus(true)
     .setVisible(false)
     .setColor(color(255,0,0))
     ;

    cp5.addButton("KeyboardPress")
     .setValue(0)
     .setCaptionLabel("Keyboard")
     .setPosition(width/2 - 100,150)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

    cp5.addButton("MusicOnOff")
     .setValue(0)
     .setImages(loadImage("images/play.png"),loadImage("images/play.png"),loadImage("images/play.png"))
     .setPosition(width - 55,50)
     .updateSize();
     ;
     
     cp5.addButton("MousePress")
     .setValue(0) 
     .setCaptionLabel("Mouse")
     .setPosition(width/2 - 100,230)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

    cp5.addButton("PostHighscore")
     .setValue(0)
     .setCaptionLabel("Post highscore and continue")
     .setPosition(width/2 - 100, height/2 + 20)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("LeapPress")
     .setValue(0)
     .setCaptionLabel("Leap Motion")
     .setPosition(width/2 - 100,310)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("Settings")
     .setValue(0) 
     .setCaptionLabel("Choose Gamemode")
     .setPosition(width/2 - 100,150)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("Highscore")
     .setValue(0) 
     .setPosition(width/2 - 100,230)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("HowToPlay")
     .setValue(0) 
     .setCaptionLabel("How to play")
     .setPosition(width/2 - 100,310)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("Return")
     .setValue(0)
     .setPosition(15,50)
     .setSize(80,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.getController("Return")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("KeyboardPress")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("MousePress")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("LeapPress")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("Settings")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("Highscore")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("HowToPlay")
     .getCaptionLabel()
     .setFont(createFont("Arial", 15))
     .setColor(0)
     ;

     cp5.getController("PostHighscore")
     .getCaptionLabel()
     .setFont(createFont("Arial", 10))
     .setColor(0)
     ;


    //position of paddle
    x_paddle = 60;
    y_paddle = height-15;
   
    //direction of ball
    x_direction = -3;
    y_direction = -6;
   
    //position of ball
    x_ball = width/2;
    y_ball = height - 100;
   
    //score
    score = 0;
   
    //mode keyboard, mouse, leap motion
    mode = 0;

    //# lives
    lives = 3;

    level = 1;
   
    //combo streak
    combo = 0;

    canPost = true;

    img = loadImage("images/heart.png");
    bg = loadImage("images/bg.jpg");
   
    gameOver = false;
    pauze = true;
    b_showScore = false;
    b_showHowTo = false;
    b_showSetting = false;
}
 
void draw()
{
    image(bg, 0,0, 800, 500);
    if (score == level * total) {
    	for(int i = 0; i < total; i ++){
    		box[i].reset();
    	}
    	level++;
    }
    if (pauze) {
      cp5.getController("MusicOnOff").setVisible(true);
        if (b_showScore){
            showHighscore();
        }else if(b_showHowTo){
            showHowToPlay();
        }else if(b_showSetting){
            showSettings();
        }else{
            showPauze();
        }

        cp5.draw();

        PVector vingerPos = leap.getTip(leap.getFinger(0));
        fill(color(255, 0, 0));
        x_leap = (int)vingerPos.x;
        y_leap = (int)vingerPos.y;
        ellipse(x_leap, y_leap, 5, 5);
	}else{
    disableAllControls();
    cp5.getController("MusicOnOff").setVisible(false);
	    if (gameOver==false) {
	     	canPost = true;
     	play(mode);
	    }
      	if (gameOver==true) {     
            showGameOver();
      	}
        cp5.draw();
    }
}

void showGameOver(){
    textAlign(CENTER);
    textSize(40);
    text("Game Over", width/2, height/4);
    textSize(20);
    text("Enter name to continue!", width/2, height/4 + 40);
    
    cp5.getController("Name").setVisible(true);
    cp5.getController("PostHighscore").setVisible(true);
}

void showSettings(){
    stats();
    cp5.getController("Settings").setVisible(false);
    cp5.getController("Highscore").setVisible(false);
    cp5.getController("HowToPlay").setVisible(false);

    cp5.getController("KeyboardPress").setVisible(true);
    cp5.getController("MousePress").setVisible(true);
    cp5.getController("LeapPress").setVisible(true);
    cp5.getController("Return").setVisible(true);
}

void showHighscore(){
    stats();
    cp5.getController("Settings").setVisible(false);
    cp5.getController("Highscore").setVisible(false);
    cp5.getController("HowToPlay").setVisible(false);
    cp5.getController("KeyboardPress").setVisible(false);
    cp5.getController("MousePress").setVisible(false);
    cp5.getController("LeapPress").setVisible(false);
    cp5.getController("Return").setVisible(true);
    
    fill(255);
    rect(width/2 - 200, 60, 400, 396);

    textAlign(CENTER);
    textSize(25);
    fill(0);
    text("Highscore", width/2, 100);

    for (int i = 0; i < json.size(); i++){
        if (i%2 == 1) {
        fill(244);
        rect(width/2-200, 80+34*i, 400, 34);
    }
    }
    for (int i = 0; i < json.size(); i++) {
    JSONObject item = json.getJSONObject(i); 
    String name = item.getString("Name");
    Integer score = item.getInt("Score");

    fill(0);
    textSize(20);
    textAlign(LEFT);
    text(name + ":", width/2 - 180, 140+34*i);
    textAlign(RIGHT);
    text(score, width/2 + 180, 140+34*i);
  }
}

void showPauze(){
    stats();
    cp5.getController("Settings").setVisible(true);
    cp5.getController("Highscore").setVisible(true);
    cp5.getController("HowToPlay").setVisible(true);

    cp5.getController("KeyboardPress").setVisible(false);
    cp5.getController("MousePress").setVisible(false);
    cp5.getController("LeapPress").setVisible(false);
    cp5.getController("Return").setVisible(false);
}

void showHowToPlay() {
    stats();
    cp5.getController("Settings").setVisible(false);
    cp5.getController("Highscore").setVisible(false);
    cp5.getController("HowToPlay").setVisible(false);
    cp5.getController("KeyboardPress").setVisible(false);
    cp5.getController("MousePress").setVisible(false);
    cp5.getController("LeapPress").setVisible(false);
    cp5.getController("Return").setVisible(true);

    fill(255);
    rect(width/2 - 200, 60, 400, 396);
    fill(0);
    textSize(25);
    text("How To Play", width/2, 100);
    textSize(15);
    textAlign(LEFT);
    text("Open and close menu by pressing spacebar", width/2 - 180, 150);
    text("You can choose out of 3 gamemodes:", width/2 - 180, 180);
    text("Control with Mouse", width/2 - 160, 200);
    text("Control with Keyboard", width/2 - 160, 220);
    text("Control with Leap Motion", width/2 - 160, 240);
    text("'Leap Motion mode' requires actual Leap", width/2 - 180, 270);
    text("Motion device", width/2 - 180, 290);
    text("After combo score of 20, you receive", width/2 - 180, 310);
    text("an extra life", width/2 - 180, 330);
    text("Break all the bricks to get to the", width/2 - 180, 370);
    text("next level", width/2 - 180, 390);
}

void disableAllControls(){
	stats();
	cp5.getController("Settings").setVisible(false);
    cp5.getController("Highscore").setVisible(false);
    cp5.getController("HowToPlay").setVisible(false);
    cp5.getController("KeyboardPress").setVisible(false);
    cp5.getController("MousePress").setVisible(false);
    cp5.getController("LeapPress").setVisible(false);
    cp5.getController("Return").setVisible(false);
}

void changeMode(){
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("Please select Game Mode", width/2, 100);
    cp5.getController("Settings").setVisible(false);
    cp5.getController("Highscore").setVisible(false);
    cp5.getController("HowToPlay").setVisible(false);
    cp5.getController("KeyboardPress").setVisible(true);
    cp5.getController("MousePress").setVisible(true);
    cp5.getController("LeapPress").setVisible(true);
}
 
 
void reset() {
    x_direction = -3;
    y_direction = -6;
    x_ball = width/2;
    y_ball = height - 100;
    score = 0;
    combo = 0;
    lives = 3;
    level = 1;
    gameOver = false;
    for(int i = 0; i < total; i ++){
        box[i].reset();
    }

}
 
void drawContent()
{
    smooth();
    fill(13,51,102);
 
 	//draw the paddle
    rect(x_paddle,y_paddle,80,5);
 
 	//draw the ball
    ellipse(x_ball,y_ball,10,10);
}
 
void moveWithKeyboard()
{
    if(keyPressed) {
        if(keyCode == LEFT && x_paddle > 0) {
            x_paddle -= 10;
        }
   
        if(keyCode == RIGHT && x_paddle < (width - 80)) {
            x_paddle+= 10;
        }
    }
}
 
void moveWithMouse()
{  
    x_paddle = mouseX - 40;
   
    if(x_paddle < 0) {
        x_paddle = 0;
    }
   
    if(x_paddle > (width - 80)) {
        x_paddle = (width - 80);
    }
}

void moveWithLeapMotion(){
	PVector vingerPos = leap.getTip(leap.getFinger(0));
	x_paddle = (int)vingerPos.x - 40;

	if(x_paddle < 0) {
        x_paddle = 0;
    }
   
    if(x_paddle > (width - 80)) {
        x_paddle = (width - 80);
    }
}
 
 
void bounceBall()
{
    // bounce right wall
    if (x_ball >= (width-5))
    {
        x_direction = -x_direction;
    }
   
    //bounce left wall
    if (x_ball <= 5)
    {
        x_direction = -x_direction;
    }

    //bounce on paddle top
    //if y collides and x is between paddle left and right
    if (y_ball>=(y_paddle-5) && y_ball<=(y_paddle+5) && x_ball >= x_paddle && x_ball<=(x_paddle+85) && y_direction > 0)
    {
        int i = x_ball - (x_paddle + 42);
        int temp = i/5;
        if(temp != 0){
          x_direction = temp * level;
        }
        if(playMusic){
        bounce.play();
        bounce.rewind();
        }
        y_direction = -y_direction;
        combo++;
    }
   
    //bounce roof
    if (y_ball <= 35)
    {
        y_direction = -y_direction;
    }
   
    //bounce floor
    if (y_ball >= (height - 10))
    {
        if(playMusic){
          dead.play();
          dead.rewind();
        }
        if(lives > 0)
        {
            fill(color(255,0,0));
            rect(0, 497, width, 3);
            y_direction = -y_direction;
            lives--;
            combo = 0;
        }
        if(lives == 0)
        {
            gameOver = true;
        }
    }

    for (int i = 0; i < total; i ++)
      {
        //If ball hits bottom of brick, ball moves down, increment score
        if (y_ball - 5 <= box[i].y + box[i].h &&  y_ball - 5 >= box[i].y && x_ball >= box[i].x && x_ball <= box[i].x + box[i].w  && box[i].hit == false )
        {
        	y_direction = -y_direction;
          	box[i].gotHit();
          	score ++;
          	if(playMusic){
        		bounce.play();
        		bounce.rewind();
        	}
        }
     
        //If ball hits top of brick ball moves up, increment score
        if (y_ball + 5 >= box[i].y && y_ball - 5 <= box[i].y + box[i].h/2 && x_ball >= box[i].x && x_ball <= box[i].x + box[i].w && box[i].hit == false )
        {
          y_direction = -y_direction;
          box[i].gotHit();
          score ++;
          if(playMusic){
        		bounce.play();
        		bounce.rewind();
        	}
        }
     
        //if ball hits the left of the brick, ball switches to the right, and moves in same direction, increment score
        if (x_ball + 5 >= box[i].x && x_ball + 5 <= box[i].x + box[i].w / 2 && y_ball >= box[i].y && y_ball <= box[i].y + box[i].h  && box[i].hit == false)
        {
          x_direction = - x_direction;
          box[i].gotHit();
          score ++;
          if(playMusic){
        		bounce.play();
        		bounce.rewind();
        	}
        }
     
        //if ball hits the right of the brick, ball switches to the left, and moves in same direction, increment score
        if (x_ball - 5 <= box[i].x + box[i].w && x_ball + 5 >= box[i].x + box[i].w / 2 && y_ball >= box[i].y && y_ball <= box[i].y + box[i].h  && box[i].hit == false)
        {
          x_direction = - x_direction;
          box[i].gotHit();
          score ++;
          if(playMusic){
        		bounce.play();
        		bounce.rewind();
        	}
        }
    }
}
 
void play(int mode)
{
	for (int i = 0; i<total; i++){
    	box[i].update();
  	}

	//move ball
    x_ball = x_ball + x_direction;
    y_ball = y_ball + y_direction;

	switch (mode) {
		case 1:
			moveWithLeapMotion();
			break;
		case 2:
			moveWithKeyboard();
			break;
		case 3:
			moveWithMouse();
			break;	
		
	}
    bounceBall();
    drawContent();
   
    //regain live with 20 score
    if(combo == 20) {
        lives++;
        if (lives > 3) {
            lives = 3;
        }
        combo = 0;
    }
    fill(0, 128, 255);
    stats();
}
 
void stats() {
	//white rect
    fill(255);
    noStroke();
    rect(0,0,width, 35);
    fill(13,51,102);
    textAlign(LEFT);
    textSize(10);
    text("Combo :  ",10,15);
    text(combo,95,15);
    text("Level :  ",10,28);
    text(level,95,28);
    textAlign(CENTER);
    textSize(30);
    text(score, width/2, 30);
    textSize(20);
    //toon hartjes ipv getal
    for (int i = 0; i < lives; i++) {
    	image(img, (width - 30 - 30*i), 10, 20, 20);
    }
}
 
void keyPressed()
{
	//pauze
    if(keyCode == 32 && gameOver == false && mode != 0)
    {
        if (b_showScore == true) {
            b_showScore = false;
        }
        if (b_showSetting == true) {
            b_showSetting = false;
        }
        if (b_showHowTo == true) {
            b_showHowTo = false;
        }
        pauze = !pauze;
    }
}

void screenTapGestureRecognized(ScreenTapGesture gesture){
    if(gameOver == false && mode != 0 && pauze == false){
        if (b_showScore == true) {
            b_showScore = false;
        }
        if (b_showSetting == true) {
            b_showSetting = false;
        }
        if (b_showHowTo == true) {
            b_showHowTo = false;
        }
        pauze = !pauze;
    }else if(robot != null) {
        PointerInfo a = MouseInfo.getPointerInfo();
        Point b  = a.getLocation();
        int x = (int)b.getX();
        int y = (int)b.getY();
    	robot.mouseMove(frame.getLocation().x + x_leap,frame.getLocation().y + y_leap);    
    	robot.mousePress(InputEvent.BUTTON1_MASK);
    	robot.mouseRelease(InputEvent.BUTTON1_MASK);
        robot.mouseMove(x,y); 
    }
}

public void KeyboardPress(int theValue) {
    mode = 2;
    pauze = false;
    b_showSetting = false;
}

public void PostHighscore(int theValue) {
    if(cp5.get(Textfield.class,"Name").getText() != "" & score != 0){
      GetRequest get = new GetRequest("http://student.howest.be/arn.vanhoutte/newmedia/post.php?name=" + cp5.get(Textfield.class,"Name").getText() + "&score=" + score);
      get.send();
    
    }
    cp5.getController("Name").setVisible(false);
    cp5.getController("PostHighscore").setVisible(false);
    reset();
}

public void MousePress(int theValue) {
    mode = 3;
    pauze = false;
    b_showSetting = false;
}

public void LeapPress(int theValue) {
    mode = 1;
    pauze = false;
    b_showSetting = false;
}

public void Settings(int theValue) {
    b_showSetting = true;
}

public void Highscore(int theValue) {
    b_showScore = true;
    json = loadJSONArray("http://student.howest.be/arn.vanhoutte/newmedia/get.php");
}
public void MusicOnOff(int theValue) {
    playMusic = !playMusic;
    if(playMusic){
      cp5.getController("MusicOnOff").setImages(loadImage("images/play.png"),loadImage("images/play.png"),loadImage("images/play.png"));
      backgroundsong.loop();  
    }else{
    cp5.getController("MusicOnOff").setImages(loadImage("images/mute.png"),loadImage("images/mute.png"),loadImage("images/mute.png"));
      backgroundsong.pause();  
    }
}

public void HowToPlay() {
    b_showHowTo = true;
}

public void Return() {
    b_showScore = false;
    b_showSetting = false;
    b_showHowTo = false;
}

class Brick
{
  float x; //brick x
  float y; //brick y
  float w; //brick width
  float h; //brich height
  float r; //brick red val
  float g; //grick green val
  float b; //brick blue val
 
  boolean hit; //whether or not the brick has been hit
 
 
    Brick(float x0, float y0)
  {
    x = x0;
    y = y0;
 
    //pastel colors
    r = random(128, 255);
    g = random(128, 255);
    b = random(128, 255);
    w = 50; //brick width
    h = 15; //brick height
 
    hit = false; //brick is initially not hit
  }
 
  //Draws the brick
  void update()
  {
  	if (hit) {
  		
  	}else{
		noStroke();
    	fill(r, g, b);
    	rect(x, y, w, h);
  	}
  }
 
  //What happens to the brick once it gets hit
  void gotHit()
  {
   	hit = true;
  }

  void reset(){
  	hit = false;
  	r = random(128, 255);
    g = random(128, 255);
    b = random(128, 255);
  }
}
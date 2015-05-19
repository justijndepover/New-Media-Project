import com.onformative.leap.*;
import com.leapmotion.leap.*;
import com.leapmotion.leap.Gesture.Type;
import java.util.*;
import controlP5.*;
import http.requests.*;

int x_ball, y_ball, x_direction, y_direction, x_paddle, y_paddle;
boolean pauze, gameOver;
int score;
int lives, mode, combo;
String name;
PImage img;
PImage bg;
JSONArray json;
LeapMotionP5 leap;
ControlP5 cp5;
ListBox l;
 
void setup()
{
    size(800,500);
    background(255);
    PFont pong = createFont("Arial", 20);
    leap = new LeapMotionP5(this);
    leap.enableGesture(Type.TYPE_SCREEN_TAP);
    cp5 = new ControlP5(this);

    cp5.setColorBackground(color(255,255,255));


    cp5.addButton("KeyboardPress")
     .setValue(0)
     .setCaptionLabel("Keyboard")
     .setPosition(width/2 - 100,150)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("MousePress")
     .setValue(0) 
     .setCaptionLabel("Mouse")
     .setPosition(width/2 - 100,230)
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
     .setPosition(width/2 - 100,180)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;

     cp5.addButton("Highscore")
     .setValue(0) 
     .setPosition(width/2 - 100,260)
     .setSize(200,40)
     .setVisible(false)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
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

    ControlP5.printPublicMethodsFor(ListBox.class);

    l = cp5.addListBox("myList")
           .setPosition(width/2 - 100,230)
           .setVisible(false)
           .setSize(120, 120)
           .setItemHeight(15)
           .setBarHeight(15)
           .setColorForeground(color(255, 100,0))
           ;
  
    l.captionLabel().toUpperCase(true);
    l.captionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    l.captionLabel().setFont(createFont("Arial", 15));
    l.captionLabel().set("Topscores");
    l.captionLabel().style().marginTop = 3;
    l.valueLabel().style().marginTop = 3;


    //position of paddle
    x_paddle = 60;
    y_paddle = height-115;
   
    //direction of ball
    x_direction = -3;
    y_direction = -6;
   
    //position of ball
    x_ball = width/2;
    y_ball = height/2;
   
    //score
    score = 0;
   
    //mode keyboard, mouse, leap motion
    mode = 0;

    //# lives
    lives = 3;
   
    //combo streak
    combo = 0;

    img = loadImage("images/heart.png");
    bg = loadImage("images/bg.jpg");
   
    gameOver = false;
    pauze = false;
}
 
void draw()
{
    image(bg, 0,0, 800, 500);

    if (mode == 0) {
        stats();
        changeMode();
    }else if (mode == 4)
    {
      
            cp5.getController("Settings").setVisible(false);
            cp5.getController("Highscore").setVisible(false);
            l.setVisible(true);
    }
    else{
	    if (pauze) {
	    	//toon controls
            stats();
            cp5.getController("Settings").setVisible(true);
            cp5.getController("Highscore").setVisible(true);
	    }else{
            cp5.getController("KeyboardPress").setVisible(false);
            cp5.getController("MousePress").setVisible(false);
            cp5.getController("LeapPress").setVisible(false);
  	        if (gameOver==false) {
             	play(mode);
  	        }
  	        if (gameOver==true) {
  	      	    stats();
                textAlign(CENTER);
                textSize(40);
             	text("Game Over", width/2, height/2);
                textSize(20);
                text("Press mouse to continue!", width/2, height/2 + 40);
                if(score!=0){
                  PostScore();
                }
             	if(mousePressed) {
               		reset();
             	}
  	        }
        }
    }
}

void changeMode(){
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("Please select Game Mode", width/2, 100);
    cp5.getController("Settings").setVisible(false);
    cp5.getController("Highscore").setVisible(false);
    cp5.getController("KeyboardPress").setVisible(true);
    cp5.getController("MousePress").setVisible(true);
    cp5.getController("LeapPress").setVisible(true);
}
 
 
void reset() {
    x_direction = -3;
    y_direction = -6;
    x_ball = width/2;
    y_ball = width/2;
    score = 0;
    combo = 0;
    lives = 3;
    gameOver = false;
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
            x_paddle -= 5;
        }
   
        if(keyCode == RIGHT && x_paddle < (width - 80)) {
            x_paddle+= 5;
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
    if (x_ball > (width-5))
    {
        x_direction = -x_direction;
    }
   
    //bounce left wall
    if (x_ball < 5)
    {
        x_direction = -x_direction;
    }

    //bounce on paddle top
    //if y collides and x is between paddle left and right
    if (y_ball>(y_paddle-5) && x_ball > x_paddle && x_ball<(x_paddle+85))
    {
        y_direction = -y_direction;
        score++;
        combo++;
    }
   
    //bounce roof
    if (y_ball < 35)
    {
        y_direction = -y_direction;
    }
   
    //bounce floor
    if (y_ball > (height - 10))
    {
        if(lives > 0)
        {
            y_direction = -y_direction;
            lives--;
            combo = 0;
        }
        if(lives == 0)
        {
            gameOver = true;
        }
    }
}
 
void play(int mode)
{
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
    textSize(20);
    text("Combo :  ",10,25);
    text(combo,95,25);
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
        pauze = !pauze;
    }  
}

void screenTapGestureRecognized(ScreenTapGesture gesture){
    if(gameOver == false && mode != 0)
    {
        pauze = !pauze;
    } 
}

public void KeyboardPress(int theValue) {
    mode = 2;
}

public void MousePress(int theValue) {
    mode = 3;
}

public void LeapPress(int theValue) {
    mode = 1;
}

public void Settings(int theValue) {
    mode = 0;
    pauze = !pauze;
    println(pauze);
}
public void Highscore(int theValue) {
    mode = 4;
    println(pauze);
    json = loadJSONArray("http://student.howest.be/arn.vanhoutte/newmedia/get.php");
    for (int i = 0; i < json.size(); i++) {
    
    JSONObject item = json.getJSONObject(i); 

    String name = item.getString("Name");
    Integer score = item.getInt("Score");
    ListBoxItem lbi = l.addItem(name + " " + score, i);
  }
}
void PostScore(){
    GetRequest get = new GetRequest("http://student.howest.be/arn.vanhoutte/newmedia/post.php?name=" + name + "&score=" + score);
    get.send();
}

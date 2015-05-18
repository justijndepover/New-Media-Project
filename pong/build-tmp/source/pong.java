import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.onformative.leap.*; 
import com.leapmotion.leap.*; 
import com.leapmotion.leap.Gesture.Type; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pong extends PApplet {





int x_ball, y_ball, x_direction, y_direction, x_paddle, y_paddle;
boolean pauze, gameOver;
int score, score2;
int lives, mode, bonus;
PImage img;
PImage bg;
LeapMotionP5 leap;
 
public void setup()
{
    size(800,500);
    background(255);
    leap = new LeapMotionP5(this);
    leap.enableGesture(Type.TYPE_SCREEN_TAP);

    //position of paddle
    x_paddle = 60;
    y_paddle = height-15;
   
    //direction of ball
    x_direction = -3;
    y_direction = -6;
   
    //position of ball
    x_ball = width/2;
    y_ball = height/2;
   
    //score, bonusscore
    score = 0;
    score2 = 0;
   
    //mode keyboard, mouse, leap motion
    mode = 1;

    //# lives
    lives = 3;
   
    bonus = 0;

    img = loadImage("images/heart.png");
    bg = loadImage("images/bg.jpg");
   
    gameOver = true;
   
    PFont pong = createFont("Arial", 20);

}
 
public void draw()
{
    image(bg, 0,0, 800, 500);
    if (mode == 0) {
        stats();
        changeMode();
    }else{
	    if (pauze) {
	    	//toon controls
	    }else{
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
             	if(mousePressed) {
               		reset();
             	}
  	        }
        }
    }
}

public void changeMode(){

}
 
 
public void reset() {
    x_direction = -3;
    y_direction = -6;
    x_ball = width/2;
    y_ball = width/2;
    score = 0;
    bonus = 0;
    lives = 3;
    gameOver = false;
}
 
public void ChooseMode() {
	if(key == 'l'){
		mode = 1;
		play(mode);
	}
    if(key == 'k'){
        mode = 2;
        play(mode);
    }
    if(key == 'm'){
        mode = 3;
        play(mode);
    }
    if(mode == 0){
        fill(0, 128, 255);
        stats();
        text("K for keyboard mode  / M for mouse mode",width/2 - 130,height/2);
    }
}
 
public void drawContent()
{
    smooth();
    fill(13,51,102);
 
 	//draw the plateau
    rect(x_paddle,y_paddle,80,5);
 
 	//draw the ball
    ellipse(x_ball,y_ball,10,10);
}
 
public void moveWithKeyboard()
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
 
public void moveWithMouse()
{  
    x_paddle = mouseX - 40;
   
    if(x_paddle < 0) {
        x_paddle = 0;
    }
   
    if(x_paddle > (width - 80)) {
        x_paddle = (width - 80);
    }
}

public void moveWithLeapMotion(){
	//leap motion blablabla
	PVector vingerPos = leap.getTip(leap.getFinger(0));
	x_paddle = (int)vingerPos.x - 40;

	if(x_paddle < 0) {
        x_paddle = 0;
    }
   
    if(x_paddle > (width - 80)) {
        x_paddle = (width - 80);
    }
}
 
 
public void bounceBall()
{
    // bounce right
    if (x_ball > (width-5) && x_direction > 0)
    {
        x_direction = -x_direction;
    }
   
    //bounce left
    if (x_ball < 5)
    {
        x_direction = -x_direction;
    }
    //bounce on plateau
    if (y_ball>(y_paddle-5) && x_ball > x_paddle && x_ball<(x_paddle+85))
    {
        y_direction = -y_direction;
        score++;
        bonus++;
    }
    // bounce floor
    if (y_ball>(y_paddle+10) && x_ball > x_paddle && x_ball<(x_paddle+85))
    {
        y_direction = -y_direction;
        score++;
        bonus++;
    }
   
   
    //bounce roof
    if (y_ball < 50)
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
            bonus = 0;
        }
        if(lives == 0)
        {
            gameOver = true;
        }
    }
}
 
public void play(int mode)
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
    if(score > score2+19 && bonus == 20) {
        lives++;
        bonus = 0;
        score2 = score;
    }
    fill(0, 128, 255);
    stats();
}
 
public void stats() {
	//white rect
    fill(255);
    noStroke();
    rect(0,0,width, 35);
    fill(13,51,102);
    textAlign(LEFT);
    text("Combo :  ",10,25);
    text(bonus,90,25);
    textAlign(CENTER);
    textSize(30);
    text(score, width/2, 30);
    textSize(20);
    //toon hartjes ipv getal
    for (int i = 0; i < lives; i++) {
    	image(img, (width - 30 - 30*i), 10, 20, 20);
    }
}
 
public void keyPressed()
{
	//pauze
    if(keyCode == 32 && gameOver == false && mode != 0)
    {
        pauze = !pauze;
    }  
}

public void screenTapGestureRecognized(ScreenTapGesture gesture){
    if(gameOver == false && mode != 0)
    {
        pauze = !pauze;
    } 
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "pong" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

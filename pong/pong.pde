import com.onformative.leap.*;
import com.leapmotion.leap.*;
import java.util.*;
int x_ball, y_ball, x_direction, y_direction, x_paddle, y_paddle;
boolean pauze, continueGame;
int score, score2;
int lives, mode, bonus;
PImage img;
LeapMotionP5 leap;
 
void setup()
{
    size(800,500);
    background(255);
    leap = new LeapMotionP5(this);

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
    mode = 3;

    //# lives
    lives = 3;
   
    bonus = 0;

    img = loadImage("images/heart.png");
   
    //gameover == continueGame = false
    continueGame = true;
   
    PFont pong = createFont("Arial", 20);

}
 
void draw()
{
	if (pauze) {
		//doe niets
	}else{
	background(200);
  	    if (continueGame==true) {
        	//ChooseMode();
        	play(1);
  	    }
  	    if (continueGame==false) {
  	    	stats();
        	text("Press mouse to continue", width/2 + 50, height/2);
        	if(mousePressed) {
          		reset();
        	}
  	    }
    }
}
 
 
void reset() {
    background(255);
    x_direction = -3;
    y_direction = -6;
    x_ball = width/2;
    y_ball = width/2;
    score = 0;
    bonus = 0;
    lives = 3;
    continueGame = true;
}
 
void ChooseMode() {
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
 
void drawContent()
{
    smooth();
    fill(13,51,102);
 
 	//draw the plateau
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
	//leap motion blablabla
	PVector vingerPos = leap.getTip(leap.getFinger(0));
	x_paddle = (int)vingerPos.x - 40;
	println(x_paddle);
}
 
 
void bounceBall()
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
            continueGame = false;
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
    if(score > score2+19 && bonus == 20) {
        lives++;
        bonus = 0;
        score2 = score;
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
    text("Bonus :  ",50,25);
    text(bonus,110,25);
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
    if(keyCode == 32 && continueGame == true && mode != 0)
    {
        pauze = !pauze;
    }  
}


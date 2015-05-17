int x_ball, y_ball, x_direction, y_direction, x_plateau, y_plateau;
boolean pauze, continueGame;
int score, score2;
int lives, mode, bonus;
 
void setup()
{
    size(500,500);
    background(255);

    //position of plateau
    x_plateau = 60;
    y_plateau = height-15;
   
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
    mode = 0;

    //# lives
    lives = 3;
   
    bonus = 0;
   
    //gameover == continueGame = false
    continueGame = true;
   
    PFont pong = createFont("Arial", 20);

}
 
void draw()
{
	background(255);
  	if (continueGame==true) {
    	//ChooseMode();
    	play(2);
  	}
  	if (continueGame==false) {
  		stats();
    	text("Press mouse to continue", width/2 + 50, height/2);
    	if(mousePressed) {
      		reset();
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
    fill(228,27,241);
    stroke(228,27,241);
 
 	//draw the plateau
    rect(x_plateau,y_plateau,80,5);
 
 	//draw the ball
    ellipse(x_ball,y_ball,10,10);
}
 
void moveWithKeyboard()
{
    if(keyPressed) {
        if(keyCode == LEFT && x_plateau > 0) {
            x_plateau -= 5;
        }
   
        if(keyCode == RIGHT && x_plateau < (width - 80)) {
            x_plateau+= 5;
        }
    }
}
 
void moveWithMouse()
{  
    x_plateau = mouseX - 40;
   
    if(x_plateau < 0) {
        x_plateau = 0;
    }
   
    if(x_plateau > (width - 80)) {
        x_plateau = (width - 80);
    }
}

void moveWithLeapMotion(){
	//leap motion blablabla
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
    if (y_ball>(y_plateau-5) && x_ball > x_plateau && x_ball<(x_plateau+85))
    {
        y_direction = -y_direction;
        score++;
        bonus++;
    }
    // bounce floor
    if (y_ball>(y_plateau+10) && x_ball > x_plateau && x_ball<(x_plateau+85))
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
	//blauw
    stroke(0,128,255);
    line(0,40,width,40);
    text("Bonus :  ",50,20);
    text(bonus,110,20);
    text("PONG", 175,20);
    text("Score : ", 160, 35);
    text(score, 225, 35);
    text("Lives : ", 300,20);
    text(lives,350,20);
}
 
void keyPressed()
{
	//pauze
    if(keyCode == ENTER && continueGame == true && mode != 0)
    {
        pauze = !pauze;
        if (pauze) {
            text("PAUSE", 150,200);
            noLoop();
        }
        else {
            loop();
        }
    }  
}


/*
HW6
ECS12 Project
*/
/**************INITIALIZE GLOBAL VARS*******************************/
int GameScore = 0;
PImage bird;
PImage land;
float bird_x = 70;
float bird_y = 250;
float rect_x = 470;
float rect_y_top = 0;
float rect_y_bottom = 0;
float rect_width = 0;
float rect_length = 0;
float screen_limit = 0;
boolean random_flag = true;
boolean game_flag = true;
float rotation_offset = 0;
float play = 0;
boolean bird_flag_up = false;
float bird_offset = 0;
// new variable
boolean game_started = false;
float gravity = 2;
float up_value = 30;
float block_range = 100;
float speed = 3;
int rot_down = -30;
float refresh = -30;
/**************INITIALIZE GLOBAL VARS END***************************/

/**************FUNCTION NAMES********************************
void setup()
void draw()
void game()
void drawBlocks()
void randomBlockPosition()
void mouseClicked()
void mouseReleased()
void checkCollision()
void gameOver()
void mouseDragged()
/**************FUNCTION NAMES END***************************/


void setup()
{
 background(255);
 size(500,500); 
 
 /*I DO NOT TAKE CREDIT FOR THE CREATION OF PHOTOS, WERE FOUND ON THE INTERNET*/
 bird = loadImage("bird.png");//load image into object bird
 land = loadImage("bg.png");//load background image to flappy bird
 
 /*RESIZE IMAGES TO FIT*/
 bird.resize(60,60);//resize to size that I desire
 land.resize(500,500);
}

void draw()
{
  background(255);
  if(game_flag)//true by default, when hit block will be false
  {
    game();
   // game_flag = false;
  }
}

void start_over()
{
  fill(255);
  strokeWeight(2);
  rect(130, 150, 250, 150, 7);
  fill(0);
  textSize(50);
  text("Press Up\nTo Start", 150, 200);
  pushMatrix();
  imageMode(CENTER);
  translate(250, 400);
  scale(4);
  rotate(radians(frameCount*5));
  image(bird, 0, 0);
  popMatrix();
  // reset all value
  play = 0;
  GameScore = 0;
  bird_x = 70;
  bird_y = 250;
  rect_x = 470;
}

void game()
{//THINGS TO DO: Create a start feature and a flag that doesn't start the blocks moving until the player starts. 
  
  // **set the land background **
  imageMode(CORNER);
  image(land,0,0);
  
  /*Print Current User Score*/
  fill(0);
  textSize(32);
  text(GameScore,50,50);
  
  if(bird_flag_up) {
    pushMatrix();// save drawing state
    imageMode(CENTER);
    translate(bird_x,bird_y);
    rotate(radians(rot_down));
    image(bird,0,0);
    popMatrix();//restore to original drawing state
  }// bird up
    
  if(!bird_flag_up) {
    if(rot_down < 40)
      rot_down+=2;
    pushMatrix();
    imageMode(CENTER);
    translate(bird_x,bird_y);
    rotate(radians(rot_down));
    image(bird,0,0); // place bird into default position in the beginning of the game. 
    popMatrix();
  }// bird down
  
  /* difficulties */
  if(play < 1){
    speed = 3;
    block_range = 100;
  }
  else if(play < 5){
    speed = 3;
    block_range = 70;
  }
  else{
    speed = 3;
    block_range = 50;
  }
  
  if(play < 50)
  {//could later be used for lives
    print("x = "+ rect_x + "\n");
    if(rect_x >= refresh+1)
    {
      if(random_flag)
      {
        randomBlockPosition();
        random_flag = false;
      }
    
      if(rect_x >= refresh+1)
      {//action function 
        pushMatrix();
        drawBlocks();
        popMatrix();
        
        if(game_started){
          rect_x -= speed; //moves block at rate of 3 pixels per iteration to the left
          bird_y += gravity;//acts like gravity
        }// start action 
        else{
          start_over();
        }// stop action
        
       // print("x = "+ rect_x);
        checkCollision(); // calls function to determine if at current location the bird has collided with any of the blocks
      }
      
      if(rect_x <= refresh)
      {
        print("sup");
        play++;
        random_flag = true;
        rect_x = 470;// reset block to beginning position
        GameScore++;//increment game score
      }
      
    }//if rect x > -29
  }// play > 0
  
}// game

void drawBlocks()
{
  fill(0,255,0);
  
    rect(rect_x, 0, 30, rect_y_top, 0,0, 7,7);
    rect(rect_x, 500, 30, rect_y_bottom, 7,7, 0,0);
    bird_offset = 500 + rect_y_bottom;
  //println("bird_y: " + bird_y +  " bird_offset: " + bird_offset + "  rect_y_bottom: " + rect_y_bottom);
  
  //ORIGINAL RECTS*************
  //rect(rect_x, 0, 30, 190);
  //rect(rect_x, 500, 30, 190);
}

void randomBlockPosition()
{
    rect_y_top = random(200, 350);
    rect_y_bottom = -(height - rect_y_top - block_range);
  //rect_y_bottom = random(-200, -100); // THIS IS A PROBLEM, need to rotate. 
}

/* If user clicks a mouse and game is in session then move the bird up */
void mouseClicked()
{
  bird_y+= -30;
  bird_flag_up = true; //will make game() draw bird going up
}

void keyPressed()
{//if user presses user key up, the bird will fly up
  if(key == CODED)//detect special character
  {
    if(keyCode == UP)
    {//detect special character, arrow up
      bird_y -= up_value;
      bird_flag_up = true; //will make game() draw bird going up
      game_started = true;
      rot_down = -30;
    }
  }  
}

void keyReleased()
{//if user presses user key up, the bird will fly up
  if(key == CODED)//detect special character
    if(keyCode == UP)
      bird_flag_up = false; 
}

void mouseReleased()
{//bird will now start going down
 // bird_flag_up = false; //will make game() draw bird going down
}

/*This Function will check when called if the bird collided with the squares*/
void checkCollision()
{
  if( (bird_x >= rect_x && rect_x+30 >= bird_x) && ( (bird_y <= rect_y_top) || (bird_y >= bird_offset) ) )
  {//PROBLEM EXISTS BECAUSE LOWER BLOCK IS NOT ROTATED RIGHT AND WE CANT DETECT IT
        textSize(32);
        text("HIT", 100, 100);
        game_started = false;
        gameOver();
  }
}

/*This Function will be called when a user loses the game*/
void gameOver()
{
    background(255);//make the background white
    drawBlocks();
    fill(255,0,0);
    textSize(32);
    text("Game Over!!!",50,50);

    start_over(); 
    // reset block when game over
    rect_y_top = random(100, 230);
    rect_y_bottom = random(-200, -100);
}
class Floater //Do NOT modify the Floater class! Make changes in the Spaceship class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myXspeed, myYspeed; //holds the speed of travel in the x and y directions   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myXspeed += ((dAmount) * Math.cos(dRadians));    
    myYspeed += ((dAmount) * Math.sin(dRadians));       
  }   
  public void turn (double degreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=degreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myXspeed and myYspeed       
    myCenterX += myXspeed;    
    myCenterY += myYspeed;     

    //wrap around screen    
    //if(myCenterX >width)
    //{     
    //  myCenterX = 0;    
    //}    
    //else if (myCenterX<0)
    //{     
    //  myCenterX = width;    
    //}    
    //if(myCenterY >height)
    //{    
    //  myCenterY = 0;    
    //} 
    
    //else if (myCenterY < 0)
    //{     
    //  myCenterY = height;    
    //}   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    
    //translate the (x,y) center of the ship to the correct position
    translate((float)myCenterX, (float)myCenterY);

    //convert degrees to radians for rotate()     
    float dRadians = (float)(myPointDirection*(Math.PI/180));
    
    //rotate so that the polygon will be drawn in the correct direction
    rotate(dRadians);
    
    //draw the polygon
    beginShape();
    for (int nI = 0; nI < corners; nI++)
    {
      vertex(xCorners[nI], yCorners[nI]);
    }
    endShape(CLOSE);

    //"unrotate" and "untranslate" in reverse order
    rotate(-1*dRadians);
    translate(-1*(float)myCenterX, -1*(float)myCenterY);
  }   
} 

class Spaceship extends Floater {
  protected boolean follower;
  Spaceship(int x, int y, boolean followee) {
    myColor = color(255, 255, 255);
    myCenterX=x;
    myCenterY=y;
    myXspeed=0;
    myYspeed=0;
    myPointDirection=-90;
    follower=followee;
  }

  public void show() {
    myPointDirection=myPointDirection%360;
    fill(myColor);
    pushMatrix();
    translate((float)myCenterX, (float)myCenterY);
    rotate((float)myPointDirection*(3.1415/180));
    noStroke();
    quad(25, 5, 25, -5, -40, -10, -40, 10); //draw ship
    triangle(25, 5, 25, -5, 45, 0);
    triangle(10, 0, -10, 40, -10, -40); //draw ship
    triangle(-20, 0, -35, 30, -35, -30); //draw ship
    fill(0, 0, 255);
    ellipse(25, 0, 20, 10);
    if ((follower==false && keyPressed==true && keyCode==UP)||follower==true && myXspeed!=0) {
      fill(255, 0, 0);
      triangle(-40, 7, -40, -7, -57, 0); //draw fire from ship
    }
    popMatrix();
  }

  int getX() {
    return (int)myCenterX;
  }
  int getY() {
    return (int)myCenterY;
  }
  float getTheta() {
    return (float)myPointDirection;
  }

  public void follow(Spaceship leader, int xshift, int yshift) {
    float t = (leader.getTheta()*0.01745329251);
    float x1 = leader.getX()+yshift*sin(t-(float)(Math.PI/2))+(xshift*sin(t));
    float y1 = leader.getY()+yshift*-1*sin(t)+(xshift*sin(t-(float)(Math.PI/2)));
    int x = (int)myCenterX;
    int y = (int)myCenterY;
    float xoff=(x-x1)*.004;
    float yoff=(y-y1)*.004;
    float angle=atan(yoff/xoff)+(float)Math.PI;
    if (xoff<0) {
      angle-=Math.PI;
    }
    float speed = dist(x, y, x1, y1)*.001;
    if (speed>.02) {
      myPointDirection = angle*180 /Math.PI;
      accelerate(.3);
      speed=speed*15+1;
      myXspeed=constrain((float)myXspeed, -speed, speed);
      myYspeed=constrain((float)myYspeed, -speed, speed);
    } else {
      myXspeed=0;
      myYspeed=0;
      if ((abs((float)(myPointDirection-leader.getTheta())))>10) {
        if (myPointDirection>leader.getTheta()) {
          myPointDirection-=3;
        } else {
          myPointDirection+=3;
        }
        myPointDirection=myPointDirection%360;
      }
    }
  }

  public void slow() {
    myXspeed*=.7;
    myYspeed*=.7;
  }
}


Spaceship Jeremiah =new Spaceship(550,40, false);
Spaceship[] Fleet = new Spaceship[6];

void setup() {
  size(1100, 700);
  for(int i=0; i<6; i++){
    Fleet[i]=new Spaceship((i%3)*100+250,((i/3)+1)*100+50, true);
  }
}

void draw() {
  background(0,0,0);
  Jeremiah.show(); 
  Jeremiah.move();  
  for(int i=0; i<6; i++){
    Fleet[i].show();
    Fleet[i].follow(Jeremiah,(int)(((i+2)%2*160*((i+2)/2))-(80*((i+2)/2))),((i/2)+1)*100);
     Fleet[i].move();

  }
  if (keyPressed) {
    if (keyCode==RIGHT) { //controls movement of ship
      Jeremiah.turn(3);  
    }
    if (keyCode==LEFT) {
      Jeremiah.turn(-3);  
    }
    if (keyCode==UP) {
      Jeremiah.accelerate(.1); 
    }
    if (keyCode==ENTER) { //teleports ship to new location
    }
  } else {
    Jeremiah.slow();
    
  }
}

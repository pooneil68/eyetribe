// Modified from eyetribe/example/eyetribe_test/eyetribe_test.pde
// See http://memorandums.hatenablog.com/entry/2014/12/07/005817

import com.theeyetribe.client.request.*;
import com.theeyetribe.client.reply.*;
import com.theeyetribe.client.data.*;
import com.theeyetribe.client.*;

// data storage
PrintWriter output;

EyeTribe e;

float gazex, gazey, gazerawx, gazerawy;
float leftEyex, leftEyey, leftEyepupilCenterx, leftEyepupilCentery;
double leftEyepupilSize;
float rightEyex, rightEyey, rightEyepupilCenterx, rightEyepupilCentery;
double rightEyepupilSize;
long timeStamp;
Boolean isFixated;
int baseTime, taskPhase;

void setup(){
  frameRate( 60 );

  openDataFile();
  baseTime = 0;
  taskPhase = 0;

  size(displayWidth, displayHeight);
  e = new EyeTribe(this);
}

void gazeDataReceived(GazeData a)
{
  gazex = (float)a.smoothedCoordinates.x;
  gazey = (float)a.smoothedCoordinates.y;
  gazerawx = (float)a.rawCoordinates.x;
  gazerawy = (float)a.rawCoordinates.y;
  timeStamp = a.timeStamp;
  isFixated = a.isFixated;
  
  leftEyex = (float)a.leftEye.rawCoordinates.x;
  leftEyey = (float)a.leftEye.rawCoordinates.y;
  leftEyepupilCenterx = (float)a.leftEye.pupilCenterCoordinates.x;
  leftEyepupilCentery = (float)a.leftEye.pupilCenterCoordinates.y;
  leftEyepupilSize = a.leftEye.pupilSize;
  
  rightEyex = (float)a.rightEye.rawCoordinates.x;
  rightEyey = (float)a.rightEye.rawCoordinates.y;
  rightEyepupilCenterx = (float)a.rightEye.pupilCenterCoordinates.x;
  rightEyepupilCentery = (float)a.rightEye.pupilCenterCoordinates.y;
  rightEyepupilSize = a.rightEye.pupilSize;
  
  saveDataFile();
}

void draw()
{
  background(0);
  
  fill( 180,0,0 );
  if( millis() - baseTime > 8000 ){
    ellipse(displayWidth/2, displayHeight/2, 20, 20);
    taskPhase = 4;
  }
  else if( millis() - baseTime > 6000 ){
    ellipse(displayWidth/2 + 300, displayHeight/2, 20, 20);
    taskPhase = 3;
  }
  else if( millis() - baseTime > 4000 ){
    ellipse(displayWidth/2 - 300, displayHeight/2, 20, 20);
    taskPhase = 2;
  }
  else if( millis() - baseTime > 2000 ){
    ellipse(displayWidth/2, displayHeight/2, 20, 20);
    taskPhase = 1;
  }

  fill( 255,255,255 );
  ellipse(gazex, gazey, 10.0, 10.0);
  
  saveImgLogFile();
}

void openDataFile(){
   // data storage
  int y = year();   // 2003, 2004, 2005, etc.
  int m = month();  // Values from 1 - 12
  int d = day();    // Values from 1 - 31
  int h = hour();
  int mi = minute();
  int s = second();
  int mil = millis();
  output = createWriter("data/"+nf(y,4)+nf(m,2)+nf(d,2)+nf(h,2)+nf(mi,2)+nf(s,2)+nf(mil,3)+ ".txt");
}

void saveDataFile(){
 int int_isFixated = 0;
 if (isFixated == true){ int_isFixated = 1; }
 output.println( "eye" + "\t" + gazex + "\t" + gazey + "\t"
    + gazerawx + "\t" + gazerawy + "\t"
    + timeStamp + "\t" + millis() + "\t" + int_isFixated  + "\t"
    + leftEyex + "\t" + leftEyey + "\t" 
    + leftEyepupilCenterx + "\t" 
    + leftEyepupilCentery + "\t" 
    + leftEyepupilSize + "\t"
    + rightEyex + "\t" + rightEyey + "\t" 
    + rightEyepupilCenterx + "\t" 
    + rightEyepupilCentery + "\t" 
    + rightEyepupilSize);
}
void saveImgLogFile(){
 output.println( "img" + "\t" + taskPhase + "\t" + millis());
}

//-------------------------------------------
void keyPressed() {
  if (key == ESC){
    key=0;
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit(); // Stops the program
  }
}

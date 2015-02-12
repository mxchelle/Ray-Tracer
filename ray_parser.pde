/*
* Instructions: Click on screen to shoot lasers.
* Pink: initial eye ray
* Blue: reflected ray that hits something
* Green: reflected ray that hits nothing
*/



///////////////////////////////////////////////////////////////////////
//
// Command Line Interface (CLI) Parser  
//
///////////////////////////////////////////////////////////////////////
String gCurrentFile = new String("rect_test.cli"); // A global variable for holding current active file name.

//---Background Hack---//
public float rBG;
public float gBG;
public float bBG;

///////////////////////////////////////////////////////////////////////
//
// Press key 1 to 9 and 0 to run different test cases.
//
///////////////////////////////////////////////////////////////////////
void keyPressed() {
  switch(key) {
    case '1':  gCurrentFile = new String("t0.cli"); interpreter(); break;
    case '2':  gCurrentFile = new String("t1.cli"); interpreter(); break;
    case '3':  gCurrentFile = new String("t2.cli"); interpreter(); break;
    case '4':  gCurrentFile = new String("t3.cli"); interpreter(); break;
    case '5':  gCurrentFile = new String("c0.cli"); interpreter(); break;
    case '6':  gCurrentFile = new String("c1.cli"); interpreter(); break;
    case '7':  gCurrentFile = new String("c2.cli"); interpreter(); break;
    case '8':  gCurrentFile = new String("c3.cli"); interpreter(); break;
    case '9':  gCurrentFile = new String("c4.cli"); interpreter(); break;
    case '0':  gCurrentFile = new String("c5.cli"); interpreter(); break;
  }
}

///////////////////////////////////////////////////////////////////////
//
//  Parser core. It parses the CLI file and processes it based on each 
//  token. Only "color", "rect", and "write" tokens are implemented. 
//  You should start from here and add more functionalities for your
//  ray tracer.
//
//  Note: Function "splitToken()" is only available in processing 1.25 
//       or higher.
//
///////////////////////////////////////////////////////////////////////
void interpreter() {
  background(0);
  rBG =0;
  gBG =0;
  bBG = 0;
  resetObjects();
  
  String str[] = loadStrings(gCurrentFile);
  if (str == null) println("Error! Failed to read the file.");
  for (int i=0; i<str.length; i++) {
    
    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    if (token.length == 0) continue; // Skip blank line.
    
    if (token[0].equals("fov")) {
      fov(int(token[1]));
    }
    else if (token[0].equals("background")) {
      //DONE
      float r =float(token[1]);
      float g =float(token[2]);
      float b =float(token[3]);
      setBG(r,g,b);

    }
    else if (token[0].equals("light")) {
      float x =float(token[1]);
      float y =float(token[2]);
      float z =float(token[3]);
      float r =float(token[4]);
      float g =float(token[5]);
      float b =float(token[6]);
     makeLight( x,  y,  z,  r,  g,  b);
    }
    else if (token[0].equals("surface")) {
      float[] reflect = new float[token.length-1];
      for(int j=0; j<reflect.length; j++){
        reflect[j] = float(token[j+1]);
      }
      
      defineSurface(reflect);
      // TODO
    }    
    else if (token[0].equals("sphere")) {
      // TODO
      float r = float(token[1]);
      float x = float(token[2]);
      float y = float(token[3]);
      float z = float(token[4]);
      makeSphere(r,x,y,z);
  
    }
    else if (token[0].equals("begin")) {
      makePoly();
    }
    else if (token[0].equals("vertex")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      makeVertex( x,  y,  z);
    }
    else if (token[0].equals("end")) {
      endPoly();
    }
    else if (token[0].equals("color")) {
      float r =float(token[1]);
      float g =float(token[2]);
      float b =float(token[3]);
      fill(r, g, b);
    }
    else if (token[0].equals("rect")) {
      float x0 = float(token[1]);
      float y0 = float(token[2]);
      float x1 = float(token[3]);
      float y1 = float(token[4]);
      rect(x0, height-y1, x1-x0, y1-y0);
    }
    else if (token[0].equals("write")) {
      // you should render the scene here
      initialRay();
      save(token[1]);  
    }
  }
}

///////////////////////////////////////////////////////////////////////
//
// Some initializations for the scene.
//
///////////////////////////////////////////////////////////////////////
void setup() {
  size(300, 300);  
  noStroke();
  colorMode(RGB, 1.0);
  background(0, 0, 0);
  interpreter();
}

///////////////////////////////////////////////////////////////////////
//
// Draw frames.  Should leave this empty.
//
///////////////////////////////////////////////////////////////////////
void draw() {
}

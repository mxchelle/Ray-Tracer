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

public class Hit{
  Thing obj;
  float t;
  Ray ray;
  
  public Hit(Thing obj, Ray ray, float t){
    this.obj = obj;
    this.ray = ray;
    this.t = t;
    
  }
  
  public float[] getColor(int level, float [] bgColor){
    return obj.getColor(ray, t, level, bgColor);
  }

  public float[] atT(){
    return  ray.atT(t);
  }  
}
public class Light{
  float[] rgb;
  float[] coord;
  public Light(float x, float y, float z, float r, float g, float b){
    float[] temp1 = {x,y,z};
    coord = temp1;
    float[] temp = {r,g,b};
    rgb = temp;

  }
}
public class Ray{
  
  float[] origin;
  float[] d;
  //float[] change;
  
  public Ray(float ox, float oy, float oz, float sx, float sy, float sz){
    float [] origin = {ox, oy, oz};
    this.origin = origin;
    float [] end = {sx, sy, sz};
    this.d = dxyz(end);
   // this.change = dxyz();
  }
  
  public Ray(float [] origin, float [] end){
    this.origin = origin;
    this.d = dxyz(end);
  }
  
 public Ray(float[] origin, float[] dir, int num){
   this.origin = origin;
   this.d = Vector.normalize(dir);
 }
  
  public float[] dxyz(float[] end){
    float[] dxyz = Vector.subtraction(end,origin);
    return Vector.normalize(dxyz);
  }
  
  public float[] atT(float t){
    return Vector.addition(origin,Vector.scalar(d,t));
  }
  
  public void print(){
    println("Origin:"+origin[0]+" "+origin[1]+" "+origin[2]);
    println("D:"+d[0]+" "+d[1]+" "+d[2]);
  }
}

public class Sphere extends Thing{
  
  float r,  x,  y,  z;
  
  public Sphere(float r, float x, float y, float z, Surface surface){
    this.r=r;
    this.x=x;
    this.y=y;
    this.z=z;
    this.s = surface;
  }
  
    
  float intersect(Ray pew){
    
    float ex = pew.origin[0];
    float ey = pew.origin[1];
    float ez = pew.origin[2];
    
    float dx = pew.d[0];
    float dy = pew.d[1];
    float dz = pew.d[2];
    /*
   pew.change[0];
    float dy = pew.change[1];
    float dz = pew.change[2];*/

    float a = squareSum(pew.d);
    
    float b = 2*dx*(ex-this.x)+2*dy*(ey-this.y)+2*dz*(ez-this.z);
    //2*(ex*dx + ey-1*this.y*dy + ez*dz + dx*-1*this.x + dy* + dz*-1*this.z);
    
    float[] cHelper = {ex,ey,ez,this.x,this.y,this.z};
    float c = squareSum(cHelper) + -2*(ex*this.x + ey*this.y + ez*this.z) - r*r; 
    
    float determinant = b*b - 4*a*c;
    
    float t = -1;

    
    if(determinant>=0){
      
      float t1 = (float)(-b+Math.sqrt(determinant))/(2*a);
      float t2 = (float)(-b-Math.sqrt(determinant))/(2*a);
     
      t = t2 > 0 ? t2: t1;
      t = t > 0 ? t : -1;
      //t = t<=interval ? t :-1; //z -azis
    }
    
    return t;
  }
  
  public float squareSum(float [] nums){
    float sum = 0;
    for (float num:nums){
      sum+=num*num;
    }
    return sum;
  }
  
  //TODO
  //do you think we need to calculate z differently b/c we're looking down a neg. axis?
  public float[] getNormal(float [] position){
    float [] center = {this.x, this.y, this.z};
    return Vector.normalize(Vector.subtraction(position, center));
  } 
}


public class Surface{
  float[] ref;
  
  public Surface(float[] reflectance){
    this.ref = reflectance;
  }
  
}
public abstract class Thing{
  float[] ref;
  float[] col;
  
  Surface s;
  
  public Thing(){
  }
 
  public void myColor(float[] col){
    this.col = col;
  }
  
  //take direction
  //xyz are coord on surface
  //ex ey ez are origin direction of ray (eg. eye)
  public float[] getColor(Ray pew, float t, int level, float[] bgColor){
    //for each light source
    
    float[] origin = pew.origin;
    float[] surfaceCoord = pew.atT(t);
    
    float[] rgb =new float[3];
    float[] N = getNormal(surfaceCoord);
    
     
    
    for(int i=0; i<rgb.length; i++){
      rgb[i]+=s.ref[3+i];//*s.ref[i]; //ambient light*objcolor
    }
    
    for(Light light: lights){
      
      for (int i=0; i<rgb.length; i++){
        float lightColor = light.rgb[i];
        float P = s.ref[9];
        float hlColor = 1;
        
        float[] L = Vector.normalize(Vector.subtraction(light.coord, surfaceCoord));
        float NxL = Vector.dotProduct(N,L);
        
        float[] E = Vector.scalar(pew.d,-1); //pew.change; //origin-surface normalized
        
        float [] H = Vector.normalize(Vector.addition(L, E));
        float HxN =Vector.dotProduct(H, N);
        
        float specular = s.ref[6+i];
       
        
        float objCol = s.ref[i];
        
        //----Shadow-----//
        float eps = .001;
        Ray newRay = new Ray(surfaceCoord,light.coord);
        Hit hit = raytrace(newRay, eps, this);
        
       //if nothing is hit, no shadow
        if(hit==null || Vector.distance(surfaceCoord, newRay.atT(hit.t)) > Vector.distance(surfaceCoord, light.coord) ){ //|| hit.t>1?? check if behind light somehow
           rgb[i]+=objCol*lightColor*max(0.0,NxL)+specular*lightColor*(float)Math.pow(max(0.0,HxN),P);
        }
      }//end rgb
    }//end light loop
    
    if(TEST){
          makeDot(pew.origin, surfaceCoord, color(1,0,1),1);
    }
        
        
    //if not in shadow, find reflection
    float mirror = s.ref[10];
    if(mirror>0){
      float[] reflect = Vector.scalar(reflectionRay(pew.d, surfaceCoord, N, ++level, bgColor), mirror);
      rgb= Vector.addition(rgb, reflect);
    }
   
    
    return rgb;
  }
  
  //take incoming ray
  public float[] reflectionRay(float[] D, float[] surfaceCoord, float [] N,  int level, float[] bgColor){

    if(level<20){
      
      float DxN = Vector.dotProduct(D,N);
      float[] r = Vector.subtraction(D,Vector.scalar(N, 2*DxN));
      float eps = -.01;

      Ray trace = new Ray(surfaceCoord, r,1);
      Hit hit = raytrace(trace, eps, this);
      
      if(hit!=null){
        if(TEST){
          makeDot(hit.atT(), trace.origin, color(0,0,1),1);
        }
        return hit.getColor(level, bgColor);
      }
      else{
        if(TEST){
          makeDot(trace.atT(3), trace.origin, color(0,1,0),1);
        }
      }
    }
    return bgColor;
  }
  
  public int sign(float num){
    return num>=0 ? 1 : -1;
  }
  
  //--ONLY TRIANGLE--//
  public  void addVertex(float x, float y, float z){
  }
  public  void endPoly(){
  }
  public abstract float intersect(Ray pew);
  public abstract float[] getNormal(float [] position);
}


public class Triangle extends Thing{
  
  float[][] coord;
  int edge;
  
  public Triangle(Surface surface){
    edge = 0;
    coord = new float[3][];
    this.s = surface;
  }
  
  public void addVertex(float x, float y, float z){
    float [] temp = {x,y,z};
    coord[edge++] = temp; 
  }
  
 
  void drawVertex(float x, float y, float z) {
   /* x= perspectiveZ(x, z);
    y= perspectiveZ(y, z, -1);
    y = coord(y, height);
    x = coord(x, width);
    vertex(x, y);*/
  }
  
  void endPoly() {
   /* beginShape();
    for (int i=0; i<coord.length; i++){
        drawVertex(coord[i][0],coord[i][1],coord[i][2]); 
    }
    endShape();*/
  }
  
  //float ex, float ey, float ez, float x1, float y1, float z1
  float intersect(Ray pew){
    
    float ex = pew.origin[0];
    float ey = pew.origin[1];
    float ez = pew.origin[2];
    
    float g = pew.d[0];
    float h = pew.d[1];
    float i = pew.d[2];
    //-------//
    
    float j = coord[0][0]-ex;
    float k = coord[0][1]-ey;
    float l = coord[0][2]-ez;
    
    float a = coord[0][0] - coord[1][0]; //x0 - x1
    float b = coord[0][1] - coord[1][1];
    float c = coord[0][2] - coord[1][2];
    
    float d = coord[0][0] - coord[2][0]; //x0 - x2
    float e = coord[0][1] - coord[2][1];
    float f = coord[0][2] - coord[2][2];

    
    //this is blasphemy!
    float eihf = e*i - h*f;
    float gfdi = g*f - d*i;
    float dheg = d*h - e*g;
    float akjb = a*k - j*b;
    float jcal = j*c - a*l;
    float blkc = b*l - k*c;
    
    
    float M = cramersRule(a,eihf, b, gfdi, c, dheg);

    //compute t
    float t = -1;
    if(M!=0){
      t = -1*cramersRule(f,akjb,e,jcal,d,blkc)/M;
      if(t<0){
        return -1;
      }
      //compute y
      float y = cramersRule(i,akjb,h,jcal,g,blkc)/M;
      if(y<0 || y>1){
        return -1;
      }
      //compute B
      float B = cramersRule(j,eihf,k,gfdi,l,dheg)/M;
      if(B<0 || B>1-y){
        return -1;
      }
    }
   
    return t;  
  }
  
  /*
  *  a*( unit1 ) + b*(unit2) + c*(unit3)
  *
  */
  public float cramersRule(float a, float unit1, float b, float unit2, float c, float unit3){
        return a*unit1 + b*unit2 + c*unit3;
  }
  
  //shoud I normalize?
  public float[] getNormal(float[] position){
    float[] E1 = Vector.subtraction(coord[1],coord[2]);
    float[] E2 = Vector.subtraction(coord[1],coord[0]);
    
    float [] v = Vector.crossProduct(E2, E1);
 
    //translate it so it's where you need it?
    return Vector.normalize(v);
  }
  
}


import java.util.Arrays;

public static class Vector{
  
  public static float[] crossProduct(float[] v1, float v2[]){
     float[] temp = {v1[1]*v2[2] - v1[2]*v2[1] , v1[2]*v2[0] -v1[0]*v2[2], v1[0]*v2[1]-v1[1]*v2[0]};
     return temp;
  }
  
  public static float dotProduct(float[] v1, float v2[]){
    float sum = 0;
    for(int i=0; i<v1.length; i++){
      sum+=v1[i]*v2[i];
    }
    return sum;
  }
  
  public static float[] addition(float[] v1, float v2[]){
    float[] v = Arrays.copyOf(v1,v1.length);
    for(int i=0; i<v.length; i++){
      v[i]+=v2[i];
    }
    return v;
  }
  
  public static float[] subtraction(float[] v1, float v2[]){
    float [] temp = new float[3];
    for(int i=0; i<temp.length; i++){
      temp[i] = v1[i]-v2[i];
    }
    return temp;
  }
  
  //v2 is bigger than v1
  //start end
  public static float distance(float[] v1, float v2[]){
    float sum =0;
    for(int i =0; i<v1.length; i++){
      sum+=pow(v2[i]-v1[i],2);
    }
    return sqrt(sum);
  }
  
    /**
  * Normalizes this vector
  * 
  * @return Matrix this matrix
  */
  public static float[] normalize(float[] v1) {
    float sum = 0;
    float[] v = Arrays.copyOf(v1,v1.length);
    for (int i=0;i<v1.length;i++) {
      sum+= pow(v1[i], 2);
    }
    sum = sqrt(sum);
    for (int i=0;i<v1.length;i++) {
      v[i]/= sum;
    }
    return v;
  }
  
    
    /**
  * Normalizes this vector
  * 
  * @return Matrix this matrix
  */
  public static float[] scalar(float[] v1, float scalar) {
    float sum = 0;
    float [] v = new float [3];
    for (int i=0;i<v.length;i++) {
      v[i] = v1[i]* scalar;
    }
    return v;
  }
  
  
}
import java.util.LinkedList; 
import java.util.ArrayList; 

float k;

Surface activeSurface;

LinkedList<Thing> objects= new LinkedList<Thing>();
ArrayList<Light> lights= new ArrayList<Light>();
public static Boolean TEST = Boolean.FALSE;

public void fov(int fovy) {
  this.k = (float)Math.tan(Math.toRadians(fovy/2));
}

//---DEALS WITH SURFACE---//

public void defineSurface(float[] reflectance){
  activeSurface = new Surface(reflectance);
}

public void defineColor(float r, float g, float b){
  float[] colorMe = {r,g,b};
  objects.getFirst().myColor(colorMe);
}
//---DEALS WITH SPHERE---//

public void makeSphere(float r, float x, float y, float z){
  objects.addFirst(new Sphere(r,x,y,z,activeSurface));
}

public void setBG(float r, float g, float b){
  rBG = r;
  gBG = g;
  bBG = b;
  background(r,g,b);
}


//---DEALS WITH POLYGON---//

public void makePoly(){
  objects.addFirst(new Triangle(activeSurface));
}

public void makeVertex(float x, float y, float z){
  objects.getFirst().addVertex(x,y,z);
}

public void endPoly(){
  objects.getFirst().endPoly();
}

//--DEALS WITH LIGHTS--//

public void makeLight(float x, float y, float z, float r, float g, float b){  
 lights.add(new Light(x,y,z,r,g,b));
}

//--DEALS WITH OBJECTS--//

public void resetObjects() {
  objects = new LinkedList<Thing>();
  lights = new ArrayList<Light>();
}

//--DEALS WITH RAYTRACING--//

public void initialRay() {
  //find ray for each pixel on screen
  //use camera coordinate values
  //how wide is screen width IT'S 2*K!!!
  //find d distance from screen to eye
  
  //if ray intersect, set pixel color
  
  for(int i=0; i<height; i++){
    for(int j =0; j<width; j++){
       
     float[] colRaw = beginTrace(i,j);
     
     if(colRaw!=null){
       color myColor = color(colRaw[0], colRaw[1],colRaw[2]);
       set(j,i,myColor);
     }
    }//end j
  }//end i
}//end function

public float[] beginTrace(float i, float j){
  //u,v are pixel's position in viezw plane

     float u = (-this.k + j*(2.0*this.k)/(1.0*width));
     float v = -(-this.k + i*(2.0*this.k)/(1.0*height));

     float screenX = (u);
     float screenY = (v);
     float screenZ= (-1);
     
     //println(u+" "+v+" "+-nnear);
     Ray initial = new Ray(0,0,0,screenX,screenY,screenZ);
      
     Hit hit= raytrace(initial, 0);
     float [] hc = null;
     if (hit!=null){
       float[] mybgColor = {rBG, gBG, bBG};
       hc = hit.getColor(0, mybgColor);
     }
     
     return hc;
}

//ex,ey,ez ray origin
//dx dy dz ray magnitude
public Hit raytrace(Ray pew, float t0){
    return raytrace(pew, t0, null);
}

public Hit raytrace(Ray pew, float t0, Thing myObj){
      float t =-1;
      float t1 = 100000;
      Hit hitObj = null;

      for(Thing obj:objects){
        if(!obj.equals(myObj)){
         t = obj.intersect(pew);
           if(t>=t0 && t<t1){
             hitObj = new Hit(obj,pew,t);
             t1 =t;
           }
         }
      }//end for
    return hitObj;
}


  //--COORDINATES MAPPING--//
  public float perspectiveZ(float coord, float z, int mult) {
    if(z==0)
      return 0.0;
    return -1* perspectiveZ( coord, z);
  }
  
  public float perspectiveZ(float coord, float z) {
    if(z==0)
      return 0.0;
    return coord/Math.abs(z);
  }
  
  public float coord(float coord, int hw) {
    return (coord+k) * (hw/(2.0*k));
  }
  


public void makeDot(float [] xyz, float [] sCoord, color col, int str){
  float x= perspectiveZ(xyz[0], xyz[2]);
  float y= perspectiveZ(xyz[1], xyz[2], -1);
  y = coord(y, height);
  x = coord(x, width);
  
  float x0= perspectiveZ(sCoord[0], sCoord[2]);
  float y0= perspectiveZ(sCoord[1], sCoord[2], -1);
  y0 = coord(y0, height);
  x0 = coord(x0, width);
  
  //set((int)x,(int)y,black);
  stroke(col);
  strokeWeight(str);
  fill(0);
  line(x0, y0, x, y);
  print("ffffff"+x0+""+x);
 // rect(0, 0, width, height);

  print("hi "+x0+" "+y0+" "+x+" "+y);
  draw();
}


public void mousePressed(){
  float x = mouseX;
  float y = mouseY;
  
  //float x = 63.0;
  //float y = 231.0;
  
  println(x+" , "+y);
  TEST = Boolean.TRUE;
  beginTrace(y,x);
  TEST = Boolean.FALSE;
}



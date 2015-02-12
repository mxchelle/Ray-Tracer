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


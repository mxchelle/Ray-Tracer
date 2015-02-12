
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



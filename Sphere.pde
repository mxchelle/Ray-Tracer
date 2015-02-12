
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



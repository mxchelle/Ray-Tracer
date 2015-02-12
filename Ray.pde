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

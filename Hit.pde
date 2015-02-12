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

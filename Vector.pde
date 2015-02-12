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

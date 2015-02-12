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


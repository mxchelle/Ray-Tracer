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

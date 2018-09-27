abstract class func{
  abstract float f(float x);
}

final float eps=0.1;
class deriv extends func{
  func fu;
  deriv(func f){
    fu=f;
  }
  float f(float x){
    return (fu.f(x+eps)-fu.f(x-eps))/2/eps;
  }
}

class theFunc extends func{
  float f(float x){
    return cos(x);
    //return noise(x)*5-2.5;
  }
}
int facto(int n){
  if(n>1)return n*facto(n-1);
  return 1;
}

void setup(){
  size(500,500);

}

//float taylorApprox(func f,deriv der1,deriv der2,deriv der3,deriv der4,deriv der5,float a,float realX){
  //return f.f(a)+der1.f(a)*(realX-a)+der2.f(a)*pow(realX-a,2)/facto(2)+der3.f(a)*pow(realX-a,3)/facto(3)+der4.f(a)*pow(realX-a,4)/facto(4)+der5.f(a)*pow(realX-a,5)/facto(5);
//}

float taylorApprox(func[]derivatives,float a,float realX){
  float y=0;
  for(int i=0;i<derivatives.length;i++){
    y+=derivatives[i].f(a)*pow(realX-a,i)/facto(i);
  }
  return y;
}

void draw(){
  
  background(255);

  float o=5;

  float xmi=-o;
  float xpl=o;
  float ymi=-o;
  float ypl=o;
  
  func f=new theFunc();
  deriv der1=new deriv(f);
  deriv der2=new deriv(der1);
  deriv der3=new deriv(der2);
  deriv der4=new deriv(der3);
  deriv der5=new deriv(der4);
  
  noiseDetail(1);
  
  func[]derivatives=new func[10];
  derivatives[0]=f;
  for(int i=1;i<derivatives.length;i++){
    derivatives[i]=new deriv(derivatives[i-1]);
  }
  
  for(int pixelX=0;pixelX<width;pixelX++){
    float realX=map(pixelX,0,width,xmi,xpl);
    float realY=f.f(realX);
    float pixelY=map(realY,ypl,ymi,0,height);
    //point(pixelX,pixelY);
    stroke(0);
    line(pixelX-1,map(f.f(map(pixelX-1,0,width,xmi,xpl)),ypl,ymi,0,height),pixelX,pixelY);
    
    if(pixelX%1==0){
      float a=map(mouseX,0,width,xmi,xpl);
      line(mouseX,0,mouseX,height);
      float ta=taylorApprox(derivatives,a,realX);
      float ta1=taylorApprox(derivatives,a,map(pixelX+1,0,width,xmi,xpl));
      //point(pixelX,map(ta,ypl,ymi,0,height));
      stroke(0,255,0);
      line(pixelX,map(ta,ypl,ymi,0,height),pixelX+1,map(ta1,ypl,ymi,0,height));
      //float slope=der1.f(realX);
      //float ox=1;
      //float oy=slope;
      //float mul=30;
      //line(pixelX-mul*ox,pixelY+mul*oy,pixelX+mul*ox,pixelY-mul*oy);
    }
  }
}
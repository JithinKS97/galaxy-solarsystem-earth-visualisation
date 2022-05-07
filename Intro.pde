
hBody[] body = new hBody[500];
PVector cameraP, targCam, cameraV, cameraA;
int stat = 0, i, up = -1, step = -1;
float scale, scaleStep, targScale, theta = 0;
boolean transition = false;
float[] sStep, tStep;

void setup()
{
  size(540, 960);
  
  
  body[0] = new hBody(0, 0, width/40, width/40, color(#2878FA));
  body[0].scale = 8;
  body[0].showOrbit = true;
  body[0].attractor = true;
  body[0].shrink = 0.3;
  body[0].setK(1);
  
  
  body[1] = new hBody(int(-width/1.5), 0, width/3, width*2, color(#FAC800));
  body[1].scale = 0.3;
  body[1].attractor = true;
  body[1].shrink = 3;
  body[1].setK(1);
  
  body[2] = new hBody(-width*120, 0, width*10, width*2000, color(0));
  body[2].scale = 0.0015;
  body[2].attractor = true;
  body[2].shrink = 300;
  body[2].setK(2);
  
  body[3] = new hBody(width/30, 0, width/150, width/150, color(#FAFAC8));
  body[3].showOrbit= true;
  
  body[4] = new hBody(int(-width/3), 0, width/60, width/60, color(#C8C8C8));
  
  body[5] = new hBody(int(-width/6), 0, width/50, width/50, color(#FAAA00));
  
  body[6] = new hBody(int(width/6), 0, width/50, width/50, color(#C83C00));
  
  body[7] = new hBody(int(width/3), 0, width/10, width/10, color(#F0A03C));
  
  body[8] = new hBody(int(width/2), 0, width/15, width/15, color(#F0DCAA));
  body[8].ring = true;
  
  body[9] = new hBody(int(width/1.4), 0, width/17, width/17, color(#4664C8));
  
  body[10] = new hBody(int(width/1.1), 0, width/22, width/22, color(#14328C));
  body[10].ring = true; 
  
  for(i=11;i<500;i++)
  {
    body[i] = new hBody(int(((i+3)*width/2)*cos(theta)), int(((i+3)*width/2)*sin(theta)), int(random(width/50,width*1.5)), width*2, color(250+random(0,5), 240+random(0,10), random(0,250)));
    theta+=0.03;
    body[i].halo = true;
  }
  
  for(i = 4; i < 11; i++)
    body[i].showOrbit = true;
  
  body[0].setPosAround(body[1],1);
  body[1].setPosAround(body[2],1.4);
  body[3].setPosAround(body[0],1);
  for(i = 4; i < 11; i++)
    body[i].setPosAround(body[1],1);
    
  for(i=11;i<500;i++)
    body[i].setPosAround(body[1],1.4);
  

  cameraP = new PVector();
  cameraV = new PVector();
  cameraA = new PVector();
  
  
  targCam = new PVector();
  
  sStep = new float[4];
  tStep = new float[4];
  
  sStep[0] = 0.2;
  sStep[1] = 0.125;
  sStep[2] = 0.00001;
  sStep[3] = 0.01;
  
  tStep[0] = 0.05;
  tStep[1] = 0.001;
  tStep[2] = 0.05;
  tStep[3] = 0.1;
}

void draw()
{
  translate(width/2, height/2);
  
  camera();
  
  cameraP.add(cameraV);
  cameraV.add(cameraA);
  
  
  background(color(#00050A));
  scale(scale);
  
  translate(-cameraP.x,-cameraP.y);
  
  body[0].moveAround(body[1]);
  body[0].display();
  
  body[1].moveAround(body[2]);
  body[1].display();
  
  
  body[3].moveAround(body[0]);
  body[3].display();
  
  body[2].display();
  for(i = 4; i < 11; i++)
  {
    body[i].moveAround(body[1]);
    body[i].display();
  }
  
  for(i=11;i<500;i++)
  {
    body[i].display();
    body[i].moveAround(body[2]);
    if(PVector.sub(body[i].instPos, body[1].instPos).mag()<20*width)
       body[i].col = color(255,255,255,0);
  }
  if(stat == 2)
    body[2].mass = width*1000000;
  else
    body[2].mass = width;
}

void camera()
{
  if(transition == false)
  {
      cameraP = body[stat].instPos.get();
      scale = body[stat].scale;
  }
  else
  {
    if(cameraP!=targCam)
    {

      cameraA = PVector.sub(targCam,cameraP);
      cameraA.mult(tStep[step]);
      if(step  == 2)
        cameraA.limit(4000);
      else
        cameraA.limit(300);
      if(step == 1)
        cameraV.mult(0.95);
      else
        cameraV.mult(0.7);
      
    }
    if(scale!=targScale)
    {
      scaleStep = (targScale - scale)*sStep[step];
      scale += scaleStep;
    }
    if(cameraP == targCam && scale == targScale)
      transition = false;
    
    if(PVector.sub(targCam,cameraP).mag()<800 && step == 2)
      sStep[step] += 0.0005;
    
  }
  
}

void mousePressed()
{
  transition = true;
  
  if(stat == 0 || stat == 2)
    up*=-1;
    
  stat = (stat+up)%3;
  
  step = (step+1)%4;
  
  targScale = body[stat].scale;
  targCam = body[stat].instPos;
  
  if(stat!=2)
    sStep[2] = 0.002;
}
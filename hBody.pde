class hBody
{
  PVector pos, shPos, focus, centre, instPos, radius;
  int dia, a, b, mass, i;
  Boolean move = false, ring = false, showOrbit = false, attractor = false, halo = false;
  float rot, e, theta, w, G, scale, shrink,k;
  color col, str;
  float[] chDia,trans;

  hBody(int x, int y, int d, int m, color c)
  {
    pos = new PVector(x, y);
    shPos = new PVector(x, y);
    centre = new PVector();
    dia = d;
    mass = m;
    instPos = new PVector(x,y);
    radius = new PVector();
    G = 1;
    theta = random(2*PI);
    col = c;
    
    chDia = new float[3];
    trans = new float[3];

  }
  
  void setK(float k)
  {
    this.k=k;
    for(i=0;i<3;i++)
      chDia[i] = k*1.5*dia + k*i*0.5*dia;
  }
  
  void display()
  {
    if(attractor == true)
    {
      for(i =0;i<3; i++)
        if(chDia[i] < dia/k)
           chDia[i] =  k*2.5*dia;

       for(i =0;i<3; i++)  
         if(trans[i]>60)
           trans[i]=0;
    }
    
    noStroke();
    fill(col);
    if (move == false)
    {
      
      for(i=0;i<3;i++)
      {
        trans[i] = map(chDia[i], k*2.5*dia,0, 0, 60);
        fill(255, 255, 255, this.trans[i]);
        ellipse(pos.x, pos.y, k*chDia[i], k*chDia[i]);
        fill(255, 255, 255, trans[i]);
        chDia[i] = chDia[i] - shrink;
      }
      fill(col);
      ellipse(pos.x, pos.y, dia, dia);
      
    }
    else
    {
      pushMatrix();
      translate(focus.x, focus.y);
      rotate(rot);
      translate(a*e, 0);
      
      if(attractor == true)
      {
        for(i=0;i<3;i++)
        {
          trans[i] = map(chDia[i], 2.5*dia,0, 0, 60);
          fill(255, 255, 255, this.trans[i]);
          ellipse(shPos.x, shPos.y, chDia[i], chDia[i]);
          fill(255, 255, 255, trans[i]);
          chDia[i] = chDia[i] - shrink;
        } 
      }
      
      
      if(halo == true)
      {
        fill(col,60);
        ellipse(shPos.x,shPos.y, 4*dia, 4*dia);
      }
      fill(col);
      ellipse(shPos.x, shPos.y, dia, dia);
      noFill();
      if(ring == true)
      {
        
        stroke(col);
        strokeWeight(width/100);
        ellipse(shPos.x, shPos.y, dia*2, dia*2);
      }
      if(showOrbit == true)
      {
        stroke(color(255),75);
        strokeWeight(width/400);
        ellipse(0,0, 2*a, 2*b);
      }
     //ellipse(0,0, 2*a, 2*b);
     popMatrix();

    }
  }
  
  void setGrav(float a, float b)
  {

  }

  void setPosAround(hBody h, float ecc)
  {
    move = true;
    focus = h.pos;
    shPos.sub(h.pos);
    rot = atan2(shPos.y, shPos.x);
    shPos.y = 0;
    shPos.x /= cos(rot);

    a = int(shPos.x + shPos.x * ecc) / 2;
    e = (shPos.x - shPos.x * ecc ) / (shPos.x + shPos.x * ecc);
    b = int(a * sqrt(1 - e*e));
  }
  
  void moveAround(hBody h)
  {
    w = sqrt(G*h.mass/pow(dist(focus.x, focus.y, instPos.x, instPos.y),3));
    centre.set(focus.x+a*e*cos(rot),focus.y+a*e*sin(rot));
    shPos.x = a*cos(theta);
    shPos.y = b*sin(theta);
    radius = shPos.get();
    radius.rotate(rot);
    instPos.set(centre.x+radius.x,centre.y+radius.y);
    theta += w;
    focus = h.instPos;
  }
}
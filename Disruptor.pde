public enum disruptorType
{
  REPULSOR,
  ATTRACTOR
}

class Disruptor
{

  
  private PVector position;
  private PVector velocity;
  private int phase;
  private int phaseLength;
  private int cycles;
  private int size;
  private disruptorType type;  
  
  
  public Disruptor(boolean isRepulsor)
  {
    if (isRepulsor) {
      type = disruptorType.REPULSOR;
    } else {
      type = disruptorType.ATTRACTOR;
    }
    
    position = new PVector(mouseX, mouseY);
    velocity = new PVector(random(-2.0, 2.0), random(-2.0, 2.0));
    
    phase = 0;
    phaseLength = 100;
    cycles = 4;
    size = 150;
  }
  
  public PVector getPosition()
  {
    return position;
  }
  
  public disruptorType getType()
  {
    return type;
  }
  
  public void update()
  {
    phase++;
    phase %= phaseLength;
    
    position.add(velocity);
    screenwrap();
  }
  
  private void screenwrap()
  {
    if (position.x > width + size) position.x = -size;    
    if (position.x < -size) position.x = width + size;    
    if (position.y > height + size) position.y = -size;    
    if (position.y < -size) position.y = height + size;
  }
  
  public void draw()
  {
    int workingPhase = phase;
    if (type == disruptorType.ATTRACTOR) {
       workingPhase = phaseLength - phase;
    }
    
    pushMatrix();
      translate(position.x, position.y);
      
      for (int i = 0; i < int(phaseLength / cycles); i++) {
        float phasePercent = (float(workingPhase + i * int(phaseLength / cycles)) % phaseLength) / phaseLength;
        
        int colour = int((1.0 - phasePercent) * 255);
        if (type == disruptorType.REPULSOR) {
          colour = int(phasePercent * 255);
        }
        int opacity = int((1.0 - phasePercent) * 100);
        noFill();
        stroke(colour, colour, colour, opacity);
        
        ellipse(0, 0, phasePercent * size, phasePercent * size);
      }
    popMatrix();
  }
}
ArrayList<Boid> boids;
int birdCount;

ArrayList<Disruptor> disruptors;

Config config;

void setup()
{
  size(1600, 900);
  background(255);
  
  config = new Config();
  config.randomize();
    
  birdCount = 100;
  boids = new ArrayList<Boid>();
  
  disruptors = new ArrayList<Disruptor>();
  
  for (int i = 0; i < birdCount; i++) {
    boids.add(new Boid(config));
  }
}

void draw()
{
  blendMode(BLEND);
  fill(0, 30);
  rect(0, 0, width, height);
  blendMode(NORMAL);
  
  for (Disruptor a:disruptors) {
    a.update();
    a.draw();
  }
  
  for (Boid b:boids) {
    b.flock(boids);
    
    for (Disruptor a:disruptors) {
      b.attractRepulse(a);
    }
    
    b.update();
    b.draw();
  }
}

void keyPressed()
{
  if (key == ' ') {
    // Generate a new random boid system
    config.randomize();
    
    // Reset boids with new config
    for (Boid b:boids) {
      b.initialize();
    }
    
    // Remove disruptors
    disruptors.clear();
  }
}

void mouseClicked()
{
  if (mouseButton == LEFT) {
    disruptors.add(new Disruptor(false));
  } else if (mouseButton == RIGHT) {
    disruptors.add(new Disruptor(true));
  }
}
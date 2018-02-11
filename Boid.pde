class Boid
{
  private PVector position;
  private PVector velocity;
  private PVector acceleration;

  private Config config; 

  // The range of deviation from the default settings any individual boid will be.
  private float chaos;

  // Search range and weighting of separation instinct
  private float separationMultiplier;
  private float separationDistance;

  // Search range and weighting of alignment instinct  
  private float alignmentMultiplier;
  private float alignmentDistance;
  
  // Search range and weighting of cohesion instinct
  private float cohesionMultiplier;
  private float cohesionDistance;
  
  // Search range and weighting of attractors
  private float disruptorMultiplier;
  private float disruptorDistance;
  
  // Search range and weighting of colourizing
  private float colourizeMultiplier;
  private float colourizeDistance;
  
  private float maxSpeed;
  private float maxSteeringForce;

  private float radius;
  private PVector trueScreen;
  
  // This didn't work exactly as I wanted, but trueColour is supposed to be
  // A boid's initial colour, and colour is the current colour. As boids
  // get close to each other, colour would drift away from trueColour but
  // when the boid is alone again, it should return to trueColour. 
  private PVector trueColour;
  private PVector colour;


  private float chaos()
  {
    return random(-chaos, chaos);
  }

  public Boid()
  {
    config = new Config();
    initialize();
  }
  
  public Boid(Config providedConfig)
  {
    config = providedConfig;
    initialize();
  }
  
  private void initialize()
  {
    chaos = config.chaos;

    separationMultiplier =  ( config.separationMultiplier + chaos() );
    separationDistance = abs( config.separationDistance + chaos() ) * 100;

    alignmentMultiplier =   ( config.alignmentMultiplier + chaos() );
    alignmentDistance =  abs( config.alignmentDistance + chaos() ) * 100;

    cohesionMultiplier =    ( config.cohesionMultiplier + chaos() );
    cohesionDistance =   abs( config.cohesionDistance + chaos() ) * 100;
    
    disruptorMultiplier =   ( config.disruptorMultiplier + chaos() );
    disruptorDistance =  abs( config.disruptorDistance + chaos() ) * 100;
    
    colourizeMultiplier =   ( config.colourizeMultiplier + chaos()) / 50;
    colourizeDistance =  abs( config.colourizeDistance + chaos() ) * 100;

    maxSpeed = abs(config.maxSpeed + chaos());
    maxSteeringForce = config.maxSteeringForce;

    trueColour = new PVector(
        random(config.minHue, config.maxHue),
        random(config.minSaturation, config.maxSaturation),
        random(config.minBrightness, config.maxBrightness)
    );
    colour = trueColour;

    radius = random(config.minRadius, config.maxRadius);
    
    // The width of the worldspace for this boid
    trueScreen = new PVector(float(width) + radius, (height) + radius);

    position = new PVector(random(0, width), random(0, height));
    velocity = new PVector(
      random(-config.initialSpeed, config.initialSpeed),
      random(-config.initialSpeed, config.initialSpeed)
    );
    acceleration = new PVector(0, 0);
  }


  public void update()
  {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);

    acceleration.mult(0);

    position = screenwrap(position, trueScreen);
  }


  private void applyForce(PVector force)
  {
    acceleration.add(force);
  }


  public void flock(ArrayList<Boid> boids)
  {
    PVector separation = calculateSeparation(boids);
    PVector alignment = calculateAlignment(boids);
    PVector cohesion = calculateCohesion(boids);

    colourize(boids);

    applyForce(separation.mult(separationMultiplier));
    applyForce(alignment.mult(alignmentMultiplier));
    applyForce(cohesion.mult(cohesionMultiplier));
  }


  // Go to or away from a disruptor
  private void attractRepulse(Disruptor disruptor)
  {
    PVector point = disruptor.getPosition();
    
    float d = PVector.dist(position, point);
    if (d < disruptorDistance) {
      PVector desired = PVector.sub(point, position);
      desired.normalize();
      desired.mult(maxSpeed);

      PVector steer = new PVector(0, 0);
      steer = PVector.sub(desired, velocity);
      steer.limit(maxSteeringForce);
      
      if (disruptor.getType() == disruptorType.REPULSOR) {
        steer.mult(-1);
      }

      applyForce(steer.mult(disruptorMultiplier));
    }    
  }

  // Join the formation
  public PVector calculateCohesion(ArrayList<Boid> boids)
  {
    PVector steer = new PVector(0, 0);
    PVector sum = new PVector(0, 0);

    int count = 0;

    for (Boid b : boids) {
      float d = getTrueDistance(b, cohesionDistance);

      if (d >= 0) {
        sum.add(b.position);
        count++;
      }
    }

    if (count > 0) {
      sum.div(float(count));

      PVector desired = PVector.sub(sum, position);
      desired.normalize();
      desired.mult(maxSpeed);

      steer = PVector.sub(desired, velocity);
      steer.limit(maxSteeringForce);
    }

    return steer;
  }


  // Fly with my friends
  public PVector calculateAlignment(ArrayList<Boid> boids)
  {
    PVector steer = new PVector(0, 0);
    PVector sum = new PVector(0, 0);

    int count = 0;

    for (Boid b : boids) {
      float d = getTrueDistance(b, alignmentDistance);

      if (d >= 0) {
        sum.add(b.velocity);
        count++;
      }
    }

    if (count > 0) {
      sum.div(float(count));
      sum.normalize();
      sum.mult(maxSpeed);

      steer = PVector.sub(sum, velocity);
      steer.limit(maxSteeringForce);
    }

    return steer;
  }


  // Get Personal Space
  public PVector calculateSeparation(ArrayList<Boid> boids)
  {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Boid b : boids) {
      float d = getTrueDistance(b, separationDistance);

      if (d >= 0) {
        PVector delta = PVector.sub(position, b.position);
        delta.normalize();
        delta.div(d);
        steer.add(delta);
        count++;
      }
    }

    if (count < 0) {
      steer.div((float)count);
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxSteeringForce);
    }

    return steer;
  }
  

  // So, this function is weird. I don't really know what it's doing actually.
  // My intention was for each boid to have their own colour, and as they drew 
  // near to other boids, they would become more similar to them. But it didn't
  // Really work as I hoped. Fortunately, the effect was really interesting, so
  // I decided it wasn't worth the effort to fix. Frankly the strange pulsation
  // effect is cooler than what I was planning, so hurray for happy accidents!
  private void colourize(ArrayList<Boid> boids)
  {
    int sum = 0;
    // count is 1 because it's own colour should always affect it.
    int count = 1;

    for (Boid b : boids) {
      float d = getTrueDistance(b, colourizeDistance);

      if (d >= 0) {
        sum += b.colour.x;
        count++;
      }
    }

    sum += trueColour.x;
    sum /= count;
    sum %= 255;
    
    colour.x += int(sum * colourizeMultiplier);
    
    if (colour.x < 0) colour.x += 255;
    colour.x %= 255;
  }
  
  
  // This function was an attempt to fix the bug caused by
  // boids not being able to see past the edge of the screen.
  // I'm not completely sure it works, but I can't find any
  // fault in my logic.
  public float getTrueDistance(Boid b, float threshold)
  {
    PVector bPos = b.position.copy();
    PVector offsetFromCenter = PVector.sub(new PVector(width / 2.0 + radius, height / 2.0 + radius), b.position);
    bPos.add(offsetFromCenter);
    bPos = screenwrap(bPos, b.trueScreen);
    bPos.sub(offsetFromCenter);
    
    float d = 0.0;
    if (bPos != b.position) {    
      d = PVector.dist(position, bPos);
    } else {
      d = PVector.dist(position, b.position);
    }
    
    if (d < threshold && d > 0) {
      return d;
    } else {
      return -1;
    }
  }

  // Made it accept parameters because I wanted to be able
  // to non-destructively screenwrap other boids to find
  // out their real position relative to this boid.
  private PVector screenwrap(PVector pos, PVector trueScreen)
  {
    if (pos.x > trueScreen.x) pos.x = -radius;
    if (pos.x < -radius) pos.x = trueScreen.x;
    if (pos.y > trueScreen.y) pos.y = -radius;
    if (pos.y < -radius) pos.y = trueScreen.y;
    
    return pos;
  }


  public void draw()
  {
    float speed = velocity.mag() / maxSpeed;

    colorMode(HSB, 255);
    noStroke();
    fill(colour.x, colour.y * speed, 25 + colour.z * speed * 0.9);

    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());

    beginShape(QUAD);
    vertex(-radius*0.2, -radius/2);
    vertex(radius * speed, 0);
    vertex(-radius*0.2, radius/2);
    vertex(-radius * (0.2+speed), 0);
    endShape();
    popMatrix();
  }
}
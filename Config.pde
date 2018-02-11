// So this is cool. I wanted to have a way to randomize the default values
// nicely, and after a while of trying to cram it into the main file, I
// figured it made more sense to just create a class to handle it.

class Config
{
  // A bit of magic. High chaos increases the maximum disparity of 
  // weightings and other values between boids.  
  public float chaos;

  // Search range and weighting of separation instinct
  public float separationMultiplier;
  public float separationDistance;

  // Search range and weighting of alignment instinct  
  public float alignmentMultiplier;
  public float alignmentDistance;
  
  // Search range and weighting of cohesion instinct
  public float cohesionMultiplier;
  public float cohesionDistance;

  // Search range and weighting of disruptors
  public float disruptorMultiplier;
  public float disruptorDistance;
  
  // Search range and weighting of colourization effect
  public float colourizeMultiplier;
  public float colourizeDistance;
  
  // The max speed and steering force
  public float maxSpeed;
  public float maxSteeringForce;

  // Ranges for HVB colour values
  public int minHue;
  public int maxHue;  
  public int minSaturation;
  public int maxSaturation;  
  public int minBrightness;
  public int maxBrightness;

  // Starting Speed 
  public float initialSpeed;
  
  // Size
  public float minRadius;
  public float maxRadius;
  
  public Config()
  {
    chaos = 0.8;

    separationMultiplier =  1.0;
    separationDistance =    1.0;

    alignmentMultiplier =   1.0;
    alignmentDistance =     1.0;

    cohesionMultiplier =    1.0;
    cohesionDistance =      1.0;

    disruptorMultiplier = 1.0;
    disruptorDistance =   1.0;
    
    colourizeMultiplier =   1.0;
    colourizeDistance =     1.0;

    maxSpeed = 5.0;
    maxSteeringForce = 0.03;

    minHue = 0;
    maxHue = 255;
    
    minSaturation = 150;
    maxSaturation = 255;
    
    minBrightness = 150;
    maxBrightness = 255;

    initialSpeed = 2.0;
    minRadius = 10;
    maxRadius = 40;
  }
  
  public void randomize()
  {
    // Create a random global config each time the program is run, or on command.
    config.chaos = random(0.0, 1.5);
    
    config.separationMultiplier =  random(0.0, 3.0);
    config.separationDistance =    random(0.0, 3.0);
  
    config.alignmentMultiplier =   random(0.0, 3.0);
    config.alignmentDistance =     random(0.0, 3.0);
  
    config.cohesionMultiplier =    random(0.0, 3.0);
    config.cohesionDistance =      random(0.0, 3.0);
    
    config.disruptorMultiplier =   random(0.0, 5.0);
    config.disruptorDistance =     random(0.0, 5.0);
    
    config.colourizeMultiplier =   random(0.0, 3.0);
    config.colourizeDistance =     random(0.0, 3.0);
  
    config.maxSpeed = random(1.0, 5.0);
    config.maxSteeringForce = random(0.01, 0.1);
  
    config.minHue = int(random(0, 224));
    config.maxHue = int(random(config.minHue, 225));
    
    config.minSaturation = int(random(150, 224));
    config.maxSaturation = int(random(config.maxSaturation, 225));
    
    config.minBrightness = int(random(150, 224));
    config.maxBrightness = int(random(config.maxBrightness, 225));
  
    config.initialSpeed = random(0.0, config.maxSpeed);
    config.minRadius = random(3, 19);
    config.maxRadius = random(config.minRadius, 20);
  }
}
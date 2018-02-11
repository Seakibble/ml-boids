# ml-boids
My own custom boids implementation. Built using Processing 3.3.6.

I recently played around with the 'Boids' flocking algorithm. For anyone unfamiliar, it is an algorithm designed to produce complex interactions between a number of entities following simple rules. A new system is generated whenever the spacebar is pressed. Left clicking and right clicking place disruptors that either attract or repulse boids, respectively.

The rules are as follows:
- Separation: If a boid get's too close to another boid, it will attempt to move away.
- Alignment: If a boid is near other boids, it will fly in the same direction as them.
- Cohesion: If a boid is near other boid, it will try to move to the average position of its peers.

These rules can be set take effect at different ranges, and with varying severity of reactions. For instance. If the separation rule only activates if a boid is 20 pixels away, but is weighted really heavily, you'll be likely to get more sudden movements as boids drift near each other, then recoil quickly, whereas a larger range and lower weighting will probably result in more tranquil interactions.

My implementation randomly sets a base value for all boids in the system, then each boid deviates from this base up to a value specified in the config called 'chaos'.

Systems with high chaos will produce a wide range of boids, some of which will have conflicting sets of rules. This results in an unstable system. Systems with low chaos will be much more stable, since all the boids will be very similar. This does not mean there won't be interesting movement, but it will tend to be more predictable and less erratic.

In addition to chaos, my boids have randomized values for their size, forward velocity, rotational velocity and colour.


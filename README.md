# Aerodynamic Low Earth Orbit Satellite Simulation
## Dyanmic Simulation Monte Carlo - DSMC.m

### Introduction:

This is a program made using MATLAB. The purpose of the program is to predict the lifespan of the satellite given three different geometrical shapes representing various nose cones attached to the satellite. Those shapes would be known as a flat plate (in other words no nose cone), a half cylinder and a double wedge. It is fairly accurate and the relationship between the shapes is as predicted, furthermore the theorized best shape being the double wedge was confirmed by this analysis.  Using this software the team was able to fully understand what shape the nose cone should be and why. It was then asked later to implement a fourth scenario. In this case the satellite has four double wedge packages attached to it, but if the flow comes in at an awkward angle, it was determined to know that lifespan.
Walkthrough:

The entire code can be found in Appendix A. First the program is told a lot of information about the projected orbit and atmosphere of the satellite at 250 km above Earth’s crust.  Everything is taken into account from the speed of the satellite to the speed of the free particles, to the density of the particles and back to the area of the satellite. All information was obtained using mathematical formulas or using case studies. 
Next the program asks for a user input and based off of this input four different scenarios take place. As mentioned previously, there are ‘no nose cone,’ ‘half cylinder,’ ‘double wedge,’ and ‘a revolving four sided CubeSat.’ From these inputs different shapes are taken into account using a reference angle with the x-axis. For no nose cone the angle is 90 degrees, with a half cylinder the angle is randomly generated due to the fact that the angle is constantly changing tangent to a circle and thus when a particle strikes the circle  it is very hard to predict what angle it will create, thus being random. The double wedge angle is 32 degrees which is how our package for a double wedge has been designed. The rotating CubeSat was taken apart mathematically to find an average reference angle of 24.5 degrees for the proposed worst case scenario. 

For this application in free molecular flow, theoretically the smaller the angle the better the aerodynamic properties of the satellite. However, in the case of the rotating CubeSat, since we are adding 4 double wedge’s instead of one, the area is increased by a factor of 2.8 thus reducing its lifespan, the math of which can be seen in Appendix B. Below in Figure 1 you will see the results of each scenario. 

Now, the program knows everything about the atmosphere and the proposed satellite, for a set amount time, in this case T/100 where T is the period of your satellite orbit, the satellite is “thrown” particles at it. After the calculated number of particles impacting the satellite the loop stops with a calculation for the total force of the impacts with the satellite. This is achieved using rotational matrices and I = FΔt = mΔv. 

Finally, the program goes through one more loop which takes a change in distance and a time of 0 and runs the loop as long as the range of the orbit is above reentry range - 100km. For every time this loop is run the total energy of the impacts is calculated, because energy is equal to force times distance, then taking into account the current velocity of the satellite it recalculates the range when this range is found if it is below 100 km the loop stops.  t is then converted from seconds to days and the lifespan of the proposed satellite is printed on the screen, as can also be seen in the associated Word files. 

As we can see, the double wedge is best followed by the half cylinder. The rotating CubeSat is an utter failure in this position when you take into account the cost for making the rotating CubeSat in comparison to spending nothing for an aerodynamic package.  

### Simulation for LEO CubeSat using MatLAB Programming

* The first phase of the program defines variables and sets up simple equations describing the following:
    * Initial Orbital Velocity of the Satellite
    * Energy of the Satellite (sum of the kinetic energy and gravitational energy)
    * Period of the Satellite
    * Mass of Particles hitting the satellite per second
    * Satellite Distance 
* The following assumptions are made to solve the previous equations:
    * Change in time ~ 0.001s; This number is equivalent to one millisecond and is a reasonable change in time to use for an impulse equation.
    * The density of particles found at 250 km is ~5.94 * 10-8
    * The number of particles found at 250 km is ~1.7 * 1015
    * Sampling rate of 100
* In Phase II of the Program the interactive interface asks the user what type of nose cone is being used on the LEO Satellite. 
    * If selection “1” is made the user is working without a nose cone. The angle alpha, set angle between the nose cone and the x-axis, is 90 degrees.
    * If selection “2” is made the user is working with a double wedge nose cone. The angle alpha is 30 degrees.
    * If selection “3” is made the user is working with a half cylinder. The angle alpha is 0 degrees and will be revisited later.
* The third phases moves forward in calculating the orbit life of the previously selected satellite nose cone. 
    * For each condition above the program randomly generates a number from normal distribution that represents beta, the angle between the incoming particle and the x-axis. 
    * From the angle beta and a randomly generated particle velocity of 1150 (found by BCC group), the x and y components of the particle velocity are found.
    * Theta is found as the sum of angle alpha and beta. 
    * The angle Phi is equal to 2PI minus theta. 
    * The rotational matrix of Phi is found. 
    * The product of the rotational matrix of Phi and the initial velocity of the particle equals the final velocity of the particle. 
    * Using the conservation of momentum and the impulse equation the force from impulse on the particle is found. That same force is then used to find the change in velocity of the satellite. 
    * The final velocity of the satellite is found as the initial satellite velocity minus the change in velocity. 
    * The total force is found as the initial force plus the force from this collision. 
    * These calculations occur in a while loop for values where i (time value) is less than the period of the satellite divided by the sampling rate. 
    * As the calculations progress the collisions increase and the total force increases. The value of i eventually reaches some value where the time is equal to the period divided by the sampling ratio. At this point the total force and change in velocity are known for the set distance. 
* Once the while loop is exhausted and i is equal to the period of the satellite divided by the sampling rate the lifespan of the satellite is calculated. The second while loop calculates how many iterations of the first loop (increasing force) it will take to make the satellite re-enter the Earth’s orbit (Radial distance is greater than re-entry of 100 km)
    * After every interval the decreasing energy, radius and velocity of the satellite are recalculated. 
    * The time is accumulating while the previous values are decreasing. 
    * Eventually the Radius will be less than 100 km and the CubeSat will re-enter the Earth’s orbit. At this point the loop will stop and the resulting time will be the lifespan of the satellite in seconds. 




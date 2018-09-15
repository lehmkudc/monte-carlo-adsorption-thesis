# monte-carlo-adsorption-thesis
Monte Carlo Stepwise Adsorption simulation of hydrogen onto a theoretical framework (My Master's Thesis)
This is an extremely rough readme and simulation as this is meant as a readable framework for the time being. As the project moves closer to publication this setup will be iterating more towards a shippable state.


Hello! My name is Dustin Lehmkuhl and I am a Chemical Engineering Master's student at Rose-Hulman Institute of Technology. My advisor is Dr. Scott McClellan.

## GOAL   
Develop an Isotherm of a framework using a numerical simulation performed in R.

## ABSTRACT  


## General Theory and Methodology  
Typically when we want at-a-glance adsorption properties for a given substance, we refer to what is known as an Isotherm. This is a plot that describes how much of a given substance will adsorb to a substrate under a given temperature (T) and pressure (P). Since this is plot in 3 dimensions, it is typical to show develop this plot across various isotherms, or lines where temperature is constant.

Ideally, a simulation should be able to develop this isotherm so that engineers can use this information in their designs for adsorption systems. Most Isotherms being used today are developed from experimental data, and that process is often very expensive and time-consuming. If the process of simulation these adsorption frameworks becomes more effective at creating these isotherms, more complicated (and more expensive) framworks can be assessed for use in applications before even producing the substrate, determining whether or not the proposed framwork is suitable.


It is here I must note that this is merely an approximation method. There are various critical assumptions that must be made for a simulation like this to run within a reasonable time frame.

### Assumptions  
The Unit Cell:  
The most critical assumption we use for monte carlo step wise simulation is the notion of the Unit Cell. We assume that our framework is periodic in some directions, and is identified as a series of identical unit cells. This allows our simulation to only track the movement of particles of one unit cell and can therefore reduce hte number of particles by an almost infinite quanitity. We can then use the simulatied properties of the unit cell to determine ensemble properties about our system.

The Grand Canonical:  

The Trial Move:
Our simulation occurs in iterative steps called "Trial Moves". At each trial move, a particle can be moved, added, or removed based on some probability. Upon a theoretically "sufficient" number of trial moves, the simulation should adequately model a real physical system. These trial moves are not a measure of time in any way, and should not be considered as such. They are merely a step in a calculation hopefully towards reaching a finished answer. 

Particle Location Probability:  
While we have utilities to track individual physics of particles in terms of velocity, location, acceleration, etc., doing so requires so much more processing power that our simulation becomes useless. Instead of managing this with particle physics, we are instead only tracking locations of particles at various steps of the simulation, with each step being taken based on a probability of trial move. These probabilites of locations are determined by potential energy (in this case the Lennard-Jones potential energy funciton).

Potential Energy:
Between two particles, there exists some amount of interaction between them depending on the distance between them. To model the amount of attractive and repulsive forces they exert on eachother, we are using the Lennard-Jones potential energy. The higher the potential energy between these particles, the more unstable that system is and the more unlikely that arrangement is likely to occur. In general, when a trial move causes an increase in potential energy, the move is less likely to occur. This also means that a trial move which increases the overall stability of the system is more likely to occur. In the case of this simulation, we are keeping track of the potential energy shift between a given particle and all other particles in our unit cell.

Monte Carlo Markov Chain:
For our simulation, we are considering the simulation to be a "Markov Chain", where every step of our system depends entirely on the state of the system before the step. In other words, our simulation does not have "memory" and only determines the liklihood of a trial move using the information available "right then."

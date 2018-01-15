rm( list=ls())
library(scatterplot3d)
library(rgl)
source('Thesis/simulation_functions.R')

#============================================================
# Geographic Description of Unit Cell and Initial Particle locations
X.c <- 14.2*matrix( c( seq(10)/10 , rep(0.5,10), rep(0.5,10),
                       rep(0.5,10), seq(10)/10 , rep(0.5,10),
                       rep(0.5,10), rep(0.5,10), seq(10)/10 ),
                    ncol=3, byrow=F)

Space <-  c( max(X.c[,1]), max(X.c[,2]), max(X.c[,3]) )

X.h <- Space*matrix( c(0.5,0.5,0.6,
                       0.1,0.5,0.6,
                       0.2,0.7,0.4), 
                     nrow=3,ncol=3, byrow=TRUE)
#============================================================
# Simulation-Specific Variables
b.move <-  0.1
b.add <-  0.90
delx <- Space/10
iters <- 10000
#==============================================================
# Physical Parameters of System
P <- 100000*(1000) #Pa
Temp <- 77 #K
V <- Space[1]*Space[2]*Space[3] # A^3
kb <- 1.38064852*10^(-23) #Boltzmann's Constant [=] J/K , Pa*m^3/K
lilkb <- 1.38064852*10^(7) #kb [=] Pa*A^3/K
#==============================================================
# Molecule Interaction Parameters

# Lennard-Jones Parameters for h2-h2
s.hh <- 2.958 # Sigma [=] A 
e.hh <- 36.7  #36.7 #E/kb [=] K
  
# Lennard-Jones Parameters for h2-C
s.hc <- 3.216 # Sigma [=] A
e.hc <- 41.924 #E/kb [=] K
  
s.min <- 3.60984
#============================================================= 
# Running Space
N_t <- rep(0,iters)

for (i in 1:iters){
   X.h <- trial_run(X.h, X.c, delx, Space, Temp, V, P, lilkb, b.move, b.add)
   N_t[i] <- nrow(X.h)
}

b.move <- 0.9
b.add <- 0.5
N_s <- rep(0,iters)
for (i in 1:iters){
   X.h <- trial_run(X.h, X.c, delx, Space, Temp, V, P, lilkb, b.move, b.add)
   N_s[i] <- nrow(X.h)
}


#==================================================================
# Visualization and Ensemble Space
plot3d(X.h)

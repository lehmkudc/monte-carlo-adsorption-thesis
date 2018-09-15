graphene <- function( n ){
   # Generates a Sheet of graphene of approximate size n Angstoms by n Angstroms
   #  Outputs as Carbon location matrix
  i = 0:(n-1)
  x1 = 123 + i*246
  x2 = i*246
  
  j = 0:n
  y1 = j*(142+71)
  y2 = 71+j*(142+71)
  
  x = c()
  for (i in 1:(n+1)){
    if( i%%2 == 1){
      x = c( x, x1,x2)
    }else{
      x = c( x, x2,x1)
    }
  }
  x = x/100
  
  y = c()
  for (i in 1:(n+1)){
    y= c( y, rep(y1[i],n), rep(y2[i],n))
  }
  y = y/100
  z <- rep( 10, length(x))
  X.c <- matrix( c(x,y,z), ncol = 3)
  
  return(X.c)
} 

# dist <- function( object, others, Space){
#   # Distance in Angstroms
#   dx <- ifelse( abs(object[1] - others[,1]) >= Space[1]/2,
#                 abs(object[1] - others[,1])- Space[1]/2,abs(object[1] - others[,1])  )
#   dy <- ifelse( abs(object[2] - others[,2]) >= Space[2]/2,
#                 abs(object[2] - others[,2])- Space[2]/2,abs(object[2] - others[,2])  )
#   dz <- ifelse( abs(object[3] - others[,3]) >= Space[3]/2,
#                 abs(object[3] - others[,3])- Space[3]/2,abs(object[3] - others[,3])  )
#   dist <- sqrt( dx^2 + dy^2 + dz^2 )
#   return(dist)
# }

dist <- function( part, Others, Space ){
   # Calculates the euclidian distance between a particle and a set of particles
   #  while taking periodicity into account. Outputs as a vector of distances in A.
   # part = test particle
   # Others = the compared particles
   # Space = The unit cell dimensions for periodicity.
   #  If a dimension is non-periodic, space[axis] <- inf
   dis <- function( p, q, dc){
      return( ifelse( abs(p-q)>dc, abs(p-q)-dc, abs(p-q) ) )
   }
   dd <- t(apply(Others, 1, dis, part, Space/2) )
   return(apply( dd**2, 2, sum))
}

LJ <- function( dist , epsilon , sigma, Space){
  # Calculates potential Energy/kb in K from a vector of distances in A
  U <- 4*epsilon*( (sigma/dist)^12 - (sigma/dist)^6 )
  return(U)
}

move <- function( X.h , X.c , delx , Space , Temp){
   #Finds a random hydrogen particle in space 
   # determines a random location based on delx
   # Calculates the energy difference of move
   # Applies probability of movement
   # Accepts or declines trial move
   # Outputs as location matrix of hydrogen
  
  p <- 0
  if ( nrow(X.h) >= 3 ){
    id.o <- as.integer(runif(1)*nrow(X.h)) + 1 # Choose a particle to move
    
    U.oh <- LJ( dist(X.h[id.o,], X.h[-id.o,], Space), e.hh, s.hh ) # K
    U.oc <- LJ( dist(X.h[id.o,], X.c, Space), e.hc, s.hc ) # K
    U.o <- sum(U.oh) + sum(U.oc)  # K
    
    X.n <- (X.h[id.o,] + runif(3, 0, 1)*delx)%%Space #Potential new Location
    
    U.nh <- LJ( dist(X.n, X.h[-id.o,],Space), e.hh, s.hh ) # K
    U.nc <- LJ( dist(X.n, X.c,Space), e.hc, s.hc ) # K
    U.n <- sum(U.nh) + sum(U.nc) # K
    
    DU <- U.n - U.o # Difference in potential caused by move
    p <- min( c( 1, exp( DU/Temp) ) )
  } 
  
  if( runif(1) <= p){
    X.h[id.o,] <- X.n
  }
  
  return( X.h )
}
add <- function( X.h , X.c , Space, Temp , V, P , lilkb){
   #Finds a random location in space
   # Determines energy difference of addition
   # Applies probability of addition
   # Accepts or declines trial addition
   # Outputs as location matrix of hydrogen
  
  X.n <- runif(3)*Space
  
  U.h <- LJ( dist( X.n, X.h,Space ), e.hh, s.hh )
  U.c <- LJ( dist( X.n, X.c,Space ), e.hc, s.hc )
  DU <- sum(U.h) + sum(U.c)
  
  p <- min( c(1 , V*P/lilkb/Temp/(nrow(X.h)+1)*exp( -DU/Temp ) ) )
  if( runif(1) <= p){
    X.h <- rbind( X.h, as.vector(X.n))
  }
  
  return( X.h )
}
remove <- function( X.h , X.c , Space , Temp , V, P , lilkb){
   # Finds a random hydrogen in space
   # Determines energy difference of removal
   # Applies probability of removal
   # Accepts or declines trial removal
   # Outputs as location matrix of hydrogen
  p <- 0
  if ( nrow(X.h) >= 3 ){
    
  id.r <- as.integer(runif(1)*nrow(X.h)) + 1
  
  U.h <- LJ( dist( X.h[id.r,], X.h[-id.r,],Space ), e.hh, s.hh )
  U.c <- LJ( dist( X.h[id.r,], X.c,Space ), e.hc, s.hc )
  DU <- -sum(U.h) - sum(U.c)
  
  p <- min ( c(1 ,nrow(X.h)*lilkb*Temp/V/P*exp( -DU/Temp ) ))
  } 
  
  if( runif(1) <= p){
    X.h <- X.h[-id.r,]
  }
  
  return( X.h )
}

trial_run <- function(X.h, X.c, delx, Space, Temp, V, P, lilkb, b.move, b.add){
   # Determines which trial to perform based on iteration parameters
   # Performes the trial
   # Outputs as location matrix of hydrogen
   if( runif(1) <= b.move){
      X.h <- move( X.h , X.c , delx , Space , Temp)
   }else if( runif(1) <= b.add){
      X.h <- add( X.h , X.c , Space , Temp , V, P , lilkb)
   }else{
      X.h <- remove( X.h , X.c , Space , Temp , V, P , lilkb)
   }
   return(X.h)
}

avg_N <- function(){
   # Determines the theoretical amount of particles in unit cell
   #  based on ideal gas law.
   return( P*V/lilkb/Temp)
}
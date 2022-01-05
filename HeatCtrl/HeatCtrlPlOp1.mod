# HeatCtrkPlOp1.mod - Model for Presolve1
#######################################################################
#
# AMPL coding 
# Argonne, November 2015
# Anna Thuenen, University of Magdeburg, April 2017
# anna.thuenen@me.com
######################################################################

# Parameters

param N > 0, default 16;			# ... number of elements in x
param X > 0, default 1;				# ... size of domain in x
param hx := 1/N*X;				# ... step-size in x

param M > 0, default 32;			# ... number of elements in y
param Y > 0, default 2;				# ... size of domain in y
param hy := 1/M*Y;				# ... step-size in y

param Tf > 0, default 15;			# ... final time
param Tn > 0, default 16;			# ... number of elements in time
param ht := 1/Tn*Tf;				# ... step-size in time

param Tc, default 8;				# ... number of elements control
param r:=Tn/Tc, integer;			# ... state/control ratio

param L>0, default 9;				# ... number of possible locations
param W>0, default 1;				# ... number of actuators at one time step

# Sets 

set I      := 0..N;				# ... discretization index sets (space: x)
set J      := 0..M;				# ... discretization index sets (space: y)
set T      := 0..Tn;				# ... discretization index sets (time)

set TxI    := T cross I;			# ... sets of meshgrids
set TxJ    := T cross J;
set IxJ    := I cross J;
set TxIxJ  := T cross IxJ;

set locations:= 1..L;				# ... set of locations
set TxL	   := T cross locations;
set decoupl:=0..Tc-1 cross 2..r cross locations;

# Data

param locX{locations};				# ... x coordinate of locations
param locY{locations};				# ... y coordinate of locations
param kappa{IxJ}, default 0.01;			# ... thermal diffusivity


# Variables

var u{TxIxJ};					# ... solution of heat equation
var v{TxL};			# ... continous control
var w{TxL}, binary;		# ... binary control

# Solution of Presolve

param ul{TxIxJ cross TxL}, default 0;		# ... inhomogenous solution part
param uh{TxIxJ}, default 0;			# ... homogenous solution part

# Further parameters

param pi := 4*atan(1);				# ... pi
param eps:=1e-2;				# ... epsilon
param BigM:=2500;				# ... big M bound on v


# Desired final state
param udesired{IxJ};


# Save Instance Information
param Instance, symbolic;# Information for Rounding on fine Meshes
param FracControl, symbolic, default "";
param Twfrac;
param wfrac{0..Twfrac cross locations};


# Objective and constraints


minimize RegularObjective: hx*hy* sum{(i,j) in IxJ: i>0 && i<N && j>0 && j<M} ((u[Tn,i,j]-udesired[i,j])^2)
	   + 2*hx*hy*ht*( sum{(k,i,j) in TxIxJ: i>0 && i<N && j>0 && j<M && k>0 && k<Tn} (u[k ,i,j]^2)
			 +sum{(i,j) in IxJ: i>0 && i<N && j>0 && j<M} (u[0 ,i,j]^2+u[Tn,i,j]^2)/2 )
	   + ht/500 *   ( sum{(k,l) in TxL: k>0 && k<Tn} (v[k,l]^2)
			 +sum{l in locations}(0^2+v[Tn,l]^2)/2      );

minimize PresolvedObjective1: 
		hx*hy* sum{(i,j) in IxJ: i>0 && i<N && j>0 && j<M} (uh[Tn,i,j]
			+sum{(t,l) in TxL:t>0} (v[t,l]*ul[Tn,i,j,t,l]) -udesired[i,j] )^2
	   + 2*hx*hy*ht*( sum{(k,i,j) in TxIxJ: i>0 && i<N && j>0 && j<M && k>0 && k<Tn} (uh[k,i,j]
			+sum{(t,l) in TxL:t>0} (v[t,l]*ul[k,i,j,t,l]) )^2
			 +sum{(i,j) in IxJ: i>0 && i<N && j>0 && j<M} (uh[0,i,j]^2
				+(uh[Tn,i,j]+sum{(t,l) in TxL:t>0} (v[t,l]*ul[Tn,i,j,t,l]))^2)/2)

   + ht/500 *   ( sum{(k,l) in TxL: k>0 && k<Tn} (v[k,l]^2)
			 +sum{l in locations}(0^2+v[Tn,l]^2)/2      );

minimize DummyObjective: 0;

subject to
# ... discretization of heat equation: 5 point stencil in space and ... (choose one)

	# ... TRAPEZOIDAL rule in time

	Trapezoidal{(k,i,j) in TxIxJ: k<Tn && i>0 && i<N && j>0 && j<M}: -2/ht*(u[k+1,i,j]-u[k,i,j])
					  + kappa[i,j]/hx/hy*(u[k+1,i-1,j]+u[k+1,i+1,j]+u[k+1,i,j-1]+u[k+1,i,j+1]-4*u[k+1,i,j])
					  + kappa[i,j]/hx/hy*(u[k  ,i-1,j]+u[k  ,i+1,j]+u[k  ,i,j-1]+u[k  ,i,j+1]-4*u[k  ,i,j])
					= - 1/sqrt(2*pi*eps)* sum{l in locations} (exp(-( ((locX[l]-i)*hx)^2+((locY[l]-j)*hy)^2 )/2/eps) * v[k+1,l])
					  - 1/sqrt(2*pi*eps)* sum{l in locations} (exp(-( ((locX[l]-i)*hx)^2+((locY[l]-j)*hy)^2 )/2/eps) * v[k  ,l]);



	# ... EXPLICT euler in time

	ExplicitE{(k,i,j) in TxIxJ: k<Tn && i>0 && i<N && j>0 && j<M}: 1/ht*(u[k+1,i,j]-u[k,i,j]) =
					  + kappa[i,j]/hx/hy*(u[k  ,i-1,j]+u[k  ,i+1,j]+u[k  ,i,j-1]+u[k  ,i,j+1]-4*u[k  ,i,j])
					  + 1/sqrt(2*pi*eps)* sum{l in locations} (exp(-( ((locX[l]-i)*hx)^2+((locY[l]-j)*hy)^2 )/2/eps) * v[k  ,l]);


	# ... IMPLICT euler in time

	ImplicitE{(k,i,j) in TxIxJ: k<Tn && i>0 && i<N && j>0 && j<M}: 1/ht*(u[k+1,i,j]-u[k,i,j]) =
					  + kappa[i,j]/hx/hy*(u[k+1,i-1,j]+u[k+1,i+1,j]+u[k+1,i,j-1]+u[k+1,i,j+1]-4*u[k+1,i,j])
					  + 1/sqrt(2*pi*eps)* sum{l in locations} (exp(-( ((locX[l]-i)*hx)^2+((locY[l]-j)*hy)^2 )/2/eps) * v[k+1,l]);

# ... Dirichlet boundary conditions
	
	Dirichlet1{(k,j) in TxJ: k>0}: u[k, 0, j] = 0;
	Dirichlet2{(k,i) in TxI: k>0}: u[k, i, 0] = 0;
	Dirichlet3{(k,j) in TxJ: k>0}: u[k, N, j] = 0;
	Dirichlet4{(k,i) in TxI: k>0}: u[k, i, M] = 0;


# ... Bound on v
	
	UBV{(k,l) in TxL: k>0}: v[k,l] <= w[k,l] * BigM ;
	LBVu{(k,l) in TxL: k>0}: -w[k,l] * BigM <= v[k,l] ;
	LBVb{(k,l) in TxL: k>0}: 		 0 <= v[k,l] ;

# ... SOS conditions

	SOS{k in T: k>0}: sum{l in locations} w[k,l] = W;


# ... decoupling states and controls

	decouplingV{(k,i,l) in decoupl}: v[k*r+1,l]=v[k*r+i,l]; 
	decouplingW{(k,i,l) in decoupl}: w[k*r+1,l]=w[k*r+i,l]; 



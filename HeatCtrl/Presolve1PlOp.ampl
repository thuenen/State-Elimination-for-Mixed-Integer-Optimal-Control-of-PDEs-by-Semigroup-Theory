# Presolve1PlOp.ampl  - AMPL script for Presolve I
# with standard setting: implicit euler and unbounded v
# for different settings, please change the coding

include ipopt.ampl;

param __TimePresolve default 0;

# ... set-up PDE only
	# ... change the discretization if needed (ImplicitE, ExplicitE, Trapezoidal)
problem SolvePDE: u, ImplicitE, Dirichlet1, Dirichlet2, Dirichlet3, Dirichlet4, DummyObjective;

# ... fix all weights to zero
fix {(k,l) in TxL: k>0} v[k,l] := 0;

fix{(i,j) in IxJ} u[0,i,j]; #Ampl bug
solve SolvePDE;
let {(k,i,j) in TxIxJ} uh[k,i,j] := u[k,i,j]; # Save homogeneous solution

for {(t,l) in TxL: t>0}{
   fix v[t,l] := 1;
   fix{(i,j) in IxJ} u[0,i,j]; #Ampl bug
   solve SolvePDE;
   let __TimePresolve := __TimePresolve + _solve_elapsed_time;
   display _solve_elapsed_time;
   let {(k,i,j) in TxIxJ} ul[k,i,j,t,l] := u[k,i,j]- uh[k,i,j];
   fix v[t,l] := 0;
}


# ... unfix weights for subsequent optimization run
unfix {(k,l) in TxL: k>0} v[k,l];
display __TimePresolve;

problem Presolved: v,w, SOS, PresolvedObjective1, LBVu, UBV, decouplingV, decouplingW; #Ampl bug

delete RegularObjective, DummyObjective, ImplicitE, Dirichlet1, Dirichlet2, Dirichlet3, Dirichlet4;

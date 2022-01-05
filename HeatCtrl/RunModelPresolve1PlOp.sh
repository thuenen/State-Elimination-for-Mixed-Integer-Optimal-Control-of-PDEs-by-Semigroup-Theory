#!/bin/bash

##############################################################################
# Run Model (Actuator Placement and Operation)
#    $1 = Rounding Scheme or MIQP (e.g. CPLEX) / QP (e.g. IPOPT) solver
#    $2 = instance dat file with a list of instances
#
# Argonne, November 2015
# Anna Thuenen, University of Magdeburg, April 2017
# anna.thuenen@me.com
######################################################################

SOLVER=$1
DATA=$2

   function RunInstance {
  	echo "Running " $1 " on Heat Equation with Actuator Placement and Operation and the following data settings:" $2
 
       hostname >  output/$1-$2-presolved1-PlOp.out
       uptime   >> output/$1-$2-presolved1-PlOp.out
	ampl -R HeatCtrlPlOp1.mod Instances/$2.dat Presolve1PlOp.ampl $1.ampl solve.ampl BuildSol1PlOp.ampl DisplayTime.ampl PlotPlOp.ampl >> output/$1-$2-presolved1-PlOp.out
       
	}
# ... run all instances
for i in `cat $2`
do 
  RunInstance $SOLVER $i
done

# nohup ./RunModelPresolve1PlOp.sh ipopt RunModelPresolve1PlOp.txt > output/ipopt.out 2> output/ipopt.err < /dev/null &

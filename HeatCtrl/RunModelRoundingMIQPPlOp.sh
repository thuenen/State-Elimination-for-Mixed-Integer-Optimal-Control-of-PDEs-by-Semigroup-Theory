#!/bin/bash

##############################################################################
# Run Model (Actuator Placement and Operation)
#    $1 = Rounding Scheme
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
 
       hostname >  output/cplex-$1-$2-presolved-PlOp.out
       uptime   >> output/$1-$2-presolved-PlOp.out
       ampl -R HeatCtrlPlOp.mod Instances/$2.dat PresolvePlOp.ampl $1.ampl solve.ampl BuildSolPlOp.ampl DisplayTime.ampl unfixW.ampl cplex.ampl solve.ampl DisplayTime.ampl SaveControlsPlOp.ampl PlotPlOp.ampl >> output/cplex-$1-$2-presolved-PlOp.out
       cp $2-W-temp.out controls/cplex-$1-$2-PlOp-W.out
       cp $2-V-temp.out controls/cplex-$1-$2-PlOp-V.out
       rm $2-W-temp.out
       rm $2-V-temp.out
	}
# ... run all instances
for i in `cat $2`
do 
  RunInstance $SOLVER $i
done

# nohup ./RunModelPresolvePlOp.sh Rounding3aPlOp RunModelPlOp.txt > output/Rcplex.out 2> output/Rcplex.err < /dev/null &

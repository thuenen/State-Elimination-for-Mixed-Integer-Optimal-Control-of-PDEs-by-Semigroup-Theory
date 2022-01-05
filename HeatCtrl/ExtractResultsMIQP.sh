#!/bin/bash 
# 
# for fn in cplex*-presolved.out ; do  ./ExtractResultsMIQP.sh $fn >> output.txt; done 
FN=$1 
# search for lines which begin with 'Objective', save third collmun as ERG, then print ERG when file end reached
OBJECTIVE=`awk '$1 ~ /^CPLEX/ { ERG= $11; } END { print ERG;} ' $FN`
TIME_PRESOLVE=`awk '$1 ~ /^__TimePresolve/ { ERG= $3; } END { print ERG;} ' $FN`
TIME_SOLVE=`awk '$1 ~ /^__TimeSolve/ { ERG= $3; } END { print ERG;} ' $FN`
NODES=`awk '$2 ~ /^branch/ { ERG= $1; } END { print ERG;} ' $FN`

# print results, basename truncates '.out'
echo "`basename $FN .out` , $OBJECTIVE, $TIME_PRESOLVE , $TIME_SOLVE, $NODES"


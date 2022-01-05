# This script ensures for SUR approaches that even in the first time steps we chose a location
# the fill in will be proceed via the numbering of the locations
for{k in 0..Tc-1}{
	for {l in locations}{
	if (actuator[k]<W && w[r*k+1,l]=0) then { fix{i in 1..r} w[r*k+i,l]:=1;
					      let actuator[k]:=actuator[k]+1;}#end if
	}#end for
}#end for

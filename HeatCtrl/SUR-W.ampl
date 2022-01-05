for {k in 0..(Tc-1)}{
		let relaxSum := relaxSum + w[r*k+1,l0];
		if (relaxSum-roundSum > 0.5)
			then {	fix{i in 1..r} w[r*k+i,l0]    := 1;
				let roundSum := roundSum+1;
				let actuator[k]:= actuator[k]+1;
				if (actuator[k]=W)
					then fix {(i,ll) in 1..r cross locations: open[ll]=0} w[r*k+i,ll]:=0;
				}
			else fix{i in 1..r} w[r*k+i,l0] := 0;
		}
		let relaxSum := 0;
		let roundSum := 0;

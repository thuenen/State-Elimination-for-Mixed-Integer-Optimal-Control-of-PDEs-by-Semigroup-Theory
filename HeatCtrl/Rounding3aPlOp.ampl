# Rounding approach 3a) Knapsack-Sum-up-Rounding for v*w without resolve for Heat Equation with Actuator Placement and Operation

param __TimeRounding default 0;

if (FracControl = "") then {
	include ipopt.ampl;
	include solve.ampl;
	let __TimeRounding := __TimeRounding + _solve_elapsed_time;
	display __TimeRounding;
	};

var s default 0;
var ww{TxL} default 0;
var res{TxL} default 0;
var l0 >= 0;
set l_argmax ordered;


for {k in 0..(Tc-1)}{
	include Rounding3V.ampl;
}

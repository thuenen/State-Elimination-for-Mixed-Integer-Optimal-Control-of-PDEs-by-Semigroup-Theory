let {(k,i,j) in TxIxJ} u[k,i,j] :=  sum{(t,l) in TxL: t>0} (v[t,l]*ul[k,i,j,t,l]) + uh[k,i,j];

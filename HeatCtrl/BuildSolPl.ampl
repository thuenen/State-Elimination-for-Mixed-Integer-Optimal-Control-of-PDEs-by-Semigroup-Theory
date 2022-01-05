let {(k,i,j) in TxIxJ} u[k,i,j] :=  sum{(t,l) in TxL: t>0 && t<=k} (w[t,l]*ul[k-t+1,i,j,l]) + uh[k,i,j];

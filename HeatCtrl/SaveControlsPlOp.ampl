printf ">>> Save Controls ..\n";

for {(k,l) in TxL} { printf "%16.16f\t", w[k,l] >> (Instance & "-W-temp.out"); }
for {(k,l) in TxL} { printf "%16.16f\t", v[k,l] > (Instance & "-V-temp.out"); }

printf ">>> Done.\n";

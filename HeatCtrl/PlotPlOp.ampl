
printf ">>> Paste commands below in Matlab or Octave\n";
printf "    ========================================\n\n\n";
printf "\% Matlab output of states, u(t,x,y)\n";

for{k in T}{
   printf "u{%i} = [ ...    \% states u(k,x,y)\n", k+1;
   for {i in I}{
      			printf{j in J} "  %G", u[k,i,j];
printf " ;\n";   };
printf "];";
printf "\n\n";}; 
printf "\n\n";
printf "w = [ ... \% binary control \n";
for{k in T: k>0} {
   for{ll in locations} { printf "  %G  ", w[k,ll]; }
   printf " ; \n ";
}
printf "];";
printf "\n\n";

printf "v = [ ... \%  continous control \n";
for{k in T: k>0} {
   for{ll in locations} { printf "  %G  ", v[k,ll]; }
   printf " ; \n ";
}
printf "];";
printf "\n\n";

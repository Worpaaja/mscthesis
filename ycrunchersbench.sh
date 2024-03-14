#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir $dirname;

#For loop for multiple runs of y-cruncher
#number of loops is set in the arguments
for i in $(seq $1); # to use vargs, find out why $1 only runs 1
do
	#y-cruncher ran with no pauses, skip warnings, no digitals in output and 500 000 000 pi digits, output saved to a folder with date and time
	./y-cruncher skip-warnings pause:-2 bench 500m -od:0 -o $dirname;
done

touch summary_$dirname.txt
summarum="0"
for filename in $dirname/*.txt;
do
	grep -i 'Total Computation Time' -F "$filename" >> summary_$dirname.txt
	summarum=$(awk -v  sum1="$summarum" -v sum2="$(grep -i 'Total Computation time' -F "$filename" | cut -d ' ' -f 7)" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
done

#Adding the mean of runs to the summary file
summarum=$(awk -v  dividend="$summarum" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 
echo "Mean of all runs:" >> summary_$dirname.txt
echo "$summarum" >> summary_$dirname.txt
cat summary_$dirname.txt

#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir ycrunchbenchmark;
mkdir ycrunchbenchmark/$dirname;

#For loop for multiple runs of y-cruncher
#number of loops is set in the arguments


for i in $(seq $1);
do
	#y-cruncher ran with no pauses, skip warnings, no digitals in output and 500 000 000 pi digits, output saved to a folder with date and time
	./y-cruncher skip-warnings pause:-2 bench 500m -od:0 -o ycrunchbenchmark/$dirname;
done


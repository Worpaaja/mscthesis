#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir streambenchmark;
mkdir streambenchmark/$dirname;

#For loop for multiple runs of STREAM
#number of loops is set in the arguments


for i in $(seq $1);
do
	#stream ran with default settings, compiled from C with gcc -O stream.c -o stream
	./stream > streambenchmark/$dirname/$i.txt;
done


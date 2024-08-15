#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir sysbench_cpu;
mkdir sysbench_cpu/$dirname;

#For loop for multiple runs of sysbench cpu
#number of loops is set in the arguments

for i in $(seq $1);
do
	#sysbench cpu test ran with given max prime number(10 000) and 4 threads which is the number of threads for used CPU, execution cut off time set at 60s(1minute)
	sysbench --threads=4 --time=60 cpu --cpu-max-prime=10000 run > sysbench_cpu/$dirname/$i.txt;
done


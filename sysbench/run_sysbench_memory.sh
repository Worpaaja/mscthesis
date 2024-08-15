#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir sysbench_mem;
mkdir sysbench_mem/$dirname;

mkdir sysbench_mem/$dirname/seqw;
mkdir sysbench_mem/$dirname/seqr;
mkdir sysbench_mem/$dirname/randr;
mkdir sysbench_mem/$dirname/randw;

#For loop for multiple runs of sysbench memory test
#number of loops is set in the arguments

#4 different test cases, sequential write, sequential read, random write, random read, other than that, all defaults
echo "Starting sequential write: "
#Seq write
for i in $(seq $1);
do
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and sequential write, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=60 memory --memory-access-mode=seq --memory-oper=write run > sysbench_mem/$dirname/seqw/$i.txt;
done
echo "Sequential write done, starting sequential read: "

#Seq read
for i in $(seq $1);
do	
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and sequential read, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=60 memory --memory-access-mode=seq --memory-oper=read run > sysbench_mem/$dirname/seqr/$i.txt;
done
echo "Seqeuntial read done, starting random write"

#Rand write
for i in $(seq $1);
do
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and random write, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=60 memory --memory-access-mode=rnd --memory-oper=write run > sysbench_mem/$dirname/randw/$i.txt;
done
echo "Random write done, starting random read"

#rand read
for i in $(seq $1);
do
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and random read
	sysbench --threads=4 --time=60 memory --memory-access-mode=rnd --memory-oper=read run > sysbench_mem/$dirname/randr/$i.txt;
done
echo "Random read done"




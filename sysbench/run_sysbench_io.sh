#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir sysbench_fileio;
mkdir sysbench_fileio/$dirname;
mkdir sysbench_fileio/$dirname/seqw;
mkdir sysbench_fileio/$dirname/seqr;
mkdir sysbench_fileio/$dirname/seqrw;
mkdir sysbench_fileio/$dirname/randw;
mkdir sysbench_fileio/$dirname/randr;

#For loop for multiple runs of sysbench file io
#number of loops is set in the arguments

for i in $(seq $1);
do
	sysbench fileio prepare --file-total-size=1G > /dev/null
	
	#sysbench fileio test ran with sequential read and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=seqrd run --file-total-size=1G > sysbench_fileio/$dirname/seqr/$i.txt;
	
	sysbench fileio cleanup
	sysbench fileio prepare --file-total-size=1G > /dev/null
	
	#sysbench fileio test ran with sequential rewrite and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=seqrewr run --file-total-size=1G > sysbench_fileio/$dirname/seqrw/$i.txt;
	
	sysbench fileio cleanup
	sysbench fileio prepare --file-total-size=1G > /dev/null
	
	#sysbench fileio test ran with random write and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=rndwr run --file-total-size=1G > sysbench_fileio/$dirname/randw/$i.txt;
	
	sysbench fileio cleanup
	sysbench fileio prepare --file-total-size=1G > /dev/null
	
	#sysbench fileio test ran with random read and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=rndrd run --file-total-size=1G > sysbench_fileio/$dirname/randr/$i.txt;	
	
	sysbench fileio cleanup
	sysbench fileio prepare --file-total-size=1G > /dev/null
	
	#sysbench fileio test ran with sequential write and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=seqwr run --file-total-size=1G > sysbench_fileio/$dirname/seqw/$i.txt;
	
	sysbench fileio cleanup
	
done



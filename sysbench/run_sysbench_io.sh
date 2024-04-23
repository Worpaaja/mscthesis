#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir benchmark_fileio;
mkdir benchmark_fileio/$dirname;
mkdir benchmark_fileio/$dirname/seqw;
mkdir benchmark_fileio/$dirname/seqr;
mkdir benchmark_fileio/$dirname/seqrw;
mkdir benchmark_fileio/$dirname/randw;
mkdir benchmark_fileio/$dirname/randr;

#For loop for multiple runs of sysbench file io
#number of loops is set in the arguments

for i in $(seq $1);
do
	sysbench fileio prepare --file-total-size=1G
	
	#sysbench fileio test ran with sequential read and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=seqrd run --file-total-size=1G > benchmark_fileio/$dirname/seqr/$i.txt;
	
	#sysbench fileio test ran with sequential rewrite and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=seqrewr run --file-total-size=1G > benchmark_fileio/$dirname/seqrw/$i.txt;
	
	#sysbench fileio test ran with random write and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=rndwr run --file-total-size=1G > benchmark_fileio/$dirname/randw/$i.txt;
	
	#sysbench fileio test ran with random read and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=rndrd run --file-total-size=1G > benchmark_fileio/$dirname/randr/$i.txt;	
	
		#sysbench fileio test ran with sequential write and 4 threads which is the number of threads for used CPU, maximum execution time set at 60s(1 minutes)
	sysbench --threads=4 --time=60 fileio --file-test-mode=seqwr run --file-total-size=1G > benchmark_fileio/$dirname/seqw/$i.txt;
	
	sysbench fileio cleanup
	
done


touch benchmark_fileio/summary_$dirname.txt
echo -e "Sysbench File I/O tests started at $dirname \n \n" >> benchmark_fileio/summary_$dirname.txt

seqw_opers="0";seqw_thr="0";seqw_fs="0";
seqr_opers="0";seqr_thr="0";
seqrw_opers="0";seqrw_thr="0";seqrw_fs="0";
randr_opers="0";randr_thr="0";
randw_opers="0";randw_thr="0";randw_fs="0";

for i in $(seq $1)
do	
	#Seq write
	echo -e "Run number $i\nSequential write:" >> benchmark_fileio/summary_$dirname.txt
	echo -e "\tFile operations:"  >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "writes/s" -F "benchmark_fileio/$dirname/seqw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "fsyncs/s" -F "benchmark_fileio/$dirname/seqw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	echo -e "\tThroughput:\n\t$(grep -i "written, MiB/s" -F "benchmark_fileio/$dirname/seqw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	
	seqw_thr=$(awk -v  sum1="$seqw_thr" -v sum2="$(grep -i 'written, MiB/s' -F "benchmark_fileio/$dirname/seqw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_opers=$(awk -v  sum1="$seqw_opers" -v sum2="$(grep -i 'writes/s' -F "benchmark_fileio/$dirname/seqw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	seqw_fs=$(awk -v  sum1="$seqw_fs" -v sum2="$(grep -i 'fsyncs/s' -F "benchmark_fileio/$dirname/seqw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	
	#Seq read
	echo "Sequential read:" >> benchmark_fileio/summary_$dirname.txt
	
	echo -e "\tFile operations:"  >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "reads/s" -F "benchmark_fileio/$dirname/seqr/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt
	echo -e "\tThroughput:\n\t$(grep -i "read, MiB/s" -F "benchmark_fileio/$dirname/seqr/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	
	seqr_thr=$(awk -v  sum1="$seqr_thr" -v sum2="$(grep -i 'read, MiB/s' -F "benchmark_fileio/$dirname/seqr/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqr_opers=$(awk -v  sum1="$seqr_opers" -v sum2="$(grep -i 'reads/s' -F "benchmark_fileio/$dirname/seqr/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	#Seq rewrite
	echo "Sequential rewrite:" >> benchmark_fileio/summary_$dirname.txt
	
	echo -e "\tFile operations:"  >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "writes/s" -F "benchmark_fileio/$dirname/seqrw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "fsyncs/s" -F "benchmark_fileio/$dirname/seqrw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	echo -e "\tThroughput:\n\t$(grep -i "written, MiB/s" -F "benchmark_fileio/$dirname/seqrw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	
	seqrw_thr=$(awk -v  sum1="$seqrw_thr" -v sum2="$(grep -i 'written, MiB/s' -F "benchmark_fileio/$dirname/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqrw_opers=$(awk -v  sum1="$seqrw_opers" -v sum2="$(grep -i 'writes/s' -F "benchmark_fileio/$dirname/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	seqrw_fs=$(awk -v  sum1="$seqrw_fs" -v sum2="$(grep -i 'fsyncs/s' -F "benchmark_fileio/$dirname/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	
	#Rand write
	echo "Random write:" >> benchmark_fileio/summary_$dirname.txt
	
	echo -e "\tFile operations:"  >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "writes/s" -F "benchmark_fileio/$dirname/randw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "fsyncs/s" -F "benchmark_fileio/$dirname/randw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	echo -e "\tThroughput:\n\t$(grep -i "written, MiB/s" -F "benchmark_fileio/$dirname/randw/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	
	randw_thr=$(awk -v  sum1="$randw_thr" -v sum2="$(grep -i 'written, MiB/s' -F "benchmark_fileio/$dirname/randw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randw_opers=$(awk -v  sum1="$randw_opers" -v sum2="$(grep -i 'writes/s' -F "benchmark_fileio/$dirname/randw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	randw_fs=$(awk -v  sum1="$randw_fs" -v sum2="$(grep -i 'fsyncs/s' -F "benchmark_fileio/$dirname/randw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	
	#Rand read
	echo "Random read:" >> benchmark_fileio/summary_$dirname.txt
	
	echo -e "\tFile operations:"  >> benchmark_fileio/summary_$dirname.txt
	echo -e "\t$(grep -i "reads/s" -F "benchmark_fileio/$dirname/randr/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt
	echo -e "\tThroughput:\n\t$(grep -i "read, MiB/s" -F "benchmark_fileio/$dirname/randr/$i.txt" | tr -s " ")" >> benchmark_fileio/summary_$dirname.txt	
	
	randr_thr=$(awk -v  sum1="$randr_thr" -v sum2="$(grep -i 'read, MiB/s' -F "benchmark_fileio/$dirname/randr/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randr_opers=$(awk -v  sum1="$randr_opers" -v sum2="$(grep -i 'reads/s' -F "benchmark_fileio/$dirname/randr/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	echo -e "\n" >> benchmark_fileio/summary_$dirname.txt
done

#Adding the means of runs to the summary file
seqw_opers=$(awk -v  dividend="$seqw_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqw_thr=$(awk -v  dividend="$seqw_thr" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqw_fs=$(awk -v  dividend="$seqw_fs" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 

seqr_opers=$(awk -v  dividend="$seqr_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqr_thr=$(awk -v  dividend="$seqr_thr" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )

seqrw_opers=$(awk -v  dividend="$seqrw_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqrw_thr=$(awk -v  dividend="$seqrw_thr" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqrw_fs=$(awk -v  dividend="$seqrw_fs" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )

randw_opers=$(awk -v  dividend="$randw_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randw_thr=$(awk -v  dividend="$randw_thr" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randw_fs=$(awk -v  dividend="$randw_fs" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 

randr_opers=$(awk -v  dividend="$randr_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randr_thr=$(awk -v  dividend="$randr_thr" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )

echo -e "\nMeans of all runs:" >> benchmark_fileio/summary_$dirname.txt
echo -e "Sequential write: \n\t Write operations: $seqw_opers/s  fsyncs $seqw_fs/s  written $seqw_thr MiB/s" >> benchmark_fileio/summary_$dirname.txt
echo -e "Sequential read: \n\t Read operations: $seqr_opers/s  read $seqr_thr MiB/s" >> benchmark_fileio/summary_$dirname.txt
echo -e "Sequential rewrite:\n\t Write operations: $seqrw_opers/s  fsyncs $seqrw_fs/s  written $seqrw_thr MiB/s" >> benchmark_fileio/summary_$dirname.txt
echo -e "Random write: \n\t Write operations: $randw_opers/s  fsyncs $randw_fs/s  written $randw_thr MiB/s" >> benchmark_fileio/summary_$dirname.txt
echo -e "Random read: \n \t Read operations: $randr_opers/s  read $randr_thr MiB/s" >> benchmark_fileio/summary_$dirname.txt

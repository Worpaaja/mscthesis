#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir benchmark_mem;
mkdir benchmark_mem/$dirname;

mkdir benchmark_mem/$dirname/seqw;
mkdir benchmark_mem/$dirname/seqr;
mkdir benchmark_mem/$dirname/randr;
mkdir benchmark_mem/$dirname/randw;

#For loop for multiple runs of sysbench memory test
#number of loops is set in the arguments

#4 different test cases, sequential write, sequential read, random write, random read, other than that, all defaults
echo "Starting sequential write: "
#Seq write
for i in $(seq $1);
do
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and sequential write, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=60 memory --memory-access-mode=seq --memory-oper=write run > benchmark_mem/$dirname/seqw/$i.txt;
done
echo "Sequential write done, starting sequential read: "

#Seq read
for i in $(seq $1);
do	
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and sequential read, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=60 memory --memory-access-mode=seq --memory-oper=read run > benchmark_mem/$dirname/seqr/$i.txt;
done
echo "Seqeuntial read done, starting random write"

#Rand write
for i in $(seq $1);
do
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and random write, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=60 memory --memory-access-mode=rnd --memory-oper=write run > benchmark_mem/$dirname/randw/$i.txt;
done
echo "Random write done, starting random read"

#rand read
for i in $(seq $1);
do
	#sysbench mem test ran with 4 threads which is the number of threads for used CPU and random read
	sysbench --threads=4 --time=60 memory --memory-access-mode=rnd --memory-oper=read run > benchmark_mem/$dirname/randr/$i.txt;
done
echo "Random read done"

touch benchmark_mem/summary_$dirname.txt
echo -e "Sysbench memory test started at $dirname \n \n" >> benchmark_mem/summary_$dirname.txt

seqw_time="0";seqw_opers="0";seqw_speed="0"
seqr_time="0";seqr_opers="0";seqr_speed="0"
randw_time="0";randw_opers="0";randw_speed="0"
randr_time="0";randr_opers="0";randr_speed="0"

#Total time, operations per second and speed
for i in $(seq $1)
do	
	#Seq write
	echo -e "Run number $i\nSequential write:" >> benchmark_mem/summary_$dirname.txt
	echo -e "\t$(grep -i 'total time' -F "benchmark_mem/$dirname/seqw/$i.txt" | tr -s " " | cut -b 2-)" >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/seqw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")"
	echo -e "\tOperations per second: $line"  >> benchmark_mem/summary_$dirname.txt

	line="$(grep -i 'transferred' -F "benchmark_mem/$dirname/seqw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d "/)a-z")"
	echo -e "\tTransfer speed: $line/s"  >> benchmark_mem/summary_$dirname.txt
	
	seqw_time=$(awk -v  sum1="$seqw_time" -v sum2="$(grep -i 'total time' -F "benchmark_mem/$dirname/seqw/$i.txt" | tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_opers=$(awk -v  sum1="$seqw_opers" -v sum2="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/seqw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	seqw_speed=$(awk -v  sum1="$seqw_speed" -v sum2="$(grep -i 'transferred' -F "benchmark_mem/$dirname/seqw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	
	#Seq read
	echo "Sequential read:" >> benchmark_mem/summary_$dirname.txt
	
	echo -e "\t$(grep -i 'total time' -F "benchmark_mem/$dirname/seqr/$i.txt" | tr -s " " | cut -b 2-)" >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/seqr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")"
	echo -e "\tOperations per second: $line"  >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'transferred' -F "benchmark_mem/$dirname/seqr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d "/)a-z")"
	echo -e "\tTransfer speed: $line/s"  >> benchmark_mem/summary_$dirname.txt
	seqr_time=$(awk -v  sum1="$seqr_time" -v sum2="$(grep -i 'total time' -F "benchmark_mem/$dirname/seqr/$i.txt" | tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqr_opers=$(awk -v  sum1="$seqr_opers" -v sum2="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/seqr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	seqr_speed=$(awk -v  sum1="$seqr_speed" -v sum2="$(grep -i 'transferred' -F "benchmark_mem/$dirname/seqr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	#Rand write
	echo "Random write:" >> benchmark_mem/summary_$dirname.txt
	
	echo -e "\t$(grep -i 'total time' -F "benchmark_mem/$dirname/randw/$i.txt" | tr -s " " | cut -b 2-)" >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/randw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")"
	echo -e "\tOperations per second: $line"  >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'transferred' -F "benchmark_mem/$dirname/randw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d "/)a-z")"
	echo -e "\tTransfer speed: $line/s"  >> benchmark_mem/summary_$dirname.txt
	randw_time=$(awk -v  sum1="$randw_time" -v sum2="$(grep -i 'total time' -F "benchmark_mem/$dirname/randw/$i.txt" | tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randw_opers=$(awk -v  sum1="$randw_opers" -v sum2="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/randw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	randw_speed=$(awk -v  sum1="$randw_speed" -v sum2="$(grep -i 'transferred' -F "benchmark_mem/$dirname/randw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	
	#Rand read
	echo "Random read:" >> benchmark_mem/summary_$dirname.txt
	
	echo -e "\t$(grep -i 'total time' -F "benchmark_mem/$dirname/randr/$i.txt" | tr -s " " | cut -b 2-)" >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")"
	echo -e "\tOperations per second: $line"  >> benchmark_mem/summary_$dirname.txt
	line="$(grep -i 'transferred' -F "benchmark_mem/$dirname/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d "/)a-z")"
	echo -e "\tTransfer speed: $line/s"  >> benchmark_mem/summary_$dirname.txt
	randr_time=$(awk -v  sum1="$randr_time" -v sum2="$(grep -i 'total time' -F "benchmark_mem/$dirname/randr/$i.txt"| tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randr_opers=$(awk -v  sum1="$randr_opers" -v sum2="$(grep -i 'Total operations' -F "benchmark_mem/$dirname/randr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	randr_speed=$(awk -v  sum1="$randr_speed" -v sum2="$(grep -i 'transferred' -F "benchmark_mem/$dirname/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-z")" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	echo -e "\n" >> benchmark_mem/summary_$dirname.txt
done

#Adding the means of runs to the summary file
seqw_opers=$(awk -v  dividend="$seqw_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqw_time=$(awk -v  dividend="$seqw_time" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqw_speed=$(awk -v  dividend="$seqw_speed" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 

seqr_opers=$(awk -v  dividend="$seqr_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqr_time=$(awk -v  dividend="$seqr_time" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
seqr_speed=$(awk -v  dividend="$seqr_speed" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 

randw_opers=$(awk -v  dividend="$randw_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randw_time=$(awk -v  dividend="$randw_time" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randw_speed=$(awk -v  dividend="$randw_speed" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 

randr_opers=$(awk -v  dividend="$randr_opers" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randr_time=$(awk -v  dividend="$randr_time" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' )
randr_speed=$(awk -v  dividend="$randr_speed" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 

echo -e "\nMeans of all runs:" >> benchmark_mem/summary_$dirname.txt
echo -e "\t \t Operations per second \t Speed \t \t \t Time" >> benchmark_mem/summary_$dirname.txt
echo -e "Sequential write: \t $seqw_opers/s \t $seqw_speed MiB/s \t $seqw_time s" >> benchmark_mem/summary_$dirname.txt
echo -e "Sequential read: \t $seqr_opers/s \t $seqr_speed MiB/s \t $seqr_time s" >> benchmark_mem/summary_$dirname.txt
echo -e "Random write: \t \t $randw_opers/s \t $randw_speed MiB/s \t \t $randw_time s" >> benchmark_mem/summary_$dirname.txt
echo -e "Random read: \t \t $randr_opers/s \t $randr_speed MiB/s \t \t $randr_time s" >> benchmark_mem/summary_$dirname.txt

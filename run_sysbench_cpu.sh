#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir benchmark_cpu;
mkdir benchmark_cpu/$dirname;

#For loop for multiple runs of y-cruncher
#number of loops is set in the arguments

#prints all variables
#echo $@


for i in $(seq $1);
do
	#sysbench cpu test ran with given max prime number(10 000) and 4 threads which is the number of threads for used CPU, execution cut off time set at 120s(2minutes)
	sysbench --threads=4 --time=120 cpu --cpu-max-prime=10000 run > benchmark_cpu/$dirname/$i.txt;
done

touch benchmark_cpu/summary_$dirname.txt
echo -e "Sysbench CPU test started at $dirname \n \n" >> benchmark_cpu/summary_$dirname.txt
events_per_second="0"
latency="0"
for filename in benchmark_cpu/$dirname/*.txt;
do	
	grep -i 'events per second' -F "$filename" | tr -s " " | cut -b 2- >> benchmark_cpu/summary_$dirname.txt
	events_per_second=$(awk -v  sum1="$events_per_second" -v sum2="$(grep -i 'events per second' -F "$filename" | tr -d " " | cut -d ":" -f 2)" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	echo -e "Latency of 95th percentile of runs: "  >> benchmark_cpu/summary_$dirname.txt
	grep -i '95th' -F "$filename" | tr -s " " | cut -b 2->> benchmark_cpu/summary_$dirname.txt
	latency=$(awk -v  sum1="$latency" -v sum2="$(grep -i '95th' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	echo -e "Threads fairness:"  >> benchmark_cpu/summary_$dirname.txt
	grep -i 'events (avg/stddev)' -F "$filename"  | tr -s " " | cut -b 2- >> benchmark_cpu/summary_$dirname.txt
done

#Adding the means of runs to the summary file
events_per_second=$(awk -v  dividend="$events_per_second" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 
latency=$(awk -v  dividend="$latency" -v divisor="$1" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}' ) 
echo -e "\nMeans of all runs: \n" >> benchmark_cpu/summary_$dirname.txt
echo "Mean of events per second across all runs:  $events_per_second" >> benchmark_cpu/summary_$dirname.txt
echo "95th percentile latency average across all runs: $latency" >> benchmark_cpu/summary_$dirname.txt

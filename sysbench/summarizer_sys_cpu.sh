#!/bin/sh

#Get folder name from previously created folder at benchmark_cpu/date_time
dirname=$(echo "$1" | tr -d "a-z._/")
summary_dir=$(echo $1 | cut -d "/" -f 1)
dir_path="$1"

#Initialize summary file and sums
touch $summary_dir/summary_$dirname.txt
echo "Sysbench CPU test started at $dirname" >> $summary_dir/summary_$dirname.txt
grep -i 'Number of threads' -F $dir_path/1.txt >> $summary_dir/summary_$dirname.txt
events_per_second_sum="0"
latency_sum="0"
max_lat_sum="0"
avg_lat_sum="0"
min_lat_sum="0"
run_number=0

for filename in $dir_path/*.txt;
do	
	run_number=$((run_number + 1)) 
	echo "\nRun number: $run_number" >> $summary_dir/summary_$dirname.txt
	sed '1,13d' $filename >> $summary_dir/summary_$dirname.txt
	events_per_second_sum=$(awk -v  sum1="$events_per_second_sum" -v sum2="$(grep -i 'events per second' -F "$filename" | tr -d " " | cut -d ":" -f 2)" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	latency_sum=$(awk -v  sum1="$latency_sum" -v sum2="$(grep -i '95th' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	max_lat_sum=$(awk -v  sum1="$max_lat_sum" -v sum2="$(grep -i 'max' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	avg_lat_sum=$(awk -v  sum1="$avg_lat_sum" -v sum2="$(grep -i 'avg' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	min_lat_sum=$(awk -v  sum1="$min_lat_sum" -v sum2="$(grep -i 'min' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	echo "\n" >> $summary_dir/summary_$dirname.txt
done


events_per_second_mean=$(awk -v  dividend="$events_per_second_sum" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 
latency_mean=$(awk -v  dividend="$latency_sum" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 
max_lat_mean=$(awk -v  dividend="$max_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 
avg_lat_mean=$(awk -v  dividend="$avg_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 
min_lat_mean=$(awk -v  dividend="$min_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 

#
events_per_second="0"
latency="0"
max_lat="0"
avg_lat="0"
min_lat="0"

#Calculate variance and then standard deviation
#std = root(sum((x-mean)squared)/number_of_tests)
#Substract mean from each variable and add to the sum
#sum(x-mean)
for filename in $dir_path/*.txt;
do	
	events_per_second=$(awk -v  var1="$(grep -i 'events per second' -F "$filename" | tr -d " " | cut -d ":" -f 2)" -v var2="$events_per_second_mean"  -v var3="$events_per_second" 'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	latency=$(awk -v var1="$(grep -i '95th' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" -v  var2="$latency_mean"  -v var3="$latency" 'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	max_lat=$(awk -v var1="$(grep -i 'max' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" -v  var2="$max_lat_mean"  -v var3="$max_lat" 'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )	
	avg_lat=$(awk -v var1="$(grep -i 'avg' -F "$filename" | tr -d " " | cut -d ":" -f 2 )" -v  var2="$avg_lat_mean"  -v var3="$avg_lat" 'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	min_lat=$(awk -v var1="$(grep -i 'min' -F "$filename" | tr -d " " | cut -d ":" -f 2 )"  -v  var2="$min_lat_mean" -v var3="$min_lat" 'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
done


#Calculate variance by dividing the previously calculated sum with the number of runs
variance_eps=$(awk -v dividend="$events_per_second" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
variance_latency=$(awk -v dividend="$latency" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
variance_max_lat=$(awk -v dividend="$max_lat" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
variance_avg_lat=$(awk -v dividend="$avg_lat" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 
variance_min_lat=$(awk -v dividend="$min_lat" -v divisor="$run_number" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' ) 

#Calculate standard deviation by taking the square root of variance
std_eps=$(awk -v variance="$variance_eps" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_latency=$(awk -v variance="$variance_latency" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_max_lat=$(awk -v variance="$variance_max_lat" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_avg_lat=$(awk -v variance="$variance_avg_lat" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_min_lat=$(awk -v variance="$variance_min_lat" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )


#Add the information to the summary file
echo "\nResults of all runs: \n" >> $summary_dir/summary_$dirname.txt
echo "Events per second:\n  Mean:  $events_per_second_mean \n  Standard deviation: $std_eps" >> $summary_dir/summary_$dirname.txt
echo "95th percentile latency:\n  Mean: $latency_mean \n  Standard deviation: $std_latency" >> $summary_dir/summary_$dirname.txt
echo "Minimum latency:\n  Mean: $min_lat_mean \n  Standard deviation: $std_min_lat" >> $summary_dir/summary_$dirname.txt
echo "Average latency:\n  Mean: $avg_lat_mean \n  Standard deviation: $std_avg_lat" >> $summary_dir/summary_$dirname.txt
echo "Maximum latency:\n  Mean: $max_lat_mean \n  Standard deviation: $std_max_lat" >> $summary_dir/summary_$dirname.txt


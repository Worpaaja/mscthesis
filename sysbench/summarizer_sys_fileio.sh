#!/bin/sh

#Get folder name from previously created folder at benchmark_io/date_time
dirname=$(echo "$1" | tr -d "a-z._/")
summary_dir=$(echo $1 | cut -d "/" -f 1)
dir_path="$1"

run_number=$(ls -1 $1/seqw | wc -l)


#Initialize summary file and sums

touch $summary_dir/summary_$dirname.txt
echo  "Sysbench File I/O tests started at $dirname \n \n" >> $summary_dir/summary_$dirname.txt

seqw_opers_sum="0";seqw_thr_sum="0";seqw_fs_sum="0";
seqr_opers_sum="0";seqr_thr_sum="0";
seqrw_opers_sum="0";seqrw_thr_sum="0";seqrw_fs_sum="0";
randr_opers_sum="0";randr_thr_sum="0";
randw_opers_sum="0";randw_thr_sum="0";randw_fs_sum="0";

for i in $(seq $run_number)
do	
	#Seq write
	echo  "Run number $i\nSequential write:" >> $summary_dir/summary_$dirname.txt
	echo  "\tFile operations:"  >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "writes/s" -F "$dir_path/seqw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "fsyncs/s" -F "$dir_path/seqw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	echo  "\tThroughput:\n\t$(grep -i "written, MiB/s" -F "$dir_path/seqw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	
	seqw_thr_sum=$(awk -v  sum1="$seqw_thr_sum" -v sum2="$(grep -i 'written, MiB/s' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:/," )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_opers_sum=$(awk -v  sum1="$seqw_opers_sum" -v sum2="$(grep -i 'writes/s' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_fs_sum=$(awk -v  sum1="$seqw_fs_sum" -v sum2="$(grep -i 'fsyncs/s' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )

	
	#Seq read
	echo "Sequential read:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\tFile operations:"  >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "reads/s" -F "$dir_path/seqr/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt
	echo  "\tThroughput:\n\t$(grep -i "read, MiB/s" -F "$dir_path/seqr/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	
	seqr_thr_sum=$(awk -v  sum1="$seqr_thr_sum" -v sum2="$(grep -i 'read, MiB/s' -F "$dir_path/seqr/$i.txt" | tr -d " a-zA-Z:/," )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqr_opers_sum=$(awk -v  sum1="$seqr_opers_sum" -v sum2="$(grep -i 'reads/s' -F "$dir_path/seqr/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	#Seq rewrite
	echo "Sequential rewrite:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\tFile operations:"  >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "writes/s" -F "$dir_path/seqrw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "fsyncs/s" -F "$dir_path/seqrw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	echo  "\tThroughput:\n\t$(grep -i "written, MiB/s" -F "$dir_path/seqrw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	
	seqrw_thr_sum=$(awk -v  sum1="$seqrw_thr_sum" -v sum2="$(grep -i 'written, MiB/s' -F "$dir_path/seqrw/$i.txt" | tr -d " a-zA-Z:/," )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqrw_opers_sum=$(awk -v  sum1="$seqrw_opers_sum" -v sum2="$(grep -i 'writes/s' -F "$dir_path/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqrw_fs_sum=$(awk -v  sum1="$seqrw_fs_sum" -v sum2="$(grep -i 'fsyncs/s' -F "$dir_path/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	#Rand write
	echo "Random write:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\tFile operations:"  >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "writes/s" -F "$dir_path/randw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "fsyncs/s" -F "$dir_path/randw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	echo  "\tThroughput:\n\t$(grep -i "written, MiB/s" -F "$dir_path/randw/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	
	randw_thr_sum=$(awk -v  sum1="$randw_thr_sum" -v sum2="$(grep -i 'written, MiB/s' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:/," )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randw_opers_sum=$(awk -v  sum1="$randw_opers_sum" -v sum2="$(grep -i 'writes/s' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randw_fs_sum=$(awk -v  sum1="$randw_fs_sum" -v sum2="$(grep -i 'fsyncs/s' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	#Rand read
	echo "Random read:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\tFile operations:"  >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i "reads/s" -F "$dir_path/randr/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt
	echo  "\tThroughput:\n\t$(grep -i "read, MiB/s" -F "$dir_path/randr/$i.txt" | tr -s " ")" >> $summary_dir/summary_$dirname.txt	
	
	randr_thr_sum=$(awk -v  sum1="$randr_thr_sum" -v sum2="$(grep -i 'read, MiB/s' -F "$dir_path/randr/$i.txt" | tr -d " a-zA-Z:/," )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randr_opers_sum=$(awk -v  sum1="$randr_opers_sum" -v sum2="$(grep -i 'reads/s' -F "$dir_path/randr/$i.txt" | tr -d " a-zA-Z:/" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	echo  "\n" >> $summary_dir/summary_$dirname.txt
done


#Calculating means
seqw_opers_mean=$(awk -v  dividend="$seqw_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqw_thr_mean=$(awk -v  dividend="$seqw_thr_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqw_fs_mean=$(awk -v  dividend="$seqw_fs_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 

seqr_opers_mean=$(awk -v  dividend="$seqr_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqr_thr_mean=$(awk -v  dividend="$seqr_thr_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

seqrw_opers_mean=$(awk -v  dividend="$seqrw_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqrw_thr_mean=$(awk -v  dividend="$seqrw_thr_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqrw_fs_mean=$(awk -v  dividend="$seqrw_fs_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

randw_opers_mean=$(awk -v  dividend="$randw_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randw_thr_mean=$(awk -v  dividend="$randw_thr_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randw_fs_mean=$(awk -v  dividend="$randw_fs_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 

randr_opers_mean=$(awk -v  dividend="$randr_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randr_thr_mean=$(awk -v  dividend="$randr_thr_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )


seqw_opers="0";seqw_thr="0";seqw_fs="0";
seqr_opers="0";seqr_thr="0";
seqrw_opers="0";seqrw_thr="0";seqrw_fs="0";
randr_opers="0";randr_thr="0";
randw_opers="0";randw_thr="0";randw_fs="0";

#Calculate variance and then standard deviation
#std = root(sum((x-mean)squared)/number_of_tests)
#Substract mean from each variable and add to the sum
#sum(x-mean)


for i in $(seq $run_number)
do	
	#Seq write
	seqw_thr=$(awk -v  var3="$seqw_thr" -v var1="$(grep -i 'written, MiB/s' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:/," )" -v var2="$seqw_thr_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqw_opers=$(awk -v  var3="$seqw_opers" -v var1="$(grep -i 'writes/s' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$seqw_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqw_fs=$(awk -v  var3="$seqw_fs" -v var1="$(grep -i 'fsyncs/s' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$seqw_fs_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	
	#Seq read
	seqr_thr=$(awk -v  var3="$seqr_thr" -v var1="$(grep -i 'read, MiB/s' -F "$dir_path/seqr/$i.txt" | tr -d " a-zA-Z:/," )" -v var2="$seqr_thr_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqr_opers=$(awk -v  var3="$seqr_opers" -v var1="$(grep -i 'reads/s' -F "$dir_path/seqr/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$seqr_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	
	#Seq rewrite
	seqrw_thr=$(awk -v  var3="$seqrw_thr" -v var1="$(grep -i 'written, MiB/s' -F "$dir_path/seqrw/$i.txt" | tr -d " a-zA-Z:/," )" -v var2="$seqrw_thr_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqrw_opers=$(awk -v  var3="$seqrw_opers" -v var1="$(grep -i 'writes/s' -F "$dir_path/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$seqrw_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqrw_fs=$(awk -v  var3="$seqrw_fs" -v var1="$(grep -i 'fsyncs/s' -F "$dir_path/seqrw/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$seqrw_fs_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	#Rand write
	randw_thr=$(awk -v  var3="$randw_thr" -v var1="$(grep -i 'written, MiB/s' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:/," )" -v var2="$randw_thr_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randw_opers=$(awk -v  var3="$randw_opers" -v var1="$(grep -i 'writes/s' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$randw_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randw_fs=$(awk -v  var3="$randw_fs" -v var1="$(grep -i 'fsyncs/s' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$randw_fs_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	#Rand read
	randr_thr=$(awk -v  var3="$randr_thr" -v var1="$(grep -i 'read, MiB/s' -F "$dir_path/randr/$i.txt" | tr -d " a-zA-Z:/," )" -v var2="$randr_thr_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randr_opers=$(awk -v var3="$randr_opers" -v var1="$(grep -i 'reads/s' -F "$dir_path/randr/$i.txt" | tr -d " a-zA-Z:/" )" -v var2="$randr_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )

done


#Calculate variance by dividing the previously calculated sum with the number of runs
var_seqw_opers=$(awk -v dividend="$seqw_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqw_thr=$(awk -v dividend="$seqw_thr" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqw_fs=$(awk -v dividend="$seqw_fs" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

var_seqr_opers=$(awk -v dividend="$seqr_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqr_thr=$(awk -v dividend="$seqr_thr" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

var_seqrw_opers=$(awk -v dividend="$seqrw_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqrw_thr=$(awk -v dividend="$seqrw_thr" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqrw_fs=$(awk -v dividend="$seqrw_fs" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

var_randr_opers=$(awk -v dividend="$randr_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randr_thr=$(awk -v dividend="$randr_thr" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

var_randw_opers=$(awk -v dividend="$randw_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randw_thr=$(awk -v dividend="$randw_thr" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randw_fs=$(awk -v dividend="$randw_fs" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )



#Calculate standard deviation by taking the square root of variance
std_seqw_opers=$(awk -v variance="$var_seqw_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqw_thr=$(awk -v variance="$var_seqw_thr" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqw_fs=$(awk -v variance="$var_seqw_fs" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )

std_seqr_opers=$(awk -v variance="$var_seqr_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqr_thr=$(awk -v variance="$var_seqr_thr" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )

std_seqrw_opers=$(awk -v variance="$var_seqrw_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqrw_thr=$(awk -v variance="$var_seqrw_thr" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqrw_fs=$(awk -v variance="$var_seqrw_fs" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )

std_randr_opers=$(awk -v variance="$var_randr_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randr_thr=$(awk -v variance="$var_randr_thr" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )

std_randw_opers=$(awk -v variance="$var_randw_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randw_thr=$(awk -v variance="$var_randw_thr" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randw_fs=$(awk -v variance="$var_randw_fs" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )


#Add the information to the summary file
echo "\nResults of all runs:" >> $summary_dir/summary_$dirname.txt
echo "  Sequential write:" >> $summary_dir/summary_$dirname.txt
echo "\tWrite operations  Mean: $seqw_opers_mean/s   Standard deviation: $std_seqw_opers" >> $summary_dir/summary_$dirname.txt
echo "\tFsyncs  Mean: $seqw_fs_mean/s   Standard deviation: $std_seqw_fs" >> $summary_dir/summary_$dirname.txt
echo "\twritten throughput  Mean: $seqw_thr_mean MiB/s   Standard deviation: $std_seqw_thr" >> $summary_dir/summary_$dirname.txt


echo  "\n  Sequential read:" >> $summary_dir/summary_$dirname.txt
echo "\tRead operations  Mean: $seqr_opers_mean/s   Standard deviation: $std_seqr_opers" >> $summary_dir/summary_$dirname.txt
echo "\tread throughput  Mean: $seqr_thr_mean MiB/s   Standard deviation: $std_seqr_thr">> $summary_dir/summary_$dirname.txt


echo  "\n  Sequential rewrite:" >> $summary_dir/summary_$dirname.txt
echo "\tWrite operations  Mean: $seqrw_opers_mean/s   Standard deviation: $std_seqrw_opers" >> $summary_dir/summary_$dirname.txt
echo "\tFsyncs  Mean: $seqrw_fs_mean/s   Standard deviation: $std_seqrw_fs" >> $summary_dir/summary_$dirname.txt
echo "\twritten throughput  Mean: $seqrw_thr_mean MiB/s   Standard deviation: $std_seqrw_thr" >> $summary_dir/summary_$dirname.txt


echo "\n  Random write:" >> $summary_dir/summary_$dirname.txt
echo "\tWrite operations  Mean: $randw_opers_mean/s   Standard deviation: $std_randw_opers" >> $summary_dir/summary_$dirname.txt
echo "\tFsyncs  Mean: $randw_fs_mean/s   Standard deviation: $std_randw_fs" >> $summary_dir/summary_$dirname.txt
echo "\twritten throughput  Mean: $randw_thr_mean MiB/s   Standard deviation: $std_randw_thr" >> $summary_dir/summary_$dirname.txt


echo "\n  Random read:"  >> $summary_dir/summary_$dirname.txt
echo "\tRead operations  Mean: $randr_opers_mean/s   Standard deviation: $std_randr_opers" >> $summary_dir/summary_$dirname.txt
echo "\tread throughput  Mean: $randr_thr_mean MiB/s   Standard deviation: $std_randr_thr" >> $summary_dir/summary_$dirname.txt


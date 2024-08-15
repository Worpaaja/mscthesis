#!/bin/sh

#Get folder name from previously created folder at benchmark_mem/date_time
dirname=$(echo "$1" | tr -d "a-z._/")
summary_dir=$(echo $1 | cut -d "/" -f 1)
dir_path="$1"
run_number=$(ls -1 $1/seqw | wc -l)


#Initialize summary file and sums

touch $summary_dir/summary_$dirname.txt
echo "Sysbench memory test started at $dirname \n \n" >> $summary_dir/summary_$dirname.txt

seqw_time_sum="0";seqw_opers_sum="0";seqw_speed_sum="0"; seqw_max_lat_sum="0";
seqr_time_sum="0";seqr_opers_sum="0";seqr_speed_sum="0"; seqr_max_lat_sum="0";
randw_time_sum="0";randw_opers_sum="0";randw_speed_sum="0"; randw_max_lat_sum="0";
randr_time_sum="0";randr_opers_sum="0";randr_speed_sum="0"; randr_max_lat_sum="0";

#Total time, operations per second and speed and max latency
for i in $(seq $run_number)
do	
	#Seq write
	echo  "Run number $i\nSequential write:" >> $summary_dir/summary_$dirname.txt
	echo  "\t$(grep -i 'total time' -F "$dir_path/seqw/$i.txt" | tr -s " " | cut -b 2-)" >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "$dir_path/seqw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")"
	echo  "\tOperations per second: $line"  >> $summary_dir/summary_$dirname.txt

	line="$(grep -i 'transferred' -F "$dir_path/seqw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d "/)a-zA-Z/")"
	echo  "\tTransfer speed: $line MiB/s"  >> $summary_dir/summary_$dirname.txt
	
	line="$(grep -i 'max:' -F "$dir_path/seqw/$i.txt" |  tr -d ":A-Za-z ")"
	echo  "\tMaximum latency: $line ms"  >> $summary_dir/summary_$dirname.txt
	
	seqw_time_sum=$(awk -v  sum1="$seqw_time_sum" -v sum2="$(grep -i 'total time' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_opers_sum=$(awk -v  sum1="$seqw_opers_sum" -v sum2="$(grep -i 'Total operations' -F "$dir_path/seqw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_speed_sum=$(awk -v  sum1="$seqw_speed_sum" -v sum2="$(grep -i 'transferred' -F "$dir_path/seqw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqw_max_lat_sum=$(awk -v  sum1="$seqw_max_lat_sum" -v sum2="$(grep -i 'max:' -F "$dir_path/seqw/$i.txt" |  tr -d ":A-Za-z ")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	#Seq read
	echo "Sequential read:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\t$(grep -i 'total time' -F "$dir_path/seqr/$i.txt" | tr -s " " | cut -b 2-)" >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "$dir_path/seqr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")"
	echo  "\tOperations per second: $line"  >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'transferred' -F "$dir_path/seqr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d "/)a-zA-Z/")"
	echo  "\tTransfer speed: $line MiB/s"  >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'max:' -F "$dir_path/seqr/$i.txt" |  tr -d ":A-Za-z ")"
	echo  "\tMaximum latency: $line ms"  >> $summary_dir/summary_$dirname.txt
	
	seqr_time_sum=$(awk -v  sum1="$seqr_time_sum" -v sum2="$(grep -i 'total time' -F "$dir_path/seqr/$i.txt" | tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqr_opers_sum=$(awk -v  sum1="$seqr_opers_sum" -v sum2="$(grep -i 'Total operations' -F "$dir_path/seqr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqr_speed_sum=$(awk -v  sum1="$seqr_speed_sum" -v sum2="$(grep -i 'transferred' -F "$dir_path/seqr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	seqr_max_lat_sum=$(awk -v  sum1="$seqr_max_lat_sum" -v sum2="$(grep -i 'max:' -F "$dir_path/seqr/$i.txt" |  tr -d ":A-Za-z ")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	#Rand write
	echo "Random write:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\t$(grep -i 'total time' -F "$dir_path/randw/$i.txt" | tr -s " " | cut -b 2-)" >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "$dir_path/randw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")"
	echo  "\tOperations per second: $line"  >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'transferred' -F "$dir_path/randw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d "/)a-zA-Z/")"
	echo  "\tTransfer speed: $line MiB/s"  >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'max:' -F "$dir_path/randw/$i.txt" |  tr -d ":A-Za-z ")"
	echo  "\tMaximum latency: $line ms"  >> $summary_dir/summary_$dirname.txt

	randw_time_sum=$(awk -v  sum1="$randw_time_sum" -v sum2="$(grep -i 'total time' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randw_opers_sum=$(awk -v  sum1="$randw_opers_sum" -v sum2="$(grep -i 'Total operations' -F "$dir_path/randw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	


	
	randw_speed_sum=$(awk -v  sum1="$randw_speed_sum" -v sum2="$(grep -i 'transferred' -F "$dir_path/randw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randw_max_lat_sum=$(awk -v  sum1="$randw_max_lat_sum" -v sum2="$(grep -i 'max:' -F "$dir_path/randw/$i.txt" |  tr -d ":A-Za-z ")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	#Rand read
	echo "Random read:" >> $summary_dir/summary_$dirname.txt
	
	echo  "\t$(grep -i 'total time' -F "$dir_path/randr/$i.txt" | tr -s " " | cut -b 2-)" >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'Total operations' -F "$dir_path/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")"
	echo  "\tOperations per second: $line"  >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'transferred' -F "$dir_path/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d "/)a-zA-Z/")"
	echo  "\tTransfer speed: $line MiB/s"  >> $summary_dir/summary_$dirname.txt
	line="$(grep -i 'max:' -F "$dir_path/randr/$i.txt" |  tr -d ":A-Za-z ")"
	echo  "\tMaximum latency: $line ms"  >> $summary_dir/summary_$dirname.txt
	
	randr_time_sum=$(awk -v  sum1="$randr_time_sum" -v sum2="$(grep -i 'total time' -F "$dir_path/randr/$i.txt"| tr -d " a-zA-Z:" )" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randr_opers_sum=$(awk -v  sum1="$randr_opers_sum" -v sum2="$(grep -i 'Total operations' -F "$dir_path/randr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randr_speed_sum=$(awk -v  sum1="$randr_speed_sum" -v sum2="$(grep -i 'transferred' -F "$dir_path/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	randr_max_lat_sum=$(awk -v  sum1="$randr_max_lat_sum" -v sum2="$(grep -i 'max:' -F "$dir_path/randr/$i.txt" |  tr -d ":A-Za-z ")" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	echo "\n" >> $summary_dir/summary_$dirname.txt
done

#Adding the means of runs to the summary file
#Sequential Write
seqw_opers_mean=$(awk -v  dividend="$seqw_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqw_time_mean=$(awk -v  dividend="$seqw_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqw_speed_mean=$(awk -v  dividend="$seqw_speed_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
seqw_max_lat_mean=$(awk -v  dividend="$seqw_max_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

#Sequential Read
seqr_opers_mean=$(awk -v  dividend="$seqr_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqr_time_mean=$(awk -v  dividend="$seqr_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
seqr_speed_mean=$(awk -v  dividend="$seqr_speed_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
seqr_max_lat_mean=$(awk -v  dividend="$seqr_max_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

#Random Write
randw_opers_mean=$(awk -v  dividend="$randw_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randw_time_mean=$(awk -v  dividend="$randw_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randw_speed_mean=$(awk -v  dividend="$randw_speed_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
randw_max_lat_mean=$(awk -v  dividend="$randw_max_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )




#Random Read
randr_opers_mean=$(awk -v  dividend="$randr_opers_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randr_time_mean=$(awk -v  dividend="$randr_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
randr_speed_mean=$(awk -v  dividend="$randr_speed_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
randr_max_lat_mean=$(awk -v  dividend="$randr_max_lat_sum" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

#Initializing variables for calculating variance and standard deviation
seqw_time="0";seqw_opers="0";seqw_speed="0"; seqw_max_lat="0";
seqr_time="0";seqr_opers="0";seqr_speed="0"; seqr_max_lat="0";
randw_time="0";randw_opers="0";randw_speed="0"; randw_max_lat="0";
randr_time="0";randr_opers="0";randr_speed="0"; randr_max_lat="0";



#Calculate variance and then standard deviation
#std = root(sum((x-mean)squared)/number_of_tests)
#Substract mean from each variable and add to the sum
#sum(x-mean)


for i in $(seq $run_number)
do	
	#Seq write
	seqw_time=$(awk -v  var3="$seqw_time" -v var1="$(grep -i 'total time' -F "$dir_path/seqw/$i.txt" | tr -d " a-zA-Z:" )" -v var2="$seqw_time_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqw_opers=$(awk -v  var3="$seqw_opers" -v var1="$(grep -i 'Total operations' -F "$dir_path/seqw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$seqw_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqw_speed=$(awk -v  var3="$seqw_speed" -v var1="$(grep -i 'transferred' -F "$dir_path/seqw/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$seqw_speed_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqw_max_lat=$(awk -v  var3="$seqw_max_lat" -v var1="$(grep -i 'max:' -F "$dir_path/seqw/$i.txt" |  tr -d ":A-Za-z ")" -v var2="$seqw_max_lat_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	
	#Seq read
	seqr_time=$(awk -v  var3="$seqr_time" -v var1="$(grep -i 'total time' -F "$dir_path/seqr/$i.txt" | tr -d " a-zA-Z:" )" -v var2="$seqr_time_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqr_opers=$(awk -v  var3="$seqr_opers" -v var1="$(grep -i 'Total operations' -F "$dir_path/seqr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$seqr_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqr_speed=$(awk -v  var3="$seqr_speed" -v var1="$(grep -i 'transferred' -F "$dir_path/seqr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$seqr_speed_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	seqr_max_lat=$(awk -v  var3="$seqr_max_lat" -v var1="$(grep -i 'max:' -F "$dir_path/seqr/$i.txt" |  tr -d ":A-Za-z ")" -v var2="$seqr_max_lat_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	
	#Rand write
	randw_time=$(awk -v  var3="$randw_time" -v var1="$(grep -i 'total time' -F "$dir_path/randw/$i.txt" | tr -d " a-zA-Z:" )" -v var2="$randw_time_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randw_opers=$(awk -v  var3="$randw_opers" -v var1="$(grep -i 'Total operations' -F "$dir_path/randw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$randw_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randw_speed=$(awk -v  var3="$randw_speed" -v var1="$(grep -i 'transferred' -F "$dir_path/randw/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$randw_speed_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )	
	randw_max_lat=$(awk -v  var3="$randw_max_lat" -v var1="$(grep -i 'max:' -F "$dir_path/randw/$i.txt" |  tr -d ":A-Za-z ")" -v var2="$randw_max_lat_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	
	

	#Rand read
	randr_time=$(awk -v  var3="$randr_time" -v var1="$(grep -i 'total time' -F "$dir_path/randr/$i.txt"| tr -d " a-zA-Z:" )" -v var2="$randr_time_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randr_opers=$(awk -v  var3="$randr_opers" -v var1="$(grep -i 'Total operations' -F "$dir_path/randr/$i.txt" |  tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$randr_opers_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randr_speed=$(awk -v  var3="$randr_speed" -v var1="$(grep -i 'transferred' -F "$dir_path/randr/$i.txt" | tr -d " " | cut -d "(" -f 2 | tr -d ")a-zA-Z/")" -v var2="$randr_speed_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	randr_max_lat=$(awk -v  var3="$randr_max_lat" -v var1="$(grep -i 'max:' -F "$dir_path/randr/$i.txt" |  tr -d ":A-Za-z ")" -v var2="$randr_max_lat_mean" 'BEGIN {printf "%.5f", var3+((var1-var2)^2); exit(0)}' )
	

done


#Calculate variance by dividing the previously calculated sum with the number of runs
#Sequential Write
var_seqw_opers=$(awk -v dividend="$seqw_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqw_time=$(awk -v dividend="$seqw_time" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqw_speed=$(awk -v dividend="$seqw_speed" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqw_max_lat=$(awk -v dividend="$seqw_max_lat" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

#Sequential Read
var_seqr_opers=$(awk -v dividend="$seqr_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqr_time=$(awk -v dividend="$seqr_time" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqr_speed=$(awk -v dividend="$seqr_speed" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_seqr_max_lat=$(awk -v dividend="$seqr_max_lat" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )

#Random Write
var_randw_opers=$(awk -v dividend="$randw_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randw_time=$(awk -v dividend="$randw_time" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randw_speed=$(awk -v dividend="$randw_speed" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randw_max_lat=$(awk -v dividend="$randw_max_lat" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )



#Random Read
var_randr_opers=$(awk -v dividend="$randr_opers" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randr_time=$(awk -v dividend="$randr_time" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randr_speed=$(awk -v dividend="$randr_speed" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )
var_randr_max_lat=$(awk -v dividend="$randr_max_lat" -v divisor="$run_number" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )




#Calculate standard deviation by taking the square root of variance
#Sequential Write
std_seqw_opers=$(awk -v variance="$var_seqw_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqw_time=$(awk -v variance="$var_seqw_time" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqw_speed=$(awk -v variance="$var_seqw_speed" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqw_max_lat=$(awk -v variance="$var_seqw_max_lat" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )

#Sequential Read
std_seqr_opers=$(awk -v variance="$var_seqr_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqr_time=$(awk -v variance="$var_seqr_time" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqr_speed=$(awk -v variance="$var_seqr_speed" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_seqr_max_lat=$(awk -v variance="$var_seqr_max_lat" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )


#Random Write
std_randw_opers=$(awk -v variance="$var_randw_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randw_time=$(awk -v variance="$var_randw_time" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randw_speed=$(awk -v variance="$var_randw_speed" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randw_max_lat=$(awk -v variance="$var_randw_max_lat" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )




#Random Read
std_randr_opers=$(awk -v variance="$var_randr_opers" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randr_time=$(awk -v variance="$var_randr_time" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randr_speed=$(awk -v variance="$var_randr_speed" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )
std_randr_max_lat=$(awk -v variance="$var_randr_max_lat" 'BEGIN {printf "%.5f", sqrt(variance); exit(0)}' )

#Poista varianssit kaikista ja tarkasta tämän ja muiden tulokset

#Add the information to the summary file
echo "\nResults of all runs:" >> $summary_dir/summary_$dirname.txt
echo "Sequential write:" >> $summary_dir/summary_$dirname.txt
echo "  Write operations" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqw_opers_mean/s   Standard deviation: $std_seqw_opers" >> $summary_dir/summary_$dirname.txt
echo "  Total time" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqw_time_mean s   Standard deviation: $std_seqw_time" >> $summary_dir/summary_$dirname.txt
echo "  Computational speed(MiB/s)" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqw_speed_mean MiB/s   Standard deviation: $std_seqw_speed" >> $summary_dir/summary_$dirname.txt
echo "  Maximum latency" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqw_max_lat_mean ms   Standard deviation: $std_seqw_max_lat" >> $summary_dir/summary_$dirname.txt

echo "\nSequential read:" >> $summary_dir/summary_$dirname.txt
echo "  Read operations" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqr_opers_mean/s   Standard deviation: $std_seqr_opers"  >> $summary_dir/summary_$dirname.txt
echo "  Total time" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqr_time_mean s   Standard deviation: $std_seqr_time" >> $summary_dir/summary_$dirname.txt
echo "  Computational speed(MiB/s)" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqr_speed_mean MiB/s   Standard deviation: $std_seqr_speed" >> $summary_dir/summary_$dirname.txt
echo "  Maximum latency" >> $summary_dir/summary_$dirname.txt
echo "\tMean: $seqr_max_lat_mean ms   Standard deviation: $std_seqr_max_lat" >> $summary_dir/summary_$dirname.txt

echo "\nRandom write:">> $summary_dir/summary_$dirname.txt
echo "  Write operations">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randw_opers_mean/s   Standard deviation: $std_randw_opers">> $summary_dir/summary_$dirname.txt
echo "  Total time">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randw_time_mean s   Standard deviation: $std_randw_time">> $summary_dir/summary_$dirname.txt
echo "  Computational speed(MiB/s)">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randw_speed_mean MiB/s   Standard deviation: $std_randw_speed">> $summary_dir/summary_$dirname.txt
echo "  Maximum latency">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randw_max_lat_mean ms   Standard deviation: $std_randw_max_lat" >> $summary_dir/summary_$dirname.txt

echo "\nRandom read:">> $summary_dir/summary_$dirname.txt
echo "  Read operations">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randr_opers_mean/s   Standard deviation: $std_randr_opers">> $summary_dir/summary_$dirname.txt
echo "  Total time">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randr_time_mean s   Standard deviation: $std_randr_time">> $summary_dir/summary_$dirname.txt
echo "  Computational speed(MiB/s)">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randr_speed_mean MiB/s   Standard deviation: $std_randr_speed">> $summary_dir/summary_$dirname.txt
echo "  Maximum latency">> $summary_dir/summary_$dirname.txt
echo "\tMean: $randr_max_lat_mean ms   Standard deviation: $std_randr_max_lat" >> $summary_dir/summary_$dirname.txt


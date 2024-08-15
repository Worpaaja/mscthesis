#!/bin/sh


#Get folder name from previously created folder at streambenchmark/date_time
dirname=$(echo "$1" | tr -d "a-z._/")
summary_dir=$(echo $1 | cut -d "/" -f 1)
dir_path="$1"

#Initialize summary file and sums
touch $summary_dir/summary_$dirname.txt
sed '12,30d' $dir_path/1.txt >> $summary_dir/summary_$dirname.txt
echo "" >> $summary_dir/summary_$dirname.txt

copy_bestrate_sum="0"
scale_bestrate_sum="0"
add_bestrate_sum="0"
triad_bestrate_sum="0"

copy_avg_time_sum="0"
scale_avg_time_sum="0"
add_avg_time_sum="0"
triad_avg_time_sum="0"

copy_max_time_sum="0"
scale_max_time_sum="0"
add_max_time_sum="0"
triad_max_time_sum="0"

copy_min_time_sum="0"
scale_min_time_sum="0"
add_min_time_sum="0"
triad_min_time_sum="0"

run_number=0

for filename in $dir_path/*.txt;
do	
	run_number=$(($run_number + 1))
	sed '1,21d' $filename | sed '29,30d' >> $summary_dir/summary_$dirname.txt 
	echo "" >> $summary_dir/summary_$dirname.txt
	copy_bestrate_sum=$(awk -v  sum1="$copy_bestrate_sum" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	copy_avg_time_sum=$(awk -v  sum1="$copy_avg_time_sum" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	copy_max_time_sum=$(awk -v  sum1="$copy_max_time_sum" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	copy_min_time_sum=$(awk -v  sum1="$copy_min_time_sum" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	
	scale_bestrate_sum=$(awk -v  sum1="$scale_bestrate_sum" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	scale_avg_time_sum=$(awk -v  sum1="$scale_avg_time_sum" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	scale_max_time_sum=$(awk -v  sum1="$scale_max_time_sum" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	scale_min_time_sum=$(awk -v  sum1="$scale_min_time_sum" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	
	
	add_bestrate_sum=$(awk -v  sum1="$add_bestrate_sum" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	add_avg_time_sum=$(awk -v  sum1="$add_avg_time_sum" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	add_max_time_sum=$(awk -v  sum1="$add_max_time_sum" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	add_min_time_sum=$(awk -v  sum1="$add_min_time_sum" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	
	
	triad_bestrate_sum=$(awk -v  sum1="$triad_bestrate_sum" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	triad_avg_time_sum=$(awk -v  sum1="$triad_avg_time_sum" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	triad_max_time_sum=$(awk -v  sum1="$triad_max_time_sum" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
	triad_min_time_sum=$(awk -v  sum1="$triad_min_time_sum" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.7f", sum1+sum2; exit(0)}' )
done


#Calculate variance and then standard deviation
#std = root(sum((x-mean)squared)/number_of_tests)
#Substract mean from each variable and add to the sum
#sum(x-mean)

copy_bestrate_mean=$(awk -v  dividend="$copy_bestrate_sum" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
copy_avg_time_mean=$(awk -v  dividend="$copy_avg_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
copy_max_time_mean=$(awk -v  dividend="$copy_max_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' )  
copy_min_time_mean=$(awk -v  dividend="$copy_min_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' )


scale_bestrate_mean=$(awk -v  dividend="$scale_bestrate_sum" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
scale_avg_time_mean=$(awk -v  dividend="$scale_avg_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
scale_max_time_mean=$(awk -v  dividend="$scale_max_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
scale_min_time_mean=$(awk -v  dividend="$scale_min_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 


add_bestrate_mean=$(awk -v  dividend="$add_bestrate_sum" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
add_avg_time_mean=$(awk -v  dividend="$add_avg_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
add_max_time_mean=$(awk -v  dividend="$add_max_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
add_min_time_mean=$(awk -v  dividend="$add_min_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
	
	
triad_bestrate_mean=$(awk -v  dividend="$triad_bestrate_sum" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
triad_avg_time_mean=$(awk -v  dividend="$triad_avg_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
triad_max_time_mean=$(awk -v  dividend="$triad_max_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
triad_min_time_mean=$(awk -v  dividend="$triad_min_time_sum" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 

copy_bestrate="0"
scale_bestrate="0"
add_bestrate="0"
triad_bestrate="0"

copy_avg_time="0"
scale_avg_time="0"
add_avg_time="0"
triad_avg_time="0"

copy_max_time="0"
scale_max_time="0"
add_max_time="0"
triad_max_time="0"

copy_min_time="0"
scale_min_time="0"
add_min_time="0"
triad_min_time="0"



for filename in $dir_path/*.txt;
do	
	copy_bestrate=$(awk -v var3="$copy_bestrate" -v var1="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" -v var2=$copy_bestrate_mean 'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	copy_avg_time=$(awk -v var3="$copy_avg_time" -v var1="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" -v var2=$copy_avg_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	copy_max_time=$(awk -v var3="$copy_max_time" -v var1="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" -v var2=$copy_max_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	copy_min_time=$(awk -v var3="$copy_min_time" -v var1="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" -v var2=$copy_min_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	
	scale_bestrate=$(awk -v var3="$scale_bestrate" -v var1="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" -v var2=$scale_bestrate_mean  'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	scale_avg_time=$(awk -v var3="$scale_avg_time" -v var1="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" -v var2=$scale_avg_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	scale_max_time=$(awk -v var3="$scale_max_time" -v var1="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" -v var2=$scale_max_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	scale_min_time=$(awk -v var3="$scale_min_time" -v var1="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" -v var2=$scale_min_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	
	
	add_bestrate=$(awk -v var3="$add_bestrate" -v var1="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" -v var2=$add_bestrate_mean  'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	add_avg_time=$(awk -v var3="$add_avg_time" -v var1="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" -v var2=$add_avg_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	add_max_time=$(awk -v var3="$add_max_time" -v var1="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" -v var2=$add_max_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	add_min_time=$(awk -v var3="$add_min_time" -v var1="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" -v var2=$add_min_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	
	
	triad_bestrate=$(awk -v var3="$triad_bestrate" -v var1="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" -v var2=$triad_bestrate_mean  'BEGIN {printf "%.3f", var3+((var1-var2)^2); exit(0)}' )
	triad_avg_time=$(awk -v var3="$triad_avg_time" -v var1="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" -v var2=$triad_avg_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	triad_max_time=$(awk -v var3="$triad_max_time" -v var1="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" -v var2=$triad_max_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
	triad_min_time=$(awk -v var3="$triad_min_time" -v var1="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" -v var2=$triad_min_time_mean  'BEGIN {printf "%.7f", var3+((var1-var2)^2); exit(0)}' )
done

#Calculate variance by dividing the previously calculated sum with the number of runs

var_copy_bestrate=$(awk -v  dividend="$copy_bestrate" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
var_copy_avg_time=$(awk -v  dividend="$copy_avg_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_copy_max_time=$(awk -v  dividend="$copy_max_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' )  
var_copy_min_time=$(awk -v  dividend="$copy_min_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' )


var_scale_bestrate=$(awk -v  dividend="$scale_bestrate" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
var_scale_avg_time=$(awk -v  dividend="$scale_avg_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_scale_max_time=$(awk -v  dividend="$scale_max_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_scale_min_time=$(awk -v  dividend="$scale_min_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 


var_add_bestrate=$(awk -v  dividend="$add_bestrate" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
var_add_avg_time=$(awk -v  dividend="$add_avg_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_add_max_time=$(awk -v  dividend="$add_max_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_add_min_time=$(awk -v  dividend="$add_min_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
	

var_triad_bestrate=$(awk -v  dividend="$triad_bestrate" -v divisor="$run_number" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
var_triad_avg_time=$(awk -v  dividend="$triad_avg_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_triad_max_time=$(awk -v  dividend="$triad_max_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 
var_triad_min_time=$(awk -v  dividend="$triad_min_time" -v divisor="$run_number" 'BEGIN {printf "%.7f", dividend/divisor; exit(0)}' ) 

#Calculate standard deviation by taking the square root of variance


std_copy_bestrate=$(awk -v variance="$var_copy_bestrate" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_scale_bestrate=$(awk -v variance="$var_scale_bestrate" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_add_bestrate=$(awk -v variance="$var_add_bestrate" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )
std_triad_bestrate=$(awk -v variance="$var_triad_bestrate" 'BEGIN {printf "%.3f", sqrt(variance); exit(0)}' )

std_copy_avg_time=$(awk -v variance="$var_copy_avg_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_scale_avg_time=$(awk -v variance="$var_scale_avg_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_add_avg_time=$(awk -v variance="$var_add_avg_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_triad_avg_time=$(awk -v variance="$var_triad_avg_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )

std_copy_max_time=$(awk -v variance="$var_copy_max_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_scale_max_time=$(awk -v variance="$var_scale_max_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_add_max_time=$(awk -v variance="$var_add_max_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_triad_max_time=$(awk -v variance="$var_triad_max_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )

std_copy_min_time=$(awk -v variance="$var_copy_min_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_scale_min_time=$(awk -v variance="$var_scale_min_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_add_min_time=$(awk -v variance="$var_add_min_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )
std_triad_min_time=$(awk -v variance="$var_triad_min_time" 'BEGIN {printf "%.7f", sqrt(variance); exit(0)}' )

echo "\nResults:" >> $summary_dir/summary_$dirname.txt
echo "Copy: "  >> $summary_dir/summary_$dirname.txt
echo "  Best rate average: "$copy_bestrate_mean" \tStandard deviation: "$std_copy_bestrate""  >> $summary_dir/summary_$dirname.txt
echo "  Mininmum time average: "$copy_min_time_mean" \tStandard deviation: "$std_copy_min_time""  >> $summary_dir/summary_$dirname.txt
echo "  Average run times average: "$copy_avg_time_mean" \tStandard deviation: "$std_copy_avg_time" " >> $summary_dir/summary_$dirname.txt
echo "  Maximum time average: "$copy_max_time_mean" \tStandard deviation: "$std_copy_max_time" " >> $summary_dir/summary_$dirname.txt

echo "\nScale:"  >> $summary_dir/summary_$dirname.txt
echo "  Best rate average: "$scale_bestrate_mean" \tStandard deviation: "$std_scale_bestrate""  >> $summary_dir/summary_$dirname.txt
echo "  Mininmum time average: "$scale_min_time_mean" \tStandard deviation: "$std_scale_min_time""  >> $summary_dir/summary_$dirname.txt
echo "  Average run times average: "$scale_avg_time_mean" \tStandard deviation: "$std_scale_avg_time" " >> $summary_dir/summary_$dirname.txt
echo "  Maximum time average: "$scale_max_time_mean" \tStandard deviation: "$std_scale_max_time" " >> $summary_dir/summary_$dirname.txt


echo "\nAdd:"  >> $summary_dir/summary_$dirname.txt
echo "  Best rate average: "$add_bestrate_mean" \tStandard deviation: "$std_add_bestrate""  >> $summary_dir/summary_$dirname.txt
echo "  Mininmum time average: "$add_min_time_mean" \tStandard deviation: "$std_add_min_time""  >> $summary_dir/summary_$dirname.txt
echo "  Average run times average: "$add_avg_time_mean" \tStandard deviation: "$std_add_avg_time" " >> $summary_dir/summary_$dirname.txt
echo "  Maximum time average: "$add_max_time_mean" \tStandard deviation: "$std_add_max_time" " >> $summary_dir/summary_$dirname.txt


echo "\nTriad:"  >> $summary_dir/summary_$dirname.txt
echo "  Best rate average: "$triad_bestrate_mean" \tStandard deviation: "$std_triad_bestrate""  >> $summary_dir/summary_$dirname.txt
echo "  Mininmum time average: "$triad_min_time_mean" \tStandard deviation: "$std_triad_min_time""  >> $summary_dir/summary_$dirname.txt
echo "  Average run times average: "$triad_avg_time_mean" \tStandard deviation: "$std_triad_avg_time" " >> $summary_dir/summary_$dirname.txt
echo "  Maximum time average: "$triad_max_time_mean" \tStandard deviation: "$std_triad_max_time" " >> $summary_dir/summary_$dirname.txt



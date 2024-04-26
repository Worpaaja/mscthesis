#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir streambenchmark;
mkdir streambenchmark/$dirname;

#For loop for multiple runs of STREAM
#number of loops is set in the arguments


for i in $(seq $1);
do
	#stream ran with default settings, compiled from C with gcc -O stream.c -o stream
	./stream > streambenchmark/$dirname/$i.txt;
done

touch streambenchmark/summary_$dirname.txt
sed '12,30d' streambenchmark/$dirname/1.txt >> streambenchmark/summary_$dirname.txt
echo "" >> streambenchmark/summary_$dirname.txt

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


for filename in streambenchmark/$dirname/*.txt;
do	
	sed '1,21d' $filename | sed '29,30d' >> streambenchmark/summary_$dirname.txt 
	echo "" >> streambenchmark/summary_$dirname.txt
	copy_bestrate=$(awk -v  sum1="$copy_bestrate" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	copy_avg_time=$(awk -v  sum1="$copy_avg_time" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	copy_max_time=$(awk -v  sum1="$copy_max_time" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	copy_min_time=$(awk -v  sum1="$copy_min_time" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	scale_bestrate=$(awk -v  sum1="$scale_bestrate" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	scale_avg_time=$(awk -v  sum1="$scale_avg_time" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	scale_max_time=$(awk -v  sum1="$scale_max_time" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	scale_min_time=$(awk -v  sum1="$scale_min_time" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	add_bestrate=$(awk -v  sum1="$add_bestrate" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	add_avg_time=$(awk -v  sum1="$add_avg_time" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	add_max_time=$(awk -v  sum1="$add_max_time" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	add_min_time=$(awk -v  sum1="$add_min_time" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	triad_bestrate=$(awk -v  sum1="$triad_bestrate" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	triad_avg_time=$(awk -v  sum1="$triad_avg_time" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	triad_max_time=$(awk -v  sum1="$triad_max_time" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 5)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	triad_min_time=$(awk -v  sum1="$triad_min_time" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 4)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
done


echo -e "\nMeans of all runs: \n" >> streambenchmark/summary_$dirname.txt

#Adding the mean of runs to the summary file

copy_bestrate=$(awk -v  dividend="$copy_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
copy_avg_time=$(awk -v  dividend="$copy_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
copy_max_time=$(awk -v  dividend="$copy_max_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )  
copy_min_time=$(awk -v  dividend="$copy_min_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' )


scale_bestrate=$(awk -v  dividend="$scale_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
scale_avg_time=$(awk -v  dividend="$scale_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
scale_max_time=$(awk -v  dividend="$scale_max_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
scale_min_time=$(awk -v  dividend="$scale_min_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 


add_bestrate=$(awk -v  dividend="$add_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
add_avg_time=$(awk -v  dividend="$add_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
add_max_time=$(awk -v  dividend="$add_max_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
add_min_time=$(awk -v  dividend="$add_min_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
	
	
triad_bestrate=$(awk -v  dividend="$triad_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
triad_avg_time=$(awk -v  dividend="$triad_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
triad_max_time=$(awk -v  dividend="$triad_max_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
triad_min_time=$(awk -v  dividend="$triad_min_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 

echo -e "Averaged results:" >> streambenchmark/summary_$dirname.txt
echo -e "Function \t Best Rate MB/s \t Avg time \t\t Min Time \t Max Time " >> streambenchmark/summary_$dirname.txt
echo -e "Copy: \t \t "$copy_bestrate" \t \t "$copy_avg_time" \t \t "$copy_min_time" \t "$copy_max_time"" >> streambenchmark/summary_$dirname.txt
echo -e "Scale: \t \t "$scale_bestrate" \t \t "$scale_avg_time" \t \t "$scale_min_time"\t "$scale_max_time"" >> streambenchmark/summary_$dirname.txt
echo -e "Add: \t \t "$add_bestrate" \t \t "$add_avg_time" \t \t "$add_min_time"\t "$add_max_time"" >> streambenchmark/summary_$dirname.txt
echo -e "Triad: \t \t "$triad_bestrate" \t \t "$triad_avg_time" \t \t "$triad_min_time"\t "$triad_max_time"" >> streambenchmark/summary_$dirname.txt

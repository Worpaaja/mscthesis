#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir benchmark;
mkdir benchmark/$dirname;

#For loop for multiple runs of STREAM
#number of loops is set in the arguments

#prints all variables
#echo $@


for i in $(seq $1);
do
	#stream ran with default settings, compiled from C with gcc -O stream.c -o stream
	./stream > benchmark/$dirname/$i.txt;
done

touch benchmark/summary_$dirname.txt
sed '12,30d' benchmark/$dirname/1.txt >> benchmark/summary_$dirname.txt
echo "" >> benchmark/summary_$dirname.txt

copy_bestrate="0"
scale_bestrate="0"
add_bestrate="0"
triad_bestrate="0"

copy_avg_time="0"
scale_avg_time="0"
add_avg_time="0"
triad_avg_time="0"


for filename in benchmark/$dirname/*.txt;
do	
	sed '1,21d' $filename | sed '29,30d' >> benchmark/summary_$dirname.txt 
	echo "" >> benchmark/summary_$dirname.txt
	copy_bestrate=$(awk -v  sum1="$copy_bestrate" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	copy_avg_time=$(awk -v  sum1="$copy_avg_time" -v sum2="$(grep -i "Copy:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	scale_bestrate=$(awk -v  sum1="$scale_bestrate" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	scale_avg_time=$(awk -v  sum1="$scale_avg_time" -v sum2="$(grep -i "Scale:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	add_bestrate=$(awk -v  sum1="$add_bestrate" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	add_avg_time=$(awk -v  sum1="$add_avg_time" -v sum2="$(grep -i "Add:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
	
	
	triad_bestrate=$(awk -v  sum1="$triad_bestrate" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 2)" 'BEGIN {printf "%.1f", sum1+sum2; exit(0)}' )
	triad_avg_time=$(awk -v  sum1="$triad_avg_time" -v sum2="$(grep -i "Triad:" -F "$filename" | tr -s " " | cut -d ' ' -f 3)" 'BEGIN {printf "%.5f", sum1+sum2; exit(0)}' )
done


echo -e "\nMeans of all runs: \n" >> benchmark/summary_$dirname.txt

#Adding the mean of runs to the summary file

copy_bestrate=$(awk -v  dividend="$copy_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
copy_avg_time=$(awk -v  dividend="$copy_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 


scale_bestrate=$(awk -v  dividend="$scale_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
scale_avg_time=$(awk -v  dividend="$scale_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 


add_bestrate=$(awk -v  dividend="$add_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
add_avg_time=$(awk -v  dividend="$add_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 
	
	
triad_bestrate=$(awk -v  dividend="$triad_bestrate" -v divisor="$1" 'BEGIN {printf "%.1f", dividend/divisor; exit(0)}' ) 
triad_avg_time=$(awk -v  dividend="$triad_avg_time" -v divisor="$1" 'BEGIN {printf "%.5f", dividend/divisor; exit(0)}' ) 

	
echo -e "Function \t Best Rate MB/s \t Avg time" >> benchmark/summary_$dirname.txt
echo -e "Copy: \t \t "$copy_bestrate" \t \t "$copy_avg_time"" >> benchmark/summary_$dirname.txt
echo -e "Scale: \t \t "$scale_bestrate" \t \t "$scale_avg_time"" >> benchmark/summary_$dirname.txt
echo -e "Add: \t \t "$add_bestrate" \t \t "$add_avg_time"" >> benchmark/summary_$dirname.txt
echo -e "Triad: \t \t "$triad_bestrate" \t \t "$triad_avg_time"" >> benchmark/summary_$dirname.txt
cat benchmark/summary_$dirname.txt

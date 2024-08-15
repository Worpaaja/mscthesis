#!/bin/sh


#Get folder name from previously created folder at bonniebenchmark/date_time
dirname=$(echo "$1" | tr -d "a-z._/")
summary_dir=$(echo $1 | cut -d "/" -f 1)
dir_path="$1"

run_number=$(ls -1 $1 | wc -l)

#Initialize summary file and sums


touch $summary_dir/summary_$dirname.txt
soc_s_sum=0;soc_c_sum=0;soc_l_sum=0;sob_s_sum=0;sob_c_sum=0;sob_l_sum=0;sor_s_sum=0;sor_c_sum=0;sor_l_sum=0;
sic_s_sum=0;sic_c_sum=0;sic_l_sum=0;sib_s_sum=0;sib_c_sum=0;sib_l_sum=0;rs_s_sum=0;rs_c_sum=0;rs_l_sum=0;
scc_s_sum=0;scc_c_sum=0;scc_l_sum=0;scr_s_sum=0;scr_c_sum=0;scr_l_sum=0;scd_s_sum=0;scd_c_sum=0;scd_l_sum=0;
rcc_s_sum=0;rcc_c_sum=0;rcc_l_sum=0;rcr_s_sum=0;rcr_c_sum=0;rcr_l_sum=0;rcd_s_sum=0;rcd_c_sum=0;rcd_l_sum=0;

#Since Sequential Create and Random Create can be +++ to mark too low of result, following runs are used for their means
scc_s_runs=$run_number
scc_c_runs=$run_number

scr_s_runs=$run_number
scr_c_runs=$run_number

scd_s_runs=$run_number
scd_c_runs=$run_number

rcc_s_runs=$run_number
rcc_c_runs=$run_number

rcr_s_runs=$run_number
rcr_c_runs=$run_number

rcd_s_runs=$run_number
rcd_c_runs=$run_number


for filename in $dir_path/*.txt;
do

	latest_line=$(cat $filename | tail -1 | tr -d "s" | sed 's/u/*0.000001/g' | sed 's/m/*0.001/g') 
	
	#Creating sums of each attribute
	#In Bonnie:
	#_s denotes seconds, _c denotes CPU usage in percents, _l denotes latency
	#Last letter before _ is for Per Chr(c), Block(b), Rewrite(r)
	#rs is for random seeks
	
	
	#Sequential Output 
	soc_s_sum=$(awk -v  sum1="$soc_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 10)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #10th entry in latest_line 
	soc_c_sum=$(awk -v  sum1="$soc_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 11)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #11th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 39 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 39 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' ) #39th entry in latest_line
	soc_l_sum=$(awk -v  sum1="$soc_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #39th entry in latest_line
	
	sob_s_sum=$(awk -v  sum1="$sob_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 12)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #12th entry
	sob_c_sum=$(awk -v  sum1="$sob_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 13)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #13th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 40 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 40 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' ) #40th entry in latest_line
	sob_l_sum=$(awk -v  sum1="$sob_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #40th entry in latest_line
	
	sor_s_sum=$(awk -v  sum1="$sor_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 14)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #14th entry in latest_line
	sor_c_sum=$(awk -v  sum1="$sor_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 15)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #15th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 41 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 41 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sor_l_sum=$(awk -v  sum1="$sor_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #41st entry in latest_line
	
	#Sequential Input
	sic_s_sum=$(awk -v  sum1="$sic_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 16)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #16th entry in latest_line
	sic_c_sum=$(awk -v  sum1="$sic_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 17)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #17th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 42 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 42 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sic_l_sum=$(awk -v  sum1="$sic_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #42nd entry in latest_line
	
	sib_s_sum=$(awk -v  sum1="$sib_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 18)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #18th entry in latest_line
	sib_c_sum=$(awk -v  sum1="$sib_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 19)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #19th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 43 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 43 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sib_l_sum=$(awk -v  sum1="$sib_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #43rd entry in latest_line
	
	#Random seeks
	rs_s_sum=$(awk -v  sum1="$rs_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 20)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #20th entry in latest_line
	rs_c_sum=$(awk -v  sum1="$rs_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 21)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #21st entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 44 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 44 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rs_l_sum=$(awk -v  sum1="$rs_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #44th entry in latest_line
	
	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	
	scc_s_sum=$(awk -v  sum1="$scc_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 27)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #27th entry in latest_line
	scr_s_sum=$(awk -v  sum1="$scr_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 29)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #29th entry in latest_line
	scd_s_sum=$(awk -v  sum1="$scd_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 31)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #31st entry in latest_line
	scc_c_sum=$(awk -v  sum1="$scc_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 28)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #28th entry in latest_line
	scr_c_sum=$(awk -v  sum1="$scr_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 30)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #30th entry in latest_line
	scd_c_sum=$(awk -v  sum1="$scd_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 32)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #32nd entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 45 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 45 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	scc_l_sum=$(awk -v  sum1="$scc_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #45th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 46 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 46 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	scr_l_sum=$(awk -v  sum1="$scr_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #46th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 47 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 47 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	scd_l_sum=$(awk -v  sum1="$scd_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #47th entry in latest_line
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	rcc_c_sum=$(awk -v  sum1="$rcc_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 34)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #34th entry in latest_line
	rcr_c_sum=$(awk -v  sum1="$rcr_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 36)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #36th entry in latest_line
	rcd_c_sum=$(awk -v  sum1="$rcd_c_sum" -v sum2="$(echo $latest_line | cut -d "," -f 38)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #38th entry in latest_line
	rcc_s_sum=$(awk -v  sum1="$rcc_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 33)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #33th entry in latest_line
	rcr_s_sum=$(awk -v  sum1="$rcr_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 35)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #35th entry in latest_line
	rcd_s_sum=$(awk -v  sum1="$rcd_s_sum" -v sum2="$(echo $latest_line | cut -d "," -f 37)" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #37th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 48 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 48 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rcc_l_sum=$(awk -v  sum1="$rcc_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #48th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 49 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 49 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rcr_l_sum=$(awk -v  sum1="$rcr_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #49th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 50 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 50 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rcd_l_sum=$(awk -v  sum1="$rcd_l_sum" -v sum2="$latency" 'BEGIN {printf "%.8f", sum1+sum2; exit(0)}' ) #50th entry in latest_line
	
	#Sequential Create create
	if [ $(echo $latest_line | cut -d "," -f 27 | tr -s "+") = "+" ]; then
		scc_s_runs=$((scc_s_runs-1))
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 28 | tr -s "+") = "+" ]; then
		scc_c_runs=$((scc_s_runs-1))
	fi
	
	#Sequential Create read
	if [ $(echo $latest_line | cut -d "," -f 29 | tr -s "+") = "+" ]; then
		scr_s_runs=$((scr_s_runs-1))
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 30 | tr -s "+") = "+" ]; then
		scr_c_runs=$((scr_c_runs-1))
	fi
	
	#Sequential Create delete
	if [ $(echo $latest_line | cut -d "," -f 31 | tr -s "+") = "+" ]; then
		scd_s_runs=$((scd_s_runs-1))
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 32 | tr -s "+") = "+" ]; then
		scd_c_runs=$((scd_c_runs-1))
	fi
	
	#Random Create create
	if [ $(echo $latest_line | cut -d "," -f 33 | tr -s "+") = "+" ]; then
		rcc_s_runs=$((rcc_s_runs-1))
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 34 | tr -s "+") = "+" ]; then
		rcc_c_runs=$((rcc_c_runs-1))
	fi
	
	#Random Create read
	if [ $(echo $latest_line | cut -d "," -f 35 | tr -s "+") = "+" ]; then
		rcr_s_runs=$((rcr_s_runs-1))
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 36 | tr -s "+") = "+" ]; then
		rcr_c_runs=$((rcr_c_runs-1))
	fi
	
	#Random Create delete
	if [ $(echo $latest_line | cut -d "," -f 37 | tr -s "+") = "+" ]; then
		rcd_s_runs=$((rcd_s_runs-1))
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 38 | tr -s "+") = "+" ]; then
		rcd_c_runs=$((rcd_c_runs-1))
	fi	
	
	
done
 

soc_s_mean=0;soc_c_mean=0;soc_l_mean=0;sob_s_mean=0;sob_c_mean=0;sob_l_mean=0;sor_s_mean=0;sor_c_mean=0;sor_l_mean=0;
sic_s_mean=0;sic_c_mean=0;sic_l_mean=0;sib_s_mean=0;sib_c_mean=0;sib_l_mean=0;rs_s_mean=0;rs_c_mean=0;rs_l_mean=0;
scc_s_mean=0;scc_c_mean=0;scc_l_mean=0;scr_s_mean=0;scr_c_mean=0;scr_l_mean=0;scd_s_mean=0;scd_c_mean=0;scd_l_mean=0;
rcc_s_mean=0;rcc_c_mean=0;rcc_l_mean=0;rcr_s_mean=0;rcr_c_mean=0;rcr_l_mean=0;rcd_s_mean=0;rcd_c_mean=0;rcd_l_mean=0;

#Calculating means of every variable 
	#Sequential Output 
soc_s_mean=$(awk -v  dividend="$soc_s_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
soc_c_mean=$(awk -v  dividend="$soc_c_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
soc_l_mean=$(awk -v  dividend="$soc_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

sob_s_mean=$(awk -v  dividend="$sob_s_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sob_c_mean=$(awk -v  dividend="$sob_c_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sob_l_mean=$(awk -v  dividend="$sob_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

sor_s_mean=$(awk -v  dividend="$sor_s_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sor_c_mean=$(awk -v  dividend="$sor_c_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sor_l_mean=$(awk -v  dividend="$sor_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

	#Sequential Input
sic_s_mean=$(awk -v  dividend="$sic_s_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sic_c_mean=$(awk -v  dividend="$sic_c_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sic_l_mean=$(awk -v  dividend="$sic_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
sib_s_mean=$(awk -v  dividend="$sib_s_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sib_c_mean=$(awk -v  dividend="$sib_c_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
sib_l_mean=$(awk -v  dividend="$sib_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

	#Random seeks
rs_s_mean=$(awk -v  dividend="$rs_s_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rs_c_mean=$(awk -v  dividend="$rs_c_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rs_l_mean=$(awk -v  dividend="$rs_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
scc_c_mean=$(awk -v  dividend="$scc_c_sum" -v divisor="$scc_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
scr_c_mean=$(awk -v  dividend="$scr_c_sum" -v divisor="$scr_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
scd_c_mean=$(awk -v  dividend="$scd_c_sum" -v divisor="$scd_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
scc_s_mean=$(awk -v  dividend="$scc_s_sum" -v divisor="$scc_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
scr_s_mean=$(awk -v  dividend="$scr_s_sum" -v divisor="$scr_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
scd_s_mean=$(awk -v  dividend="$scd_s_sum" -v divisor="$scd_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
scc_l_mean=$(awk -v  dividend="$scc_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
scr_l_mean=$(awk -v  dividend="$scr_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
scd_l_mean=$(awk -v  dividend="$scd_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
rcc_s_mean=$(awk -v  dividend="$rcc_s_sum" -v divisor="$rcc_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rcr_s_mean=$(awk -v  dividend="$rcr_s_sum" -v divisor="$rcr_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rcd_s_mean=$(awk -v  dividend="$rcd_s_sum" -v divisor="$rcd_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
rcc_c_mean=$(awk -v  dividend="$rcc_c_sum" -v divisor="$rcc_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rcr_c_mean=$(awk -v  dividend="$rcr_c_sum" -v divisor="$rcr_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rcd_c_mean=$(awk -v  dividend="$rcd_c_sum" -v divisor="$rcd_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
rcc_l_mean=$(awk -v  dividend="$rcc_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rcr_l_mean=$(awk -v  dividend="$rcr_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
rcd_l_mean=$(awk -v  dividend="$rcd_l_sum" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )


#Calculate variance and then standard deviation
#std = root(sum((x-mean)squared)/number_of_tests)
#Substract mean from each variable and add to the sum
#sum(x-mean)

soc_s=0;soc_c=0;soc_l=0;sob_s=0;sob_c=0;sob_l=0;sor_s=0;sor_c=0;sor_l=0;
sic_s=0;sic_c=0;sic_l=0;sib_s=0;sib_c=0;sib_l=0;rs_s=0;rs_c=0;rs_l=0;
scc_s=0;scc_c=0;scc_l=0;scr_s=0;scr_c=0;scr_l=0;scd_s=0;scd_c=0;scd_l=0;
rcc_s=0;rcc_c=0;rcc_l=0;rcr_s=0;rcr_c=0;rcr_l=0;rcd_s=0;rcd_c=0;rcd_l=0;


for filename in $dir_path/*.txt;
do
	latest_line=$(cat $filename | tail -1 | tr -d "s" | sed 's/u/*0.000001/g' | sed 's/m/*0.001/g') 

	
	#Creating sums of each attribute
	#In Bonnie:
	#_s denotes seconds, _c denotes CPU usage in percents, _l denotes latency
	#Last letter before _ is for Per Chr(c), Block(b), Rewrite(r)
	#rs is for random seeks
	
	
	#Sequential Output 
	soc_s=$(awk -v  var3="$soc_s" -v var1="$(echo $latest_line | cut -d "," -f 10)" -v  var2="$soc_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #10th entry in latest_line 
	soc_c=$(awk -v  var3="$soc_c" -v var1="$(echo $latest_line | cut -d "," -f 11)" -v  var2="$soc_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #11th entry in latest_line
	
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 39 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 39 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	soc_l=$(awk -v  var3="$soc_l" -v var1="$latency" -v  var2="$soc_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #39th entry in latest_line
	
	
	sob_s=$(awk -v  var3="$sob_s" -v var1="$(echo $latest_line | cut -d "," -f 12)" -v  var2="$sob_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #12th entry
	sob_c=$(awk -v  var3="$sob_c" -v var1="$(echo $latest_line | cut -d "," -f 13)" -v  var2="$sob_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #13th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 40 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 40 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sob_l=$(awk -v  var3="$sob_l" -v var1="$latency" -v  var2="$sob_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #40th entry in latest_line
	
	sor_s=$(awk -v  var3="$sor_s" -v var1="$(echo $latest_line | cut -d "," -f 14)" -v  var2="$sor_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #14th entry in latest_line
	sor_c=$(awk -v  var3="$sor_c" -v var1="$(echo $latest_line | cut -d "," -f 15)" -v  var2="$sor_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #15th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 41 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 41 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sor_l=$(awk -v  var3="$sor_l" -v var1="$latency" -v  var2="$sor_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #41st entry in latest_line
	
	#Sequential Input
	sic_s=$(awk -v  var3="$sic_s" -v var1="$(echo $latest_line | cut -d "," -f 16)" -v  var2="$sic_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #16th entry in latest_line
	sic_c=$(awk -v  var3="$sic_c" -v var1="$(echo $latest_line | cut -d "," -f 17)" -v  var2="$sic_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #17th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 42 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 42 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sic_l=$(awk -v  var3="$sic_l" -v var1="$latency" -v  var2="$sic_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #42nd entry in latest_line
	
	sib_s=$(awk -v  var3="$sib_s" -v var1="$(echo $latest_line | cut -d "," -f 18)" -v  var2="$sib_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #18th entry in latest_line
	sib_c=$(awk -v  var3="$sib_c" -v var1="$(echo $latest_line | cut -d "," -f 19)" -v  var2="$sib_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #19th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 43 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 43 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	sib_l=$(awk -v  var3="$sib_l" -v var1="$latency" -v  var2="$sib_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #43rd entry in latest_line
	
	#Random seeks
	rs_s=$(awk -v  var3="$rs_s" -v var1="$(echo $latest_line | cut -d "," -f 20)" -v  var2="$rs_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #20th entry in latest_line
	rs_c=$(awk -v  var3="$rs_c" -v var1="$(echo $latest_line | cut -d "," -f 21)" -v  var2="$rs_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #21st entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 44 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 44 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rs_l=$(awk -v  var3="$rs_l" -v var1="$latency" -v  var2="$rs_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #44th entry in latest_line
	
	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
			#Sequential Create create
	if [ $(echo $latest_line | cut -d "," -f 27 | tr -s "+") != "+" ]; then
		scc_s=$(awk -v  var3="$scc_s" -v var1="$(echo $latest_line | cut -d "," -f 27)" -v  var2="$scc_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #27th entry in latest_line
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 28 | tr -s "+") != "+" ]; then
		scc_c=$(awk -v  var3="$scc_c" -v var1="$(echo $latest_line | cut -d "," -f 28)" -v  var2="$scc_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #28th entry in latest_line
	fi
	
	#Sequential Create read
	if [ $(echo $latest_line | cut -d "," -f 29 | tr -s "+") != "+" ]; then
		scr_s=$(awk -v  var3="$scr_s" -v var1="$(echo $latest_line | cut -d "," -f 29)" -v  var2="$scr_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #29th entry in latest_line
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 30 | tr -s "+") != "+" ]; then
		scr_c=$(awk -v  var3="$scr_c" -v var1="$(echo $latest_line | cut -d "," -f 30)" -v  var2="$scr_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #30th entry in latest_line
	fi
	
	#Sequential Create delete
	if [ $(echo $latest_line | cut -d "," -f 31 | tr -s "+") != "+" ]; then
		scd_s=$(awk -v  var3="$scd_s" -v var1="$(echo $latest_line | cut -d "," -f 31)" -v  var2="$scd_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #31st entry in latest_line
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 32 | tr -s "+") != "+" ]; then
		scd_c=$(awk -v  var3="$scd_c" -v var1="$(echo $latest_line | cut -d "," -f 32)" -v  var2="$scd_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #32nd entry in latest_line
	fi
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 45 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 45 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	scc_l=$(awk -v  var3="$scc_l" -v var1="$latency" -v  var2="$scc_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #45th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 46 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 46 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	scr_l=$(awk -v  var3="$scr_l" -v var1="$latency" -v  var2="$scr_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #46th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 47 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 47 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	scd_l=$(awk -v  var3="$scd_l" -v var1="$latency" -v  var2="$scd_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #47th entry in latest_line
	
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	#Random Create create
	if [ $(echo $latest_line | cut -d "," -f 33 | tr -s "+") != "+" ]; then
		rcc_s=$(awk -v  var3="$rcc_s" -v var1="$(echo $latest_line | cut -d "," -f 33)" -v  var2="$rcc_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #33th entry in latest_line
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 34 | tr -s "+") != "+" ]; then
		rcc_c=$(awk -v  var3="$rcc_c" -v var1="$(echo $latest_line | cut -d "," -f 34)" -v  var2="$rcc_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #34th entry in latest_line
	fi
	
	#Random Create read
	if [ $(echo $latest_line | cut -d "," -f 35 | tr -s "+") != "+" ]; then
		rcr_s=$(awk -v  var3="$rcr_s" -v var1="$(echo $latest_line | cut -d "," -f 35)" -v  var2="$rcr_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #35th entry in latest_line
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 36 | tr -s "+") != "+" ]; then
		rcr_c=$(awk -v  var3="$rcr_c" -v var1="$(echo $latest_line | cut -d "," -f 36)" -v  var2="$rcr_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #36th entry in latest_line
	fi
	
	#Random Create delete
	if [ $(echo $latest_line | cut -d "," -f 37 | tr -s "+") != "+" ]; then
		rcd_s=$(awk -v  var3="$rcd_s" -v var1="$(echo $latest_line | cut -d "," -f 37)" -v  var2="$rcd_s_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #37th entry in latest_line
	fi
		
	if [ $(echo $latest_line | cut -d "," -f 38 | tr -s "+") != "+" ]; then
		rcd_c=$(awk -v  var3="$rcd_c" -v var1="$(echo $latest_line | cut -d "," -f 38)" -v  var2="$rcd_c_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #38th entry in latest_line
	fi	
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 48 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 48 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rcc_l=$(awk -v  var3="$rcc_l" -v var1="$latency" -v  var2="$rcc_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #48th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 49 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 49 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rcr_l=$(awk -v  var3="$rcr_l" -v var1="$latency" -v  var2="$rcr_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #49th entry in latest_line
	
	latency=$(awk -v  var1="$(echo $latest_line | cut -d "," -f 50 | cut -d "*" -f 1)" -v var2="$(echo $latest_line | cut -d "," -f 50 | cut -d "*" -f 2)" 'BEGIN {printf "%.8f", var1*var2; exit(0)}' )
	rcd_l=$(awk -v  var3="$rcd_l" -v var1="$latency" -v  var2="$rcd_l_mean" 'BEGIN {printf "%.8f", var3+((var1-var2)^2); exit(0)}' ) #50th entry in latest_line

	
done





 
#Calculate variance by dividing the previously calculated sum with the number of runs
	#Sequential Output 
var_soc_s=$(awk -v  dividend="$soc_s" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_soc_c=$(awk -v  dividend="$soc_c" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_soc_l=$(awk -v  dividend="$soc_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

var_sob_s=$(awk -v  dividend="$sob_s" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sob_c=$(awk -v  dividend="$sob_c" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sob_l=$(awk -v  dividend="$sob_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

var_sor_s=$(awk -v  dividend="$sor_s" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sor_c=$(awk -v  dividend="$sor_c" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sor_l=$(awk -v  dividend="$sor_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

	#Sequential Input
var_sic_s=$(awk -v  dividend="$sic_s" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sic_c=$(awk -v  dividend="$sic_c" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sic_l=$(awk -v  dividend="$sic_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
var_sib_s=$(awk -v  dividend="$sib_s" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sib_c=$(awk -v  dividend="$sib_c" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_sib_l=$(awk -v  dividend="$sib_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

	#Random seeks
var_rs_s=$(awk -v  dividend="$rs_s" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rs_c=$(awk -v  dividend="$rs_c" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rs_l=$(awk -v  dividend="$rs_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )

	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
var_scc_c=$(awk -v  dividend="$scc_c" -v divisor="$scc_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_scr_c=$(awk -v  dividend="$scr_c" -v divisor="$scr_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_scd_c=$(awk -v  dividend="$scd_c" -v divisor="$scd_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
var_scc_s=$(awk -v  dividend="$scc_s" -v divisor="$scc_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_scr_s=$(awk -v  dividend="$scr_s" -v divisor="$scr_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_scd_s=$(awk -v  dividend="$scd_s" -v divisor="$scd_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
var_scc_l=$(awk -v  dividend="$scc_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_scr_l=$(awk -v  dividend="$scr_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_scd_l=$(awk -v  dividend="$scd_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
var_rcc_s=$(awk -v  dividend="$rcc_s" -v divisor="$rcc_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rcr_s=$(awk -v  dividend="$rcr_s" -v divisor="$rcr_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rcd_s=$(awk -v  dividend="$rcd_s" -v divisor="$rcd_s_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
var_rcc_c=$(awk -v  dividend="$rcc_c" -v divisor="$rcc_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rcr_c=$(awk -v  dividend="$rcr_c" -v divisor="$rcr_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rcd_c=$(awk -v  dividend="$rcd_c" -v divisor="$rcd_c_runs" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
	
var_rcc_l=$(awk -v  dividend="$rcc_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rcr_l=$(awk -v  dividend="$rcr_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )
var_rcd_l=$(awk -v  dividend="$rcd_l" -v divisor="$run_number" 'BEGIN {printf "%.8f", dividend/divisor; exit(0)}' )


#Calculate standard deviation by taking the square root of variance


	#Sequential Output 
std_soc_s=$(awk -v  variance="$var_soc_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_soc_c=$(awk -v  variance="$var_soc_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_soc_l=$(awk -v  variance="$var_soc_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )

std_sob_s=$(awk -v  variance="$var_sob_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sob_c=$(awk -v  variance="$var_sob_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sob_l=$(awk -v  variance="$var_sob_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )

std_sor_s=$(awk -v  variance="$var_sor_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sor_c=$(awk -v  variance="$var_sor_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sor_l=$(awk -v  variance="$var_sor_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )

	#Sequential Input
std_sic_s=$(awk -v  variance="$var_sic_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sic_c=$(awk -v  variance="$var_sic_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sic_l=$(awk -v  variance="$var_sic_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
	
std_sib_s=$(awk -v  variance="$var_sib_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sib_c=$(awk -v  variance="$var_sib_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_sib_l=$(awk -v  variance="$var_sib_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )

	#Random seeks
std_rs_s=$(awk -v  variance="$var_rs_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rs_c=$(awk -v  variance="$var_rs_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rs_l=$(awk -v  variance="$var_rs_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )

	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
std_scc_c=$(awk -v  variance="$var_scc_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_scr_c=$(awk -v  variance="$var_scr_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_scd_c=$(awk -v  variance="$var_scd_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
	
std_scc_s=$(awk -v  variance="$var_scc_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_scr_s=$(awk -v  variance="$var_scr_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_scd_s=$(awk -v  variance="$var_scd_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
	
std_scc_l=$(awk -v  variance="$var_scc_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_scr_l=$(awk -v  variance="$var_scr_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_scd_l=$(awk -v  variance="$var_scd_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
std_rcc_s=$(awk -v  variance="$var_rcc_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rcr_s=$(awk -v  variance="$var_rcr_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rcd_s=$(awk -v  variance="$var_rcd_s" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
	
std_rcc_c=$(awk -v  variance="$var_rcc_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rcr_c=$(awk -v  variance="$var_rcr_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rcd_c=$(awk -v  variance="$var_rcd_c" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
	
std_rcc_l=$(awk -v  variance="$var_rcc_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rcr_l=$(awk -v  variance="$var_rcr_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )
std_rcd_l=$(awk -v  variance="$var_rcd_l" 'BEGIN {printf "%.8f", sqrt(variance); exit(0)}' )



echo "Bonnie++ test ran at $dirname with $run_number test runs" >> $summary_dir/summary_$dirname.txt
echo "Since some Sequential and Random Create can have unusable runs due to too low of measurement, eligible number of runs was added." >> $summary_dir/summary_$dirname.txt
#Sequential Output
echo "\nSequential Output:" >> $summary_dir/summary_$dirname.txt
echo "Per Character:\n  Operations per second: AVG: $soc_s_mean  STD: $std_soc_s" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $soc_c_mean  STD: $std_soc_c" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $soc_l_mean  STD: $std_soc_l" >> $summary_dir/summary_$dirname.txt

echo "\nPer Block:\n  Operations per second: AVG: $sob_s_mean  STD: $std_sob_s" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $sob_c_mean  STD: $std_sob_c" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $sob_l_mean  STD: $std_sob_l" >> $summary_dir/summary_$dirname.txt

echo "\nRewrite:\n  Operations per second: AVG: $sor_s_mean  STD: $std_sor_s" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $sor_c_mean  STD: $std_sor_c" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $sor_l_mean  STD: $std_sor_l" >> $summary_dir/summary_$dirname.txt

#Sequential Input
echo "\nSequential Input:" >> $summary_dir/summary_$dirname.txt
echo "Per Character:\n  Operations per second: AVG: $sic_s_mean  STD: $std_sic_s" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $sic_c_mean  STD: $std_sic_c" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $sic_l_mean  STD: $std_sic_l" >> $summary_dir/summary_$dirname.txt

echo "Per Block:\n  Operations per second: AVG: $sib_s_mean  STD: $std_sib_s" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $sib_c_mean  STD: $std_sib_c" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $sib_l_mean  STD: $std_sib_l" >> $summary_dir/summary_$dirname.txt

#Random seeks
echo "\nRandom Seeks:\n  Operations per second: AVG: $rs_s_mean  STD: $std_rs_s" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $rs_c_mean  STD: $std_rs_c" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $rs_l_mean  STD: $std_rs_l" >> $summary_dir/summary_$dirname.txt


#Sequential Create
echo "\nSequential Create:" >> $summary_dir/summary_$dirname.txt
echo "Create:\n  Operations per second: AVG: $scc_s_mean  STD: $std_scc_s  Eligible runs: $scc_s_runs" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $scc_c_mean  STD: $std_scc_c  Eligible runs: $scc_c_runs" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $scc_l_mean  STD: $std_scc_l" >> $summary_dir/summary_$dirname.txt

echo "Read:\n  Operations per second: AVG: $scr_s_mean  STD: $std_scr_s  Eligible runs: $scr_s_runs" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $scr_c_mean  STD: $std_scr_c  Eligible runs: $scr_c_runs" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $scr_l_mean  STD: $std_scr_l" >> $summary_dir/summary_$dirname.txt

echo "Delete:\n  Operations per second: AVG: $scd_s_mean  STD: $std_scd_s  Eligible runs: $scd_s_runs" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $scd_c_mean  STD: $std_scd_c  Eligible runs: $scd_c_runs" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $scd_l_mean  STD: $std_scd_l" >> $summary_dir/summary_$dirname.txt


#Random Create
echo "\nRandom Create:" >> $summary_dir/summary_$dirname.txt
echo "Create:\n  Operations per second: AVG: $rcc_s_mean  STD: $std_rcc_s  Eligible runs: $rcc_s_runs" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $rcc_c_mean  STD: $std_rcc_c  Eligible runs: $rcc_c_runs" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $rcc_l_mean  STD: $std_rcc_l" >> $summary_dir/summary_$dirname.txt

echo "Read:\n  Operations per second: AVG: $rcr_s_mean  STD: $std_rcr_s  Eligible runs: $rcr_s_runs" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $rcr_c_mean  STD: $std_rcr_c  Eligible runs: $rcr_c_runs" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $rcr_l_mean  STD: $std_rcr_l" >> $summary_dir/summary_$dirname.txt

echo "Delete:\n  Operations per second: AVG: $rcd_s_mean  STD: $std_rcd_s  Eligible runs: $rcd_s_runs" >> $summary_dir/summary_$dirname.txt
echo "  CP%: AVG: $rcd_c_mean  STD: $std_rcd_c  Eligible runs: $rcd_c_runs" >> $summary_dir/summary_$dirname.txt
echo "  Latency: AVG: $rcd_l_mean  STD: $std_rcd_l" >> $summary_dir/summary_$dirname.txt


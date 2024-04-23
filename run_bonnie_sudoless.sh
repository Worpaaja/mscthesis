#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir bonniebenchmark;
mkdir bonniebenchmark/$dirname;

#Maybe a combined meaner since some results can be ++++, could help with different machines
#Maybe run bonnie++ with -x (($1)), multiple lines in one file which you can then take out, mean, and maybe use bon csv2txt to make pretty table

#For loop for multiple runs of bonnie++
#number of loops is set in the arguments
for i in $(seq $1);
do
	#bonnie++ ran with tmp folder as the folder used, 16G filesize(it's recommended to use file size of twice your RAM size), and as root
	bonnie++ -d /tmp -s 16G -u root > bonniebenchmark/$dirname/bonnie_$i.txt;
done	#-x <number_of_tests> could be used to run multiple tests, -q to set quiet mode
	#Maybe automagically setting -s to double ram size?

#initiliazing variables for summary 
touch bonniebenchmark/summary_$dirname.txt
soc_s=0;soc_c=0;soc_l=0;sob_s=0;sob_c=0;sob_l=0;sor_s=0;sor_c=0;sor_l=0;
sic_s=0;sic_c=0;sic_l=0;sib_s=0;sib_c=0;sib_l=0;rs_s=0;rs_c=0;rs_l=0;
scc_s=0;scc_c=0;scc_l=0;scr_s=0;scr_c=0;scr_l=0;scd_s=0;scd_c=0;scd_l=0;
rcc_s=0;rcc_c=0;rcc_l=0;rcr_s=0;rcr_c=0;rcr_l=0;rcd_s=0;rcd_c=0;rcd_l=0;

for filename in bonniebenchmark/$dirname/*.txt;
do
	latest_line=$(cat $filename | tail -1) #how to do floating point calculation efficiently?
	#Creating sums of each attribute
	#In Bonnie:
	#_s denotes seconds, _c denotes CPU usage in percents, _l denotes latency
	#Last letter before _ is for Per Chr(c), Block(b), Rewrite(r)
	#rs is for random seeks
	
	
	#Sequential Output 
	soc_s=$(awk -v  sum1="$soc_s" -v sum2="$(echo $latest_line | cut -d "," -f 10)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #10th entry in latest_line 
	soc_c=$(awk -v  sum1="$soc_c" -v sum2="$(echo $latest_line | cut -d "," -f 11)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #11th entry in latest_line
	soc_l=$(awk -v  sum1="$soc_l" -v sum2="$(echo $latest_line | cut -d "," -f 39)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #39th entry in latest_line
	
	sob_s=$(awk -v  sum1="$sob_s" -v sum2="$(echo $latest_line | cut -d "," -f 12)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #12th entry
	sob_c=$(awk -v  sum1="$sob_c" -v sum2="$(echo $latest_line | cut -d "," -f 13)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #13th entry in latest_line
	sob_l=$(awk -v  sum1="$sob_l" -v sum2="$(echo $latest_line | cut -d "," -f 40)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #40th entry in latest_line
	
	sor_s=$(awk -v  sum1="$sor_s" -v sum2="$(echo $latest_line | cut -d "," -f 14)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #14th entry in latest_line
	sor_c=$(awk -v  sum1="$sor_c" -v sum2="$(echo $latest_line | cut -d "," -f 15)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #15th entry in latest_line
	sor_l=$(awk -v  sum1="$sor_l" -v sum2="$(echo $latest_line | cut -d "," -f 41)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #41st entry in latest_line
	
	#Sequential Input
	sic_s=$(awk -v  sum1="$sic_s" -v sum2="$(echo $latest_line | cut -d "," -f 16)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #16th entry in latest_line
	sic_c=$(awk -v  sum1="$sic_c" -v sum2="$(echo $latest_line | cut -d "," -f 17)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #17th entry in latest_line
	sic_l=$(awk -v  sum1="$sic_l" -v sum2="$(echo $latest_line | cut -d "," -f 42)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #42nd entry in latest_line
	
	sib_s=$(awk -v  sum1="$sib_s" -v sum2="$(echo $latest_line | cut -d "," -f 18)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #18th entry in latest_line
	sib_c=$(awk -v  sum1="$sib_c" -v sum2="$(echo $latest_line | cut -d "," -f 19)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #19th entry in latest_line
	sib_l=$(awk -v  sum1="$sib_l" -v sum2="$(echo $latest_line | cut -d "," -f 43)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #43rd entry in latest_line
	
	#Random seeks
	rs_s=$(awk -v  sum1="$rs_s" -v sum2="$(echo $latest_line | cut -d "," -f 20)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #20th entry in latest_line
	rs_c=$(awk -v  sum1="$rs_c" -v sum2="$(echo $latest_line | cut -d "," -f 21)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #21st entry in latest_line
	rs_l=$(awk -v  sum1="$rs_l" -v sum2="$(echo $latest_line | cut -d "," -f 44)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #44th entry in latest_line
	
	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	
	scc_s=$(awk -v  sum1="$scc_s" -v sum2="$(echo $latest_line | cut -d "," -f 27)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #27th entry in latest_line
	scr_s=$(awk -v  sum1="$scr_s" -v sum2="$(echo $latest_line | cut -d "," -f 29)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #29th entry in latest_line
	scd_s=$(awk -v  sum1="$scd_s" -v sum2="$(echo $latest_line | cut -d "," -f 31)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #31st entry in latest_line
	scc_c=$(awk -v  sum1="$scc_c" -v sum2="$(echo $latest_line | cut -d "," -f 28)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #28th entry in latest_line
	scr_c=$(awk -v  sum1="$scr_c" -v sum2="$(echo $latest_line | cut -d "," -f 30)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #30th entry in latest_line
	scd_c=$(awk -v  sum1="$scd_c" -v sum2="$(echo $latest_line | cut -d "," -f 32)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #32nd entry in latest_line
	scc_l=$(awk -v  sum1="$scc_l" -v sum2="$(echo $latest_line | cut -d "," -f 45)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #45th entry in latest_line
	scr_l=$(awk -v  sum1="$scr_l" -v sum2="$(echo $latest_line | cut -d "," -f 46)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #46th entry in latest_line
	scd_l=$(awk -v  sum1="$scd_l" -v sum2="$(echo $latest_line | cut -d "," -f 47)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #47th entry in latest_line
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	rcc_c=$(awk -v  sum1="$rcc_c" -v sum2="$(echo $latest_line | cut -d "," -f 34)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #34th entry in latest_line
	rcr_c=$(awk -v  sum1="$rcr_c" -v sum2="$(echo $latest_line | cut -d "," -f 36)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #36th entry in latest_line
	rcd_c=$(awk -v  sum1="$rcd_c" -v sum2="$(echo $latest_line | cut -d "," -f 38)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #38th entry in latest_line
	rcc_s=$(awk -v  sum1="$rcc_s" -v sum2="$(echo $latest_line | cut -d "," -f 33)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #33th entry in latest_line
	rcr_s=$(awk -v  sum1="$rcr_s" -v sum2="$(echo $latest_line | cut -d "," -f 35)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #35th entry in latest_line
	rcd_s=$(awk -v  sum1="$rcd_s" -v sum2="$(echo $latest_line | cut -d "," -f 37)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #37th entry in latest_line
	rcc_l=$(awk -v  sum1="$rcc_l" -v sum2="$(echo $latest_line | cut -d "," -f 48)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #48th entry in latest_line
	rcr_l=$(awk -v  sum1="$rcr_l" -v sum2="$(echo $latest_line | cut -d "," -f 49)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #49th entry in latest_line
	rcd_l=$(awk -v  sum1="$rcd_l" -v sum2="$(echo $latest_line | cut -d "," -f 50)" 'BEGIN {printf "%i", sum1+sum2; exit(0)}' ) #50th entry in latest_line
	
done
 

last_line=$(cat bonniebenchmark/$dirname/bonnie_1.txt | tail -1)

#Calculating means of every variable 
	#Sequential Output 
mean_soc_s=$(awk -v  dividend="$soc_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_soc_c=$(awk -v  dividend="$soc_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_soc_l=$(awk -v  dividend="$soc_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )

mean_sob_s=$(awk -v  dividend="$sob_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sob_c=$(awk -v  dividend="$sob_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sob_l=$(awk -v  dividend="$sob_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )

mean_sor_s=$(awk -v  dividend="$sor_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sor_c=$(awk -v  dividend="$sor_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sor_l=$(awk -v  dividend="$sor_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )

	#Sequential Input
mean_sic_s=$(awk -v  dividend="$sic_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sic_c=$(awk -v  dividend="$sic_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sic_l=$(awk -v  dividend="$sic_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
	
mean_sib_s=$(awk -v  dividend="$sib_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sib_c=$(awk -v  dividend="$sib_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_sib_l=$(awk -v  dividend="$sib_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )

	#Random seeks
mean_rs_s=$(awk -v  dividend="$rs_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rs_c=$(awk -v  dividend="$rs_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rs_l=$(awk -v  dividend="$rs_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )

	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
mean_scc_c=$(awk -v  dividend="$scc_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_scr_c=$(awk -v  dividend="$scr_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_scd_c=$(awk -v  dividend="$scd_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
	
mean_scc_s=$(awk -v  dividend="$scc_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_scr_s=$(awk -v  dividend="$scr_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_scd_s=$(awk -v  dividend="$scd_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
	
mean_scc_l=$(awk -v  dividend="$scc_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_scr_l=$(awk -v  dividend="$scr_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_scd_l=$(awk -v  dividend="$scd_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
mean_rcc_s=$(awk -v  dividend="$rcc_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rcr_s=$(awk -v  dividend="$rcr_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rcd_s=$(awk -v  dividend="$rcd_s" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
	
mean_rcc_c=$(awk -v  dividend="$rcc_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rcr_c=$(awk -v  dividend="$rcr_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rcd_c=$(awk -v  dividend="$rcd_c" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
	
mean_rcc_l=$(awk -v  dividend="$rcc_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rcr_l=$(awk -v  dividend="$rcr_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )
mean_rcd_l=$(awk -v  dividend="$rcd_l" -v divisor="$1" 'BEGIN {printf "%.0f", dividend/divisor; exit(0)}' )

#Adding time standards to the means (us, ms)
mean_soc_l="$mean_soc_l$(echo $last_line | cut -d "," -f 39 | tr -d '0123456789')"
mean_sob_l="$mean_sob_l$(echo $last_line | cut -d "," -f 40 | tr -d '0123456789')"
mean_sor_l="$mean_sor_l$(echo $last_line | cut -d "," -f 41 | tr -d '0123456789')"

mean_sib_l="$mean_sib_l$(echo $last_line | cut -d "," -f 42 | tr -d '0123456789')"
mean_sic_l="$mean_sic_l$(echo $last_line | cut -d "," -f 43 | tr -d '0123456789')"
mean_rs_l="$mean_rs_l$(echo $last_line | cut -d "," -f 44 | tr -d '0123456789')"

mean_scc_l="$mean_scc_l$(echo $last_line | cut -d "," -f 45 | tr -d '0123456789')"
mean_scr_l="$mean_scr_l$(echo $last_line | cut -d "," -f 46 | tr -d '0123456789')"
mean_scd_l="$mean_scd_l$(echo $last_line | cut -d "," -f 47 | tr -d '0123456789')"

mean_rcc_l="$mean_rcc_l$(echo $last_line | cut -d "," -f 48 | tr -d '0123456789')"
mean_rcr_l="$mean_rcr_l$(echo $last_line | cut -d "," -f 49 | tr -d '0123456789')"
mean_rcd_l="$mean_rcd_l$(echo $last_line | cut -d "," -f 50 | tr -d '0123456789')"

#Checking if plusses were used in bonnie before(meaning that the results were too small to be reliable) 
if [ "$scc_s" -eq "0" ]
then
	mean_scc_s="+++++"
	mean_scc_c="+++"
fi

if [ "$scr_s" -eq "0" ]
then

	mean_scr_s="+++++"
	mean_scr_c="+++"
fi

if [ "$scd_s" -eq "0" ]
then
	mean_scd_s="+++++"
	mean_scd_c="+++"
fi	

if [ "$rcc_s" -eq "0" ]
then
	mean_rcc_s="+++++"
	mean_rcc_c="+++"
fi

if [ "$rcr_s" -eq "0" ]
then
	mean_rcr_s="+++++"
	mean_rcr_c="+++"
fi

if [ "$rcd_s" -eq "0" ]
then
	mean_rcd_s="+++++"
	mean_rcd_c="+++"
fi



echo "$(echo $last_line | cut -d "," -f 1),$(echo $last_line | cut -d "," -f 2),$(echo $last_line | cut -d "," -f 3),$(echo $last_line | cut -d "," -f 4),$(echo $last_line | cut -d "," -f 5),$(echo $last_line | cut -d "," -f 6),$(echo $last_line | cut -d "," -f 7),$(echo $last_line | cut -d "," -f 8),$(echo $last_line | cut -d "," -f 9),"$mean_soc_s","$mean_soc_c","$mean_sob_s","$mean_sob_c","$mean_sor_s","$mean_sor_c","$mean_sic_s","$mean_sic_c","$mean_sib_s","$mean_sib_c","$mean_rs_s","$mean_rs_c",$(echo $last_line | cut -d "," -f 22),$(echo $last_line | cut -d "," -f 23),$(echo $last_line | cut -d "," -f 24),$(echo $last_line | cut -d "," -f 25),$(echo $last_line | cut -d "," -f 26),"$mean_scc_s","$mean_scc_c","$mean_scr_s","$mean_scr_c","$mean_scd_s","$mean_scd_c","$mean_rcc_s","$mean_rcc_c","$mean_rcr_s","$mean_rcr_c","$mean_rcd_s","$mean_rcd_c","$mean_soc_l","$mean_sob_l","$mean_sor_l","$mean_sic_l","$mean_sib_l","$mean_rs_l","$mean_scc_l","$mean_scr_l","$mean_scd_l","$mean_rcc_l","$mean_rcr_l","$mean_rcd_l"" | bon_csv2txt > bonniebenchmark/summary_$dirname.txt # transforming csv to text


echo "$(echo $last_line | cut -d "," -f 1), $(echo $last_line | cut -d "," -f 2), $(echo $last_line | cut -d "," -f 3), $(echo $last_line | cut -d "," -f 4), $(echo $last_line | cut -d "," -f 5), $(echo $last_line | cut -d "," -f 6), $(echo $last_line | cut -d "," -f 7), $(echo $last_line | cut -d "," -f 8), $(echo $last_line | cut -d "," -f 9), "$mean_soc_s", "$mean_soc_c", "$mean_sob_s", "$mean_sob_c", "$mean_sor_s", "$mean_sor_c", "$mean_sic_s", "$mean_sic_c", "$mean_sib_s", "$mean_sib_c", "$mean_rs_s", "$mean_rs_c", $(echo $last_line | cut -d "," -f 22), $(echo $last_line | cut -d "," -f 23), $(echo $last_line | cut -d "," -f 24), $(echo $last_line | cut -d "," -f 25), $(echo $last_line | cut -d "," -f 26), "$mean_scc_s", "$mean_scc_c", "$mean_scr_s", "$mean_scr_c", "$mean_scd_s", "$mean_scd_c", "$mean_rcc_s", "$mean_rcc_c", "$mean_rcr_s", "$mean_rcr_c", "$mean_rcd_s", "$mean_rcd_c","$mean_soc_l", "$mean_sob_l", "$mean_sor_l", "$mean_sic_l", "$mean_sib_l", "$mean_rs_l", "$mean_scc_l", "$mean_scr_l", "$mean_scd_l", "$mean_rcc_l", "$mean_rcr_l", "$mean_rcd_l" " | tr -d "[:space:]" >> bonniebenchmark/summary_$dirname.txt

cat bonniebenchmark/summary_$dirname.txt

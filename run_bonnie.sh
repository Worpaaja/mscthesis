#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir $dirname;

#For loop for multiple runs of bonnie++
#number of loops is set in the arguments
for i in $(seq $1);
do
	#bonnie++ ran with tmp folder as the folder used, 16G filesize(it's recommended to use file size of twice your RAM size), and as root
	sudo bonnie++ -d /tmp -s 16G -u root > $dirname/bonnie_$i.txt;
done


#initiliazing variables for summary 
touch summary_$dirname.txt
soc_s=0;soc_c=0;soc_l=0;sob_s=0;sob_c=0;sob_l=0;sor_s=0;sor_c=0;sor_l=0;
sic_s=0;sic_c=0;sic_l=0;sib_s=0;sib_c=0;sib_l=0;rs_s=0;rs_c=0;rs_l=0;
scc_l=0;scr_l=0;scd_l=0;rcc_l=0;rcr_l=0;rcd_l=0;

for filename in $dirname/*.txt;
do
	latest_line=$(cat $filename | tail -1) #how to do floating point calculation efficiently?
	#echo $latest_line
	echo $filename
	#Creating sums of each attribute
	#In Bonnie:
	#_s denotes seconds, _c denotes CPU usage in percents, _l denotes latency
	#Last letter before _ is for Per Chr(c), Block(b), Rewrite(r)
	#rs is for random seeks
	
	#$(awk -v  sum1="$summarum" -v sum2="$(grep -i 'Total Computation time' -F "$filename" | cut -d ' ' -f 7)" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
	
	#Sequential Output 
	soc_s=$(awk -v  sum1="$soc_s" -v sum2="$(echo $latest_line | cut -d "," -f 10)" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' ) #10th entry in latest_line (In bonnie, 477k would be 477 in the latest_line, 273m would be 279846(but why, rounding?))
	echo $latest_line | cut -d "," -f 10
	echo $soc_s
	soc_c=$soc_c+$(echo $latest_line | cut -d "," -f 11) #11th entry in latest_line
	soc_l=$soc_l+$(echo $latest_line | cut -d "," -f 39) #39th entry in latest_line
	
	sob_s=$sob_s+$(echo $latest_line | cut -d "," -f 12) #12th entry in latest_line
	sob_c=$sob_c+$(echo $latest_line | cut -d "," -f 13) #13th entry in latest_line
	sob_l=$sob_l+$(echo $latest_line | cut -d "," -f 40) #40th entry in latest_line
	
	sor_s=$sor_s+$(echo $latest_line | cut -d "," -f 14) #14th entry in latest_line
	sor_c=$sor_c+$(echo $latest_line | cut -d "," -f 15) #15th entry in latest_line
	sor_l=$sor_l+$(echo $latest_line | cut -d "," -f 41) #41st entry in latest_line
	
	#Sequential Input
	sic_s=$sic_s+$(echo $latest_line | cut -d "," -f 16) #16th entry in latest_line
	sic_c=$sic_c+$(echo $latest_line | cut -d "," -f 17) #17th entry in latest_line
	sic_l=$sic_l+$(echo $latest_line | cut -d "," -f 42) #42nd entry in latest_line
	
	sib_s=$sib_s+$(echo $latest_line | cut -d "," -f 18) #18th entry in latest_line
	sib_c=$sib_c+$(echo $latest_line | cut -d "," -f 19) #19th entry in latest_line
	sib_l=$sib_l+$(echo $latest_line | cut -d "," -f 43) #43rd entry in latest_line
	
	#Random seeks
	rs_s=$rs_s+$(echo $latest_line | cut -d "," -f 20) #20th entry in latest_line
	rs_c=$rs_c+$(echo $latest_line | cut -d "," -f 21) #21st entry in latest_line
	rs_l=$rs_l+$(echo $latest_line | cut -d "," -f 44) #44th entry in latest_line
	
	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	scc_l=$scc_l+$(echo $latest_line | cut -d "," -f 45) #45th entry in latest_line
	scr_l=$scr_l+$(echo $latest_line | cut -d "," -f 46) #46th entry in latest_line
	scd_l=$scd_l+$(echo $latest_line | cut -d "," -f 47) #47th entry in latest_line
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	rcc_l=$rcc_l+$(echo $latest_line | cut -d "," -f 48) #48th entry in latest_line
	rcr_l=$rcr_l+$(echo $latest_line | cut -d "," -f 49) #49th entry in latest_line
	rcd_l=$rcd_l+$(echo $latest_line | cut -d "," -f 55) #50th entry in latest_line
	
	#summarum=$(awk -v  sum1="$summarum" -v sum2="$(grep -i 'Total Computation time' -F "$filename" | cut -d ' ' -f 7)" 'BEGIN {printf "%.3f", sum1+sum2; exit(0)}' )
done
 
#Calculating means of every variable 
	#Sequential Output 
	mean_soc_s=$(awk -v  dividend="$soc_s" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_soc_c=$(awk -v  dividend="$soc_c" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_soc_l=$(awk -v  dividend="$soc_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	mean_sob_s=$(awk -v  dividend="$sob_s" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sob_c=$(awk -v  dividend="$sob_c" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sob_l=$(awk -v  dividend="$sob_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	mean_sor_s=$(awk -v  dividend="$sor_s" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sor_c=$(awk -v  dividend="$sor_c" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sor_l=$(awk -v  dividend="$sor_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	#Sequential Input
	mean_sic_s=$(awk -v  dividend="$sic_s" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sic_c=$(awk -v  dividend="$sic_c" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sic_l=$(awk -v  dividend="$sic_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	mean_sib_s=$(awk -v  dividend="$sib_s" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sib_c=$(awk -v  dividend="$sib_c" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_sib_l=$(awk -v  dividend="$sib_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	#Random seeks
	mean_rs_s=$(awk -v  dividend="$rs_s" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_rs_c=$(awk -v  dividend="$rs_c" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_rs_l=$(awk -v  dividend="$rs_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	#Sequential Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	mean_scc_l=$(awk -v  dividend="$scc_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_scr_l=$(awk -v  dividend="$scr_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_scd_l=$(awk -v  dividend="$scd_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	
	#Random Create
	#Last letter before _ is for Create(c), Read(r), Delete(d)
	mean_rcc_l=$(awk -v  dividend="$rcc_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )
	mean_rcr_l=$(awk -v  dividend="$rcr_l" -v divisor="$1" 'BEGIN {printf "%.3f", dividend/divisor; exit(0)}' )


last_line=$(cat $dirname/bonnie_1.txt | tail -1)
echo $last_line
echo "Summary of bonnie++ runs starting at $dirname and ran on $(echo $last_line | cut -d "," -f 3)" >> summary_$dirname.txt
echo "File size for the runs was $(echo $last_line | cut -d "," -f 6) and number of files was $(echo $last_line | cut -d "," -f 22)" >> summary_$dirname.txt
echo "        ------Sequential Output------ --Sequential Input- --Random-" >> summary_$dirname.txt
echo "        -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--" >> summary_$dirname.txt
echo "         /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP" >> summary_$dirname.txt
echo "         "$mean_soc_s"  "$mean_soc_c"  "$mean_sob_s"  "$mean_sob_c"  "$mean_sor_s"  "$mean_sor_c" "$mean_sic_s"  "$mean_sic_c"  "$mean_sib_s"  "$mean_sib_c"  "$mean_rs_s"  "$mean_rs_c"" >> summary_$dirname.txt #pitääkö tähän kattoo jotku tabulaattori säännöt
echo "Latency   "$mean_soc_l"   "$mean_sob_l"     "$mean_sor_l"    "$mean_sic_l"    "$mean_sib_l"   "$mean_rs_l"" >> summary_$dirname.txt
echo "        ------Sequential Create------ --------Random Create--------" >> summary_$dirname.txt
echo "        -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--" >> summary_$dirname.txt
echo "         /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP" >> summary_$dirname.txt
echo "        +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++" >> summary_$dirname.txt #most likely a filler line
echo "Latency   "$mean_scc_l"     "$mean_scr_l"     "$mean_scd_l"     "$mean_rcc_l"      "$mean_rcr_l"    "$mean_rcd_l"" >> summary_$dirname.txt
cat summary_$dirname.txt

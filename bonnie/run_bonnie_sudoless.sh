#!/bin/bash

dirname=$(date +%d-%m-%y--%H-%M);
mkdir bonniesudolessbenchmark;
mkdir bonniesudolessbenchmark/$dirname;

#For loop for multiple runs of bonnie++
#number of loops is set in the arguments
for i in $(seq $1);
do
	#bonnie++ ran with 16G filesize(it's recommended to use file size of twice your RAM size), and as root
	bonnie++ -s 16G -u root > bonniesudolessbenchmark/$dirname/bonnie_$i.txt;
done


#This is the master script used to install all benchmarking tools

#!/bin/sh

sudo apt-get update
sudo apt install curl
sudo apt install make

#Installing y-cruncher, only required to download and extract
curl -O -L http://www.numberworld.org/y-cruncher/y-cruncher%20v0.8.4.9538-static.tar.xz -o y-cruncher.tar.xz
tar xf y-cruncher%20v0.8.4.9538-static.tar.xz

#Sysbench installing
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash
sudo apt -y install sysbench

#This is the script for installing LAPACK
curl -O -L https://github.com/Reference-LAPACK/lapack/archive/refs/tags/v3.12.0.tar.gz
tar xf v3.12.0.tar.gz
sudo apt install gfortran
cd lapack-3.12.0
cp make.inc.example make.inc
make
cd ..

#STREAM installing
#You need to modify .c or .f based on if you want to use C language or Fortran
#install stream to \home
#Array size can also be modified when compiling(with some compilers), array size needs to be at least 4x the cache size, used laptop has cache of 3MiB
#gcc -O -DSTREAM_ARRAY_SIZE=12000000 stream.c -o stream.12M would create array size of 12MiB
#using default variables(that can handle 20MB caches)
mkdir stream
cd stream
wget --no-parent --recursive --level=1 --no-directories --no-host-directories https://www.cs.virginia.edu/stream/FTP/Code/
gcc -O stream.c -o stream
cd ..

#Bonnie++ installing
sudo apt install bonnie++

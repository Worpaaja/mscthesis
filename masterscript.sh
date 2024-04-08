#!/bin/sh

cd "$(dirname "$0")"

echo "Running y-cruncher"

cd "y-cruncher/y-cruncher v0.8.4.9538-static"

./ycruncherbench.sh 50

cd ..
cd ..

echo "Running bonnie"

cd bonnie

./run_bonnie.sh 50

cd ..

echo "Running stream"

cd stream

./runstream.sh 50

cd ..

cd sysbench

echo "Sysbench CPU test"

./run_sysbench_cpu.sh 50

echo "Sysbench file I/O test"
./run_sysbench_io.sh 50

echo "Sysbench memory test" 
./run_sysbench_memory.sh 50


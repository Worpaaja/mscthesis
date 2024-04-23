#!/bin/sh

cd "$(dirname "$0")"

echo "Running y-cruncher"

cd y-cruncher/

./ycruncherbench.sh $1

cd ..

echo "Running bonnie"

cd bonnie

./run_bonnie.sh $1

cd ..

echo "Running stream"

cd stream

./runstream.sh $1

cd ..

cd sysbench

echo "Sysbench CPU test"

./run_sysbench_cpu.sh $1

echo "Sysbench file I/O test"
./run_sysbench_io.sh $1

echo "Sysbench memory test" 
./run_sysbench_memory.sh $1


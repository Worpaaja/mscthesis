#!/bin/sh

docker run --rm -m 4GB --cpus 2 -v=./../results/ycruncher:/ycruncher/ycrunchbenchmark -v=./../results/stream:/stream/streambenchmark -v=./../results/sysbench_io:/sysbench/benchmark_fileio -v=./../results/sysbench_cpu:/sysbench/benchmark_cpu -v=./../results/sysbench_mem:/sysbench/benchmark_mem -v=./../results/bonnie:/bonnie/bonniebenchmark benchmarkingtools ./masterscript.sh $1

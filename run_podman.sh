#!/bin/sh
podman run --rm -v=./../results/ycruncher:/ycruncher/ycrunchbenchmark -v=./../results/stream:/stream/streambenchmark -v=./../results/sysbench_io:/sysbench/benchmark_fileio -v=./../results/sysbench_cpu:/sysbench/benchmark_cpu -v=./../results/sysbench_mem:/sysbench/benchmark_mem -v=./../results/bonnie:/bonnie/bonniebenchmark localhost/benchmarkimage ./masterscript.sh $1

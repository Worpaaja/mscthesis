#!/bin/sh

#This script is for installing bonnie++, sysbench and for changing necessary script permissions

sudo apt update
#Installing bonnie++
sudo apt install bonnie++

#Installing sysbench
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash
sudo apt -y install sysbench

#Setting Script permissions
#First masterscript that runs the other scripts
sudo chmod 755 masterscript.sh 

#Permission change for Bonnie scripts
sudo chmod 755 bonnie/run_bonnie.sh bonnie/run_bonnie_sudoless.sh bonnie/run_bonnie_sudoless_rootless.sh

#Permission change for stream script and files
sudo chmod 755 stream/stream stream/runstream.sh

#Permission change for sysbench
sudo chmod 755 sysbench/run_sysbench_cpu.sh sysbench/run_sysbench_io.sh sysbench/run_sysbench_memory.sh

#Permission change for y-cruncher
sudo chmod 755 ycruncher/y-cruncher ycruncher/ycruncherbench.sh
sudo chmod -R 755 ycruncher/Binaries

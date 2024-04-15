# syntax=docker/dockerfile:1

#Ubuntu is used in the native and VMs 
FROM ubuntu:22.04


WORKDIR /
#Installing necessary tools
RUN apt-get update \
	curl \ 
	curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash  \
	sudo apt -y install sysbench
	sudo apt -y install bonnie++
	
COPY . .

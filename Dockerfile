# syntax=docker/dockerfile:1

#Ubuntu is used in the native and VMs 
FROM ubuntu:22.04


WORKDIR /
#Installing necessary tools
RUN apt-get update \
	&& apt-get install -y curl \
	&& curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh \
	&& apt-get install -y \
	sysbench \
	bonnie++ \
	&& rm -rf /var/lib/apt/lists/*

USER 0:0

COPY . .

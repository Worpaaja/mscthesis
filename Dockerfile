# syntax=docker/dockerfile:1

#Use docker run -v <volume name>:/benchmark <imagename>
#Volumes are stored at /var/lib/docker/volumes/target/_data/<volume_name>

#Can also bet set when building with --build-arg TEST_NUMBER=<number>
FROM ubuntu:22.04

WORKDIR /

COPY . .

#Runs the script with specified number of runs
#Should the scripts be ran as root
#ARG TEST=2
#ENTRYPOINT ["bin/bash", "-c", "./ycruncherbench.sh", "echo $TEST"]

#Change the number for number of tests
CMD "./ycruncherbench.sh" "5"

#Works with below
#ENTRYPOINT "./ycruncherbench.sh" "2"
#

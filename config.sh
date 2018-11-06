#!/usr/bin/env bash

###########################################
#                                         #
#      Red vs Blue Team Configuration     #
#      @543hn                             #
#                                         #
###########################################

###########
# CONFIG  #
###########

#team_number=1 # Number of teams DISABLED until multi-team support
#fake_data=1 # Enable or disable competing against fake teams.

image1="image1" # Image name
image1_ip="192.168.1.200"
image1_services=("ssh_22" "http_80") # Number and port of services to check

image2="image2" # Image name
image2_ip="192.168.1.150"
image2_services=("ssh_22" "http_80" "https_8006") # Number and port of services to check


check_services(){
    # Fill out this function to score data
    echo -n > site/scoring_data
    service_report '1' $image1 $image1_ip "${image1_services[@]}"
    service_report '2' $image2 $image2_ip "${image2_services[@]}"
    
}

# Injects
# Input injects here. Works as you would expect. Syntax spawns subshell and disowns it
# TODO: injector and announcer

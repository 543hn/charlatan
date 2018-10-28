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


image_number="5" # Number of images
image1="image1" # Image name
image1_ip="192.168.1.200"
image1_services=("ssh_22" "http_80") # Number and port of services to check


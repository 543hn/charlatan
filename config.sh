#!/usr/bin/env bash

###########################################
#                                         #
#      Red vs Blue Team Config            #
#      @543hn                             #
#                                         #
###########################################

###########
# CONFIG  #
###########

scoring_port="80" # Port of scoring server
check_time=60 # Time in seconds between checks
check_points=1 # Points per service per check
patch_port="8000" # Port of patch server
team_number=1 # Number of teams
sla_times=5 # Number of failed checks to incur an SLA violation
sla_points=5 # Number of points to deduct per SLA

# Checks: ICMP, SSH, HTTP, SMTP, RDP, DNS, FTP, SMB
team1_pass="password"
team1_image1="image1" # Image name
    team1_image1_checks=("ssh" "http") # Insert checks in this array

    

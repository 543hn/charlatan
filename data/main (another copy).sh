#!/usr/bin/env bash

###########################################
#                                         #
#      Red vs Blue Team Scoring Server    #
#      @543hn                             #
#                                         #
###########################################

###############
# COLOR CODES #
###############

nc='\e[m'
r='\033[1;31m'
y='\033[1;33m'
g='\033[1;32m'

plus="${g}[+]${nc}"
prompt="${y}[?]${nc}"
warn="${y}[!]${nc}"
err="${r}{!]${nc}"

###########
# CONFIG  #
###########

scoring_port="80" # Port of scoring server
check_time=60 # Time in seconds between checks
patch_port="8000" # Port of patch server
team_number=1 # Number of teams
sla_times=5 # Number of failed checks to incur an SLA violation
sla_points=5 # Number of points to deduct per SLA

# Checks: ICMP, SSH, HTTP, SMTP, RDP, DNS, FTP, SMB
team1_pass="password"
team1_images=""


#########
# CODE  #
#########

# Root check
if [[ $EUID -ne 0 ]]; then
   echo -e "${err} Ravioli Ravioli give me the Root-ioli."
   exit 1
fi

# Catch CTRL+C to avoid having 50 webservers running
trap_ctrlC() {
    echo -e "\n${plus} Killing webservers..."
    pkill -xf "python3 -m http.server" && \
    echo -e "${plus} Bye!"
    exit 0
}

trap trap_ctrlC SIGINT SIGTERM

for f in {1..${team_number}}; do
    echo "eee"
done

dumpData

################
# PATCH SERVER #
################

cd ./patch/ || echo -e "${err} Couldn't cd into ./patch/."
python3 -m http.server ${patch_port} &
echo -e "${plus} Launched webserver."
cd ..

##################
# SCORING SERVER #
##################

while true; do
    :
done

# Score aggregation 

# how to do it for windows too?


# Scoring engine

# sla violations
# checks for: 





echo -e "${plus} Press CTRL+C to terminate..."







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

#########
# CODE  #
#########

# Root check
if [[ $EUID -eq 0 ]]; then
   echo -e "${err} Don't run this as root."
   exit 1
fi

# Load config
source config.sh

# Catch CTRL+C to avoid having 50 webservers running
trap_ctrlC() {
    echo -e "\n${plus} Killing webservers..."
    pkill -xf "python3 -m http.server"
    echo -e "\n${plus} Archiving data..."
    zip -r "archives/scoringdata-$(date +"%Y-%m-%d").zip" data
    echo -e "${plus} Bye!"
    exit 0
}

trap trap_ctrlC SIGINT SIGTERM

# Webserver
python3 -m http.server &
echo -e "${plus} Launched webserver."

echo -e "${plus} Press CTRL+C to terminate..."

# Score aggregation 

# how to do it for windows too?


# Scoring engine

# sla violations
# checks for: 

#CHECK Function 

# Check config
source config.sh

for ((i = 1; i <= "${team_number}"; i++)); do
    echo "$i"
done

#SLA counter function

#Score output function

while true; do
    :
done




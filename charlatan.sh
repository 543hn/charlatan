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

source ./scripts/color_codes.sh

#############
# FUNCTIONS #
#############
    
sleep_counter(){ # dont actually just sleep... listen for new injects, inject responses, announcements
    
    source config # for competition duration
    check_time="$(( $( shuf -i0-60 -n1 ) + 0 ))"
    
    if (( $countup >= $competition_duration )); then
        echo -e "${plus} COMPETITION IS OVER!"
        exit 0
    elif (( (( $countup+$check_time )) >= $competition_duration )); then
        (( check_time=$competition_duration-$countup ))
        echo -e "${plus} LAST CHECK! COMPETITION ENDING IN $check_time!"
        sleep $check_time
    else
        echo -e "${plus} $check_time seconds until next cycle."
        ((countup+=$check_time))
        sleep $check_time
    fi
}


##################
# INITIALIZATION #
##################

# Root check
if [[ $EUID -eq 0 ]]; then
   echo -e "${err} Please run as sudo so the webserver can listen on port 80, and nmap can perform UDP scans."
   echo -e "need to change if statement: no sudo during development"
   exit 1
fi

# Catch CTRL+C to clean up
trap_ctrlC() {
    echo -e "\n${plus} Killing webservers..."
    pkill -xf "python3 -m http.server"
    echo -e "${plus} Dumping database..."
    echo -e "${plus} Bye!"
    exit 0
}

trap trap_ctrlC SIGINT SIGTERM


# INIT

scripts/init_config.sh # Init filesystem based on config
scripts/injector.sh # Parse and queue injects based on config
countup=0

# Scoring loop

echo -e "${plus} Edit site/announcements and site/injects to add them."
echo -e "${plus} Hit enter to begin scoring." && read

echo -n > data/scoring_status
scripts/web_update.sh
scripts/uptime_calculator.sh

# Webserver
cd web && python3 -m http.server & # add port 80 later
echo -e "${plus} Launched webserver."


while true; do
    scripts/score_cycle.sh
    scripts/tallyer.sh
    scripts/web_update.sh
    scripts/uptime_calculator.sh
    # tally all scores into totals. previous functions only operate on subdirs
    sleep_counter
done


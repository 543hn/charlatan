#!/usr/bin/env bash

###########################################
#                                         #
#      Red vs Blue Team Scoring Server    #
#      @543hn                             #
#                                         #
###########################################

#########
# CODE  #
#########

# Root check
if [[ $EUID -eq 0 ]]; then
   echo -e "${err} Don't run this as root."
   exit 1
fi

# Load config and functions
source config.sh
source functions.sh

# Catch CTRL+C to avoid having 50 webservers running
trap_ctrlC() {
    echo -e "\n${plus} Killing webservers..."
    pkill -xf "python3 -m http.server"

    echo -e "${plus} Bye!"
    exit 0
}

trap trap_ctrlC SIGINT SIGTERM

# Webserver
python3 -m http.server &
echo -e "${plus} Launched webserver."

# Scoring loop
create_files

while true; do
    check_sla
    check_services
    update_web
    random_sleep
    source config.sh
    source functions.sh
done


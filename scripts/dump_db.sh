#!/bin/bash

source scripts/color_codes.sh

# check 


dump_db() {

    # for each team, image, service dump file (how undump?)
    echo "db dumped to file (not really)"
    
    # dump countdown, duration, team number, team w/e
    # just dump scores?


}

if [ -e "saved_db" ]; then
    echo -n "${warn} Existing dumped database (saved_db) exists! Overwrite this file? (y/N)"
    read -r response
    case "$response in"
        [yY]) dump_db
        * ) echo -n "${plus} Not overwriting file."
    esac
fi

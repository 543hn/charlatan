#!/bin/bash

source ./scripts/color_codes.sh

# CHECK DATA AND ASK QUESTION: want to reuse data dump file?
    # add sanity check: do you want to continue? files exist

rm -rf data/*

source config

# 'global' variables

echo -e "CHECKS=0" > data/global
echo -n > data/sla_violations

# for each team

for (( t=1; t<=$number_of_teams; t++ )); do
    
    mkdir data/"team$t"/ && echo -e "TOTAL_SERVICE=0\nTOTAL_CCS=0\nSLA_POINTS=0" > data/"team$t"/totals

    for (( i=1; i<=$number_of_images; i++ )); do
        
        # for each image
        image_name="image$i"
        image_services=image${i}_services[@]
        mkdir data/"team$t"/"${!image_name}"
        
        for s in "${!image_services}"; do
        
            # for each service
            service_name=$(echo $s | cut -d "_" -f1) 
            underscore="_"
            echo -e "SERVICE_POINTS=0\nSLA_COUNTER=0\nSLA_POINTS=0\nCSS_POINTS=0" > data/"team$t"/"${!path}"/"${!image_name}"/"${!image_name}$underscore$service_name"
        
        done
        
    done

done

echo -e "${plus} Reset data/* and reinstated necessary files."




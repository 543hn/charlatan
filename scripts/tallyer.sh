#!/bin/bash

source scripts/color_codes.sh
source config

setValue(){ # takes path, variable name, and value
    source $1
    sed -i -e "/$2=/ s/=.*/=$3/" $1
}

for (( t=1; t<=$number_of_teams; t++ )); do

    team_path=data/"team$t"/totals

    total_service_points=0
    # total_ccs_points=0 todo
    total_sla_points=0

    for (( i=1; i<=$number_of_images; i++ )); do
        
        # for each image
        image_name="image$i"
        image_services=image${i}_services[@]

        for s in "${!image_services}"; do
        
            service_name=$(echo $s | cut -d "_" -f1)
            service_port=$(echo $s | cut -d "_" -f2)
            service_path=data/"team$t"/"${!image_name}"/"${!image_name}"_"$service_name"
            service_ip="${!team_ip}${!image_ip}"
            
            source $service_path
            
            (( total_service_points+=$SERVICE_POINTS ))  
            (( total_sla_points+=$SLA_POINTS ))
            
        
        done
        
    done

    setValue $team_path TOTAL_SERVICE $total_service_points
    setValue $team_path SLA_POINTS $total_sla_points

done

echo -e "${plus} Totals tallied for each team."

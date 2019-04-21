#!/bin/bash

###############
# COLOR CODES #
###############

source ./scripts/color_codes.sh

########
# CODE #
########

crementValue(){ # takes path, variable name, and value
    source $1
    ((value=${!2}+$3))
    sed -i -e "/$2=/ s/=.*/=$value/" $1
}

setValue(){ # takes path, variable name, and value
    source $1
    sed -i -e "/$2=/ s/=.*/=$3/" $1
}

getValue(){ # takes path, variable name
    source $1
    echo ${!2}
}

# score and hash out those values

source config
crementValue data/global CHECKS 1

# for each team

echo "<table>" > data/scoring_status
echo "<tr>" >> data/scoring_status
echo "<th></th> <!-- services -->" >> data/scoring_status
echo "</tr>" >> data/scoring_status

for (( t=1; t<=$number_of_teams; t++ )); do

    echo "<tr>" >> data/scoring_status
    echo "<td>team$t</td>" >> data/scoring_status
    echo "</tr>" >> data/scoring_status

    for (( i=1; i<=$number_of_images; i++ )); do
        
        # for each image
        image_name="image$i"
        team_ip="team${t}_ip"
        image_ip="image${i}_ip"
        image_services=image${i}_services[@]

        for s in "${!image_services}"; do
        
            service_name=$(echo $s | cut -d "_" -f1)
            service_port=$(echo $s | cut -d "_" -f2)
            service_path=data/"team$t"/"${!image_name}"/"${!image_name}"_"$service_name"
            service_ip="${!team_ip}${!image_ip}"           
            
            if ! grep -q "<th>${!image_name}_$service_name</th>" data/scoring_status; then
                sed -i "/services/a <th>${!image_name}_$service_name</th>" data/scoring_status
            fi
            
            if nmap -Pn -p "${service_port}" --max-retries 3 --host-timeout 3 -T4 "$service_ip" \
                | grep "open" | grep -q "${service_name}"; then
                echo -e "${plus} Service $service_name on port $service_port is UP on ${!image_name} (team$t)."
                crementValue $service_path SERVICE_POINTS 1     
                setValue $service_path SLA_COUNTER 0
                sed -i "/team$t/a <td><font color='green'>PASS</font><br></td>" data/scoring_status
            else
                echo -e "${warn} Service $service_name on port $service_port is DOWN on ${!image_name} (team$t)."
                crementValue $service_path SLA_COUNTER 1
                sed -i "/team$t/a <td><font color='red'>FAIL</font><br></td>" data/scoring_status
                    
                # Check SLA violation status
                    
                if (( $(getValue $service_path SLA_COUNTER) >= 5 )); then
                    echo -e "${warn} team$t has lost 5 points due to an SLA violation ($service_name on ${!image_name})."
                    echo "SLA Violation: -5 points" >> data/sla_violations
                    crementValue $service_path SLA_POINTS -5
                fi

            fi
        
        done
        
    done

done

echo "</table>" >> data/scoring_status



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

source data/global
source config

# for each team

echo "<table>" > data/uptime_status
echo "<tr>" >> data/uptime_status
echo "<th></th> <!-- services -->" >> data/uptime_status
echo "</tr>" >> data/uptime_status

for (( t=1; t<=$number_of_teams; t++ )); do

    echo "<tr>" >> data/uptime_status
    echo "<td>team$t</td>" >> data/uptime_status
    echo "</tr>" >> data/uptime_status

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
            
            if ! grep -q "<th>${!image_name}_$service_name</th>" data/uptime_status; then
                sed -i "/services/a <th>${!image_name}_$service_name</th>" data/uptime_status
            fi
            
            source $service_path # get SERVICE_POINTS for each service
            
            if (( $CHECKS > 0 )); then
                percent=$(( 100 * SERVICE_POINTS / CHECKS + (1000 * SERVICE_POINTS / CHECKS % 10 >= 5 ? 1 : 0) ))
                if (( $percent >= 80 )); then           
                    sed -i "/team$t/a <td style='background-color:green;color:white;'>$percent%</td>" data/uptime_status         
                elif (( $percent >= 60 )); then
                    sed -i "/team$t/a <td style='background-color:yellow;color:black;'>$percent%</td>" data/uptime_status          
                else
                    sed -i "/team$t/a <td style='background-color:darkred;color:white;'>$percent%</td>" data/uptime_status
                fi
            else
                sed -i "/team$t/a <td>N/A%</td>" data/uptime_status
            fi
  
        done
        
    done

done

echo "</table>" >> data/uptime_status

injects=$(cat data/injects)
announcements=$(cat data/announcements)
uptime_status=$(cat data/uptime_status)
html="<!DOCTYPE html><html><head>
      <title>Scoring Server</title>
      <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
      </style>
      <body>
      <img src='background.png' style='width:100%'/>
      <h2>Team Portal</h2>
      <h3>Services</h3>${uptime_status}<br><a href=index.html>Current service status</a><hr>
      <h3>Injects</h3>${injects}<br><hr>
      <h3>Announcements</h3>${announcements}<br><hr>
      <h3>Links</h3><ul>
        <li><a href='patch'>Patch server</a></li>
        <li><a href='sla_violations.txt'>SLA violations</a></li>
      </ul><hr></body></html>"
echo "$html" > web/uptime.html

echo -e "${plus} Updated uptime status webpage."



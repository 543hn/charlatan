#!/usr/bin/env bash

###########################################
#                                         #
#      Red vs Blue Team Functions         #
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

#############
# FUNCTIONS #
#############

increment(){
    increment=$(cat data/$1)
    ((increment+=1))
    echo $increment > data/$1
}

check_sla(){
    for file in data/*failcount; do
        if grep -q "5" $file; then
            echo -e "${warn} Team has lost 5 points due to an SLA violation ($file)."
            echo "SLA Violation: -5 points" >> data/sla_violations.txt
            deduction=$(cat data/total_score)
            ((deduction-=5))
            echo $deduction > data/total_score
            echo "0" > $file
        fi
    done
}


ping_service(){
    IFS=_ read name port <<< "$1"
    if nmap -Pn -p "${port}" --max-retries 3 --host-timeout 3 "$2" \
        | grep "open" | grep -q "${name}"; then
        echo -e "${plus} Service ${name} is up. ($2)"
        increment total_score
        increment image1_"${name}"_points
        increment image1_"${name}"_checks
        echo "0" > data/image1_"${name}"_failcount
        echo "${name}: <font color='green'>OK</font><br>" >> site/scoring_data
    else
        echo -e "${warn} Service ${name} is down! ($2)"
        echo "${name}: <font color='red'>FAIL</font><br>" >> site/scoring_data
        increment image1_"${name}"_failcount
    fi
}

check_services(){
    echo -n > site/scoring_data
    
    echo "Image 1 ($image1):<br>" >> site/scoring_data
    for service in "${image1_services[@]}"; do
        ping_service $service $image1_ip
    done
    echo "<br>" >> site/scoring_data
    
    echo "Image 2 ($image2):<br>" >> site/scoring_data
    for service in "${image2_services[@]}"; do
        ping_service $service $image2_ip
    done
    echo "<br>" >> site/scoring_data
    
    echo "Image 3 ($image3):<br>" >> site/scoring_data
    for service in "${image3_services[@]}"; do
        ping_service $service $image3_ip
    done
    echo "<br>" >> site/scoring_data
    
    echo "Image 4 ($image4):<br>" >> site/scoring_data
    for service in "${image4_services[@]}"; do
        ping_service $service $image4_ip
    done
    echo "<br>" >> site/scoring_data
    
    echo "Image 5 ($image5):<br>" >> site/scoring_data
    for service in "${image5_services[@]}"; do
        ping_service $service $image5_ip
    done
    echo "<br>" >> site/scoring_data
    
}
        
random_sleep(){
    #check_time="$(( $( shuf -i0-60 -n1 ) + 120 ))"
    check_time=10
    echo -e "${plus} Sleeping for $check_time."
    sleep $check_time
}

create_files(){
    rm -r data/*
    touch data/sla_violations
    touch data/total_score
    for service in "${image1_services[@]}"; do
        IFS=_ read name port <<< "$service"
        touch data/image1_"${name}"_failcount
        touch data/image1_"${name}"_checks
        touch data/image1_"${name}"_points
    done
    echo -e "${plus} Removed data/* and reinstated necessary files."
}

update_web(){
    injects=$(cat site/injects)
    announcements=$(cat site/announcements)
    scoring_data=$(cat site/scoring_data)
    html="<!DOCTYPE html>
            <html>
            <head>
            <title>Scoring Server</title>
            <body>

            <img src='site/background.png' style='width:100%'/>
            <h2>Team Portal</h2>

            <h3>Injects</h3>
            ${injects}
            <hr>

            <h3>Services</h3>
            ${scoring_data}
            <hr>

            <h3>Announcements </h3>
            ${announcements}
            <hr>
            
            <h3>Links</h3>
            <ul>
                <li><a href='patch'>Patch server</a></li>
                <li><a href='data/sla_violations.txt'>SLA Violations</a></li>
            </ul>
            <hr>

            </body>
            </html>"
    echo $html > index.html
    echo -e "${plus} Updated team portal webpage."
}


#################
# HTML TEMPLATE #
#################



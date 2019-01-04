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
    increment=$(cat $1)
    ((increment+=1))
    echo $increment > $1
}

check_sla(){
    for file in data/*; do
        if grep -q "5" $file && ls $file | grep -q "failcount"; then
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
    if nmap -Pn -p "${port}" --max-retries 3 --host-timeout 3 "$1" \
        | grep "open" | grep -q "${name}"; then
        echo -e "${plus} Service ${name} is up. ($1) ($port)"
        increment data/total_score
        increment data/image"${2}"_"${name}"_checks
        increment data/image"${2}"_"${name}"_points
        echo "0" > data/image"${2}"_"${name}"_failcount
        echo "${name}: <font color='green'>OK</font><br>" >> site/scoring_data
    else
        echo -e "${warn} Service ${name} is down! ($1) ($port)"
        echo "${name}: <font color='red'>FAIL</font><br>" >> site/scoring_data
        increment data/image"${2}"_"${name}"_failcount
    fi
}

service_report(){
    arr=("$@") 
    for service in "${arr[@]:3}"; do
        IFS=_ read name port <<< "$service"
        touch data/image"${arr[0]}"_"$name"_failcount
        touch data/image"${arr[0]}"_"$name"_checks
        touch data/image"${arr[0]}"_"$name"_points
        ping_service "${arr[2]}" "${arr[0]}" 
    done
}

        
random_sleep(){
    #check_time="$(( $( shuf -i0-60 -n1 ) + 120 ))"
    check_time="$(( $( shuf -i0-60 -n1 ) + 0 ))"
    echo -e "${plus} Sleeping for $check_time."
    sleep $check_time
}

create_files(){
    rm -r data/*
    touch data/sla_violations.txt
    echo -n > site/announcements
    echo -n > site/injects
    echo "0" > data/total_score
    echo -e "${plus} Removed data/* and reinstated necessary files."
}

update_web(){
    total_score=$(cat data/total_score)
    injects=$(cat site/injects)
    announcements=$(cat site/announcements)
    scoring_data=$(cat site/scoring_data)
    html="<!DOCTYPE html><html><head>
          <title>Scoring Server</title>
          <body>
          <img src='site/background.png' style='width:100%'/>
          <h2>Team Portal</h2>
          <h3>Injects</h3>${injects}<br><hr>
          <h3>Services</h3>${scoring_data}<br>
          Total team score: ${total_score}<hr>
          <h3>Announcements</h3>${announcements}<br><hr>
          <h3>Links</h3><ul>
            <li><a href='patch'>Patch server</a></li>
            <li><a href='data/sla_violations.txt'>SLA Violations</a></li>
          </ul><hr></body></html>"
    echo $html > index.html
    echo -e "${plus} Updated team portal webpage."
}





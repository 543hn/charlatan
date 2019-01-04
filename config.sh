#!/usr/bin/env bash

###########################################
#                                         #
#      Red vs Blue Team Configuration     #
#      @543hn                             #
#                                         #
###########################################

###########
# CONFIG  #
###########

#team_number=1 # Number of teams DISABLED until multi-team support
#fake_data=1 # Enable or disable competing against fake teams.

image1="sawmill" # Image name
image1_ip="192.168.1.201"
image1_services=("ms-wbt-server_3389") # Number and port of services to check

image2="grange" # Image name
image2_ip="192.168.1.203"
image2_services=("ftp_21" "microsoft-ds_445" "http_80" "ms-wbt-server_3389") # Number and port of services to check

image3="mountainlab" # Image name
image3_ip="192.168.1.200"
image3_services=("domain_53" "microsoft-ds_445" "ftp_21" "ms-wbt-server_3389") # Number and port of services to check

image4="junction" # Image name
image4_ip="192.168.1.204"
image4_services=("http_80" "ms-wbt-server_3389") # Number and port of services to check


check_services(){
    # Fill out this function to score data
    # Replicate for each image (image1, image2, image3...)
    echo -n > site/scoring_data
    service_report '1' $image1 $image1_ip "${image1_services[@]}"
    service_report '2' $image2 $image2_ip "${image2_services[@]}"
    service_report '3' $image3 $image3_ip "${image3_services[@]}"
    service_report '4' $image4 $image4_ip "${image4_services[@]}"
    
}

# Injects
# Input injects here. Syntax: injector 'inject_text' minutes
injector 'Install and ensure functionality of ssh server on upward' 15
injector 'Add badlands and sawmill to the Mann.local domain' 25
injector 'User saxton was fired for violence in the workplace, delete his account on all machines' 30
injector 'Surprise inspection by corporate! Please give the white team password for user sniper.' 40
injector 'Write an incident report on one incident report for any suspicious activity your team has seen up to this point.' 50
injector 'Enable anonymous read on grange Filezilla FTP server' 61
injector 'Promote grange to a Domain Controller' 90
injector 'Add user fruit to the Mann.local domain' 100
injector 'Install php and set up a handler on junction IIS server.'
injector 'Write an incident report on the backdoor php shells on grange' 135
injector 'Promote sawmill to a domain controller' 160
injector 'Apply a password policy GPO of 30 days max password age in the Mann.local domain' 190
injector 'Remove all extraneous SMB shares on mountainlab.' 210
injector 'Promote Gray to admin in the mann.local domain' 220


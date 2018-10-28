# Red vs Blue Team Scoring Engine (CyberPatriot and CCDC)

__EXTREMELY__ SIMPLE scoring/patch server
Why is it written in bash? why not 
Requirements: bash
python3
nmap
serves as practice for ONE TEAM, is _not_ competition software (yet)

## Section 1: Patch Server

Files in `./patch/` will be served with a basic Python HTTP server on port 8000/patch. Config data inputted in `config.sh` will be used to score service uptime with nmap.

todo: add password 
multiple teams
team graph
Injects, announcements, etc
checking service configs
making sure nmap is installed
being able to pause/interrupt and resume
figure out how to auto-create check array

## Configuring an Image

Go to `config.sh` and read the comments. Self explanatory.





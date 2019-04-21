#!/bin/bash

source scripts/color_codes.sh

echo "$(cat data/sla_violations)" > web/sla_violations.txt

injects=$(cat data/injects)
announcements=$(cat data/announcements)
scoring_status=$(cat data/scoring_status)
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
      <h3>Services</h3>${scoring_status}<br><a href=uptime.html>Services by uptime</a><hr>
      <h3>Injects</h3>${injects}<br><hr>
      <h3>Announcements</h3>${announcements}<br><hr>
      <h3>Links</h3><ul>
        <li><a href='patch'>Patch server</a></li>
        <li><a href='sla_violations.txt'>SLA violations</a></li>
      </ul><hr></body></html>"
echo "$html" > web/index.html

echo -e "${plus} Updated team portal webpage."


# Red vs Blue Team Scoring Engine (CyberPatriot and CCDC)

__EXTREMELY__ SIMPLE scoring/patch/aggregating server
Why is it written in bash? why not 
Requirements: bash, lol
Apache2
python3

## Section 1: Patch Server

Files in `./patch/` will be served with a basic Python HTTP server on port 8000/patch.


Injects: add to the file

## Configuring an Image

Go to CONFIG section in the script.

```bash
team1_pass="password"
team1_image_number=1 # Number of images
team1_image1="image1" # Image name
    team1_image1_ip="192.168.1.100" # Image IP
    team1_image1_checks=("ssh" "http") # Insert checks in this array
```

After you set these, add individual checks. Each one needs something different.

- `team#_image#_ssh=("port", ["password"])` Don't include password field if SSH pubkey auth is used.
    - ex) `team1_image1_ssh("22")`
- `team#_image#_http=("port", ["page"])` If the main site is on the baseurl, don't include page field
     - ex) `team1_image1_http("80")`


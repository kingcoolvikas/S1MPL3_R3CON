#!/bin/bash

sleep 1
cat <<"EOF"
 /===============================================================\
||   /$$                                       /$$               ||
||  | $$                                      | $$               ||
||  | $$$$$$$   /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$   /$$   /$$ ||
||  | $$__  $$ /$$__  $$| $$  | $$| $$__  $$|_  $$_/  | $$  | $$ ||
||  | $$  \ $$| $$  \ $$| $$  | $$| $$  \ $$  | $$    | $$  | $$ ||
||  | $$  | $$| $$  | $$| $$  | $$| $$  | $$  | $$ /$$| $$  | $$ ||
||  | $$$$$$$/|  $$$$$$/|  $$$$$$/| $$  | $$  |  $$$$/|  $$$$$$$ ||
||  |_______/  \______/  \______/ |__/  |__/   \___/   \____  $$ ||
||                                                     /$$  | $$ ||
||                                                    |  $$$$$$/ ||
||                                                     \______/  ||
 \===============================================================/
EOF
echo ""

mkdir -p ~/bounty.sh/recon/$1
cd ~/bounty.sh/recon/$1

##############################################################################################################################

#Variables
amass=~/.config/amass/config.ini
subfinder=~/.config/subfinder/provider-config.yaml
#resolver=~/bounty.sh/wordlists/resolvers.txt
#dns=~/bounty.sh/wordlists/dns.txt
#fuzz=~/bounty.sh/wordlists/fuzz.txt

#SubDomain Enumeration...
assetfinder --subs-only $1 | tee -a ~/bounty.sh/recon/$1/assetfinder.txt
amass enum -passive -d $1 -config $amass -o ~/bounty.sh/recon/$1/amass.txt
subfinder -silent -all -d $1 -pc $subfinder -o ~/bounty.sh/recon/$1/subfinder.txt
findomain -t $1 --quiet | tee -a ~/bounty.sh/recon/$1/findomain.txt
gau $1 | unfurl -u domains | tee -a ~/bounty.sh/recon/$1/gau.txt
waybackurls $1 | unfurl -u domains | tee -a ~/bounty.sh/recon/$1/waybackurls.txt
#ctfr -d $1 | tee -a ~/bounty.sh/recon/$1/ctfr.txt
puredns bruteforce /home/king/Tools/subdomains_n0kovo_big.txt $1 --resolvers /home/king/Tools/resolvers.txt | tee -a ~/bounty.sh/recon/$1/puredns.txt

#Sorting
cat ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt gau.txt waybackurls.txt puredns.txt | sort -u | tee -a ~/bounty.sh/recon/$1/all.txt
rm ~/bounty.sh/recon/$1/assetfinder.txt amass.txt subfinder.txt findomain.txt gau.txt waybackurls.txt
echo ""

#Resolving domains
#cat ~/bounty.sh/recon/$1/all.txt | puredns resolve --resolvers-trusted ~/bounty.sh/wordlists/resolvers.txt  | tee ~/bounty.sh/recon/$1/resolved.txt

#Checking for live domains
httpx -l ~/bounty.sh/recon/$1/all.txt -p 80,8080,443,8443,9000,8000 -rl 100 -timeout 30 -o ~/bounty.sh/recon/$1/alive.txt

#Taking Screenshot
#gowitness file -f ~/bounty.sh/recon/$1/alive.txt -P screeenshot

#Running Portscan
#naabu -l ~/bounty.sh/recon/$1/alive.txt -p - -exclude-ports 80,443,21,22,25 -o open-ports.txt

#Vulnerability Scanning - Nuclei...
#nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity info -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei_info.txt
#nuclei -l ~/bounty.sh/recon/$1/alive.txt -severity low,medium,high,critical -rl 100 -c 5 -o ~/bounty.sh/recon/$1/nuclei_all.txt
#echo ""

#Fuzzing started - ffuf...
#cd ~/bounty.sh/recon/$1/
#while read -r subdomain; do
#       ffuf -w ~/wordlists/onelistforall.txt -u "https://$subdomain/FUZZ" -mc 200 -o all-alivepath.txt
#done < alive_subdomains.txt

#Gathering URLs....
#cd ~/bounty.sh/recon/$1/
#cat alive.txt | waybackurls | uro | tee -a way.txt
#cat alive.txt | gauplus | uro | tee -a gaupl.txt
#cat alive.txt | gau | uro | tee -a gau.txt
#katana -list alive.txt -o katana.txt
#cat alive.txt | hakrawler | tee -a hakrawler.txt
#cat way.txt gaupl.txt gau.txt katana.txt hakrawler.txt | sort -u | tee -a waybackurls.txt
#rm way.txt gaupl.txt gau.txt katana.txt hakrawler.txt
#echo ""

#Gathering JS Files
#cd ~/bounty.sh/recon/$1/
#cat alive.txt | waybackurls | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js1.txt &&
#cat alive.txt | gau | grep -iE '\.js'|grep -iEv '(\.jsp|\.json)' >> js2.txt &&
#cat alive.txt | hakrwler | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' >> js3.txt &&
#katana -list alive.txt | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' >> js4.txt &&
#subjs -i alive.txt | tee -a subjs.txt &&
#cat js1.txt js2.txt js3.txt js4.txt subjs.txt | sort -u | tee -a js-files.txt
#rm js1.txt js2.txt js3.txt js4.txt subjs.txt
#echo ""

#Parameter fuzzing
#python3 ~/bounty.sh/tools/ParamSpider/paramspider.py -d $1
#echo ""

##################################################################################################################################

echo "Done"

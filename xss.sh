#XSS Automation

#!/bin/bash
# Create list with scope for your testing target for example list.txt
# Enter your program

program=$1

folderc(){
mkdir -p $program $program/alive
}
folderc

wayblist(){
for domain in `cat list.txt`
        do
        waybackurls $domain | sort -u | tee -a $program/$domain.wayback.txt
        done
}
wayblist

replace(){
cat $program/*.txt > $program/waybackdata.txt
cat waybackdata.txt | gf xss | tee -a xss1.txt | qsreplace FUZZ ›› xss2.txt
}
replace

simple(){
cat xss2.txt | kxss | tee kxss.txt
}
simple

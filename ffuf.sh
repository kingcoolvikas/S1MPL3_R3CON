ffuf -u $1/FUZZ -w ~/onelistforall.txt -fc 501,502,503 -r -H "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0"

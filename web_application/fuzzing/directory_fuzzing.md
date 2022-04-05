# Directory Fuzzing 

## FFuf

In order to install it, type ``` sudo apt install ffuf -y ``` or [download](https://github.com/ffuf/ffuf)

In order to perform the directory fuzzing, type: ```ffuf -w <WORDLIST> -u http://SERVER_IP:PORT/FUZZ ``` . Example:

```
fuf -w /usr/share/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u https://site.com/FUZZ

```
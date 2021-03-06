# Directory Fuzzing using FFuf

In order to install it, type ``` sudo apt install ffuf -y ``` or [download](https://github.com/ffuf/ffuf)

In order to perform the directory fuzzing, type: ```ffuf -w <WORDLIST> -u http://SERVER_IP:PORT/FUZZ ``` .
We use the directory-list* file and 'FUZZ' keyword to fuzz the directories in a web server Example:

```
fuf -w /usr/share/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u https://$target/FUZZ

```
 

## File extension fuzzing


In order to perform the extension fuzzing, type: ```ffuf -w <WORDLIST> -u http://SERVER_IP:PORT/route/file:FUZZ ``` 
.We use the web-extensions.txt file and 'FUZZ' keyword to fuzz the file extension in a web server.  Example:

```
ffuf -w /usr/share/SecLists/Discovery/Web-Content/web-extensions.txt:FUZZ -u $target/login/indexFUZZ

```
At most of sites, there exists the index file, so in the above example we're about to discover some index extension file.

## Recursive fuzzing

To carry out a recursive fuzzing for discover files and sub-folders recursively, type the following command:

```
ffuf -w /usr/share/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u $target/FUZZ  -recursion --recursion-depth 3 -e .php -r -fs 0,10242423424
```

## Sub-domains

In order to discover the target sub-domains, type the folowwing command :

```
ffuf -w /usr/share/SecLists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://FUZZ.$target
```

## GET parameter fuzzing

In order to discover wether GET parameter is accepted not not, type the folowwing command :

```
ffuf -w /usr/share/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u http://admin.academy.htb:$port/admin/admin.php?FUZZ=key -fs 0,0
```
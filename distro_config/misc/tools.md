# Useful tools

Here are some useful tools that needs to be installed, in order to ease the penetration test role:

* [vnstat](https://humdi.net/vnstat/)
* [XSStrike](https://github.com/s0md3v/XSStrike)
* [Nessus report](https://raw.githubusercontent.com/eelsivart/nessus-report-downloader/master/nessus6-report-downloader.rb)
* [Impacket](https://github.com/fortra/impacket)

# Useful commands

Detest your ISP

```
whois $(curl -s ipinfo.io/org | cut -d" " -f1) | awk -F: 'BEGIN{IGNORECASE=1}/(as-?name|org-?name):/{sub("^  *","",$2);print$2}'
```
Or
```
curl -s ipinfo.io/org
```

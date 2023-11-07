# PHP Filters

## Input Filters

PHP Filters are a type of PHP wrappers, where we can pass different types of input and have it filtered by the filter we specify. To use PHP wrapper streams, we can use the *php://* scheme in our string, and we can access the PHP filter wrapper with *php://filter/.*

The filter wrapper has several parameters, but the main ones we require for our attack are resource and read. The resource parameter is required for filter wrappers, and with it we can specify the stream we would like to apply the filter on (e.g. a local file), while the read parameter can apply different filters on the input resource, so we can use it to specify which filter we want to apply on our resource.

There are four different types of filters available for use, which are String Filters, Conversion Filters, Compression Filters, and Encryption Filters. You can read more about each filter on their respective link, but the filter that is useful for LFI attacks is the convert.base64-encode filter, under Conversion Filters.

## Fuzzing for PHP Files

The first step would be to fuzz for different available PHP pages with a tool like ffuf or gobuster, as covered in the Attacking Web Applications with Ffuf module:

```
 ffuf -w /opt/useful/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://<SERVER_IP>:<PORT>/FUZZ.php
```
Even after reading the sources of any identified files, we can scan them for other referenced PHP files, and then read those as well, until we are able to capture most of the web application's source or have an accurate image of what it does. It is also possible to start by reading index.php and scanning it for more references and so on, but fuzzing for PHP files may reveal some files that may not otherwise be found that way.

## Standard PHP Inclusion
In previous sections, if you tried to include any php files through LFI, you would have noticed that the included PHP file gets executed, and eventually gets rendered as a normal HTML page. For example, let's try to include the config.php page (.php extension appended by web application): *http://<SERVER_IP>:<PORT>/index.php?language=config*

As we can see, we get an empty result in place of our LFI string, since the config.php most likely only sets up the web app configuration and does not render any HTML output.


***Note:** The same applies to web application languages other than PHP, as long as the vulnerable function can execute files. Otherwise, we would directly get the source code, and would not need to use extra filters/functions to read the source code. Refer to the functions table in section 1 to see which functions have which privileges.*

## Source Code Disclosure

Once we have a list of potential PHP files we want to read, we can start disclosing their sources with the base64 PHP filter. Let's try to read the source code of config.php using the base64 filter, by specifying convert.base64-encode for the read parameter and config for the resource parameter, as follows:
```
php://filter/read=convert.base64-encode/resource=config 
http://<SERVER_IP>:<PORT>/index.php?language=php://filter/read=convert.base64-encode/resource=config
```
***Note:** We intentionally left the resource file at the end of our string, as the .php extension is automatically appended to the end of our input string, which would make the resource we specified be config.php.*

As we can see, unlike our attempt with regular LFI, using the base64 filter returned an encoded string instead of the empty result we saw earlier. We can now decode this string to get the content of the source code of *config.php*, as follows:

```
echo 'PD9waHAK...SNIP...KICB9Ciov' | base64 -d


if ($_SERVER['REQUEST_METHOD'] == 'GET' && realpath(__FILE__) == realpath($_SERVER['SCRIPT_FILENAME'])) {
  header('HTTP/1.0 403 Forbidden', TRUE, 403);
  die(header('location: /index.php'));
}

```

***Tip:** When copying the base64 encoded string, be sure to copy the entire string or it will not fully decode. You can view the page source to ensure you copy the entire string.*
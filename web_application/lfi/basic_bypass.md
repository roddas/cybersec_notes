# Basic Bypasses

In many cases, we may be facing a web application that applies various protections against file inclusion, so our normal LFI payloads would not work. Still, unless the web application is properly secured against malicious LFI user input, we may be able to bypass the protections in place and reach file inclusion.

## Non-Recursive Path Traversal Filters

One of the most basic filters against LFI is a search and replace filter, where it simply deletes substrings of (../) to avoid path traversals. For example:

```
$language = str_replace('../', '', $_GET['language']);
```

The above code is supposed to prevent path traversal, and hence renders LFI useless.
If we try the LFI payloads we tried in the previous section, we get the following:
``` 
http://<SERVER_IP>:<PORT>/index.php?language=../../../../etc/passwd
```

We see that all *../* substrings were removed, which resulted in a final path being *./languages/etc/passwd*.

 However, this filter is very insecure, as it is not recursively removing the *../* substring, as it runs a single time on the input string and does not apply the filter on the output string. For example, if we use *....//* as our payload, then the filter would remove *../* and the output string would be *../*, which means we may still perform path traversal. Let's try applying this logic to include */etc/passwd* again.

``` 
http://<SERVER_IP>:<PORT>/index.php?language=....//....//....//....//etc/passwd
```

As we can see, the inclusion was successful this time, and we're able to read */etc/passwd* successfully. The *....//* substring is not the only bypass we can use, as we may use *..././* or *....\/* and several other recursive LFI payloads. Furthermore, in some cases, escaping the forward slash character may also work to avoid path traversal filters (e.g. ....\/), or adding extra forward slashes (e.g. ....////)

## Encoding

Some web filters may prevent input filters that include certain LFI-related characters, like a dot *.* or a slash */* used for path traversals. However, some of these filters may be bypassed by URL encoding our input, such that it would no longer include these bad characters, but would still be decoded back to our path traversal string once it reaches the vulnerable function. Core PHP filters on versions 5.3.4 and earlier were specifically vulnerable to this bypass, but even on newer versions we may find custom filters that may be bypassed through URL encoding.

If the target web application did not allow *.* and */* in our input, we can URL encode *../* into *%2e%2e%2f*, which may bypass the filter. To do so, we can use any online URL encoder utility or use the Burp Suite Decoder tool.



Let's try to use this encoded LFI payload against our earlier vulnerable web application that filters *../* strings:

```
<SERVER_IP>:<PORT>/index.php?language=%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%65%74%63%2f%70%61%73%73%77%64
```

As we can see, we were also able to successfully bypass the filter and use path traversal to read */etc/passwd*. Furthermore, we may also use **Burp Decoder** to encode the encoded string once again to have a double encoded string, which may also bypass other types of filters.


## Approved Paths

Some web applications may also use *Regular Expressions* to ensure that the file being included is under a specific path. For example, the web application we have been dealing with may only accept paths that are under the *./languages* directory, as follows:

```
if(preg_match('/^\.\/languages\/.+$/', $_GET['language'])) {
    include($_GET['language']);
} else {
    echo 'Illegal path specified!';
}
```

To find the approved path, we can examine the requests sent by the existing forms, and see what path they use for the normal web functionality. Furthermore, we can fuzz web directories under the same path, and try different ones until we get a match. To bypass this, we may use path traversal and start our payload with the approved path, and then use *../* to go back to the root directory and read the file we specify, as follows:

```
<SERVER_IP>:<PORT>/index.php?language=./languages/../../../../etc/passwd
```

***Note**: All techniques mentioned so far should work with any LFI vulnerability, regardless of the back-end development language or framework.*

## Appended Extension






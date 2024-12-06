# Local File Inclusion (LFI)

## Introduction

Many modern back-end languages, such as *PHP, Javascript, or Java*, use HTTP parameters to specify what is shown on the web page, which allows for building dynamic web pages, reduces the script's overall size, and simplifies the code. In such cases, parameters are used to specify which resource is shown on the page. If such functionalities are not securely coded, an attacker may manipulate these parameters to display the content of any local file on the hosting server, leading to a Local File Inclusion (LFI) vulnerability.

## Local File Inclusion (LFI)

LFI vulnerabilities can lead to source code disclosure, sensitive data exposure, and even remote code execution under certain conditions. Leaking source code may allow attackers to test the code for other vulnerabilities, which may reveal previously unknown vulnerabilities. Furthermore, leaking sensitive data may enable attackers to enumerate the remote server for other weaknesses or even leak credentials and keys that may allow them to access the remote server directly. Under specific conditions, LFI may also allow attackers to execute code on the remote server, which may compromise the entire back-end server and any other servers connected to it.

## Examples of Vulnerable Code

### PHP
In *PHP*, we may use the *include()* function to load a local or a remote file as we load a page. If the path passed to the *include()* is taken from a user-controlled parameter, like a GET parameter, and the code does not explicitly filter and sanitize the user input, then the code becomes vulnerable to File Inclusion. The following code snippet shows an example of that:

```
if (isset($_GET['language'])) {
    include($_GET['language']);
}
```

We see that the language parameter is directly passed to the *include()* function. So, any path we pass in the language parameter will be loaded on the page, including any local files on the back-end server. This is not exclusive to the include() function, as there are many other PHP functions that would lead to the same vulnerability if we had control over the path passed into them. Such functions include *include_once(), require(), require_once(), file_get_contents(),* and several others as well.


### NodeJS
Just as the case with *PHP, NodeJS* web servers may also load content based on an HTTP parameters. The following is a basic example of how a GET parameter language is used to control what data is written to a page:

```
if(req.query.language) {
    fs.readFile(path.join(__dirname, req.query.language), function (err, data) {
        res.write(data);
    });
}
```

As we can see, whatever parameter passed from the URL gets used by the *readfile* function, which then writes the file content in the HTTP response. Another example is the *render()* function in the *Express.js* framework. The following example shows uses the language parameter to determine which directory it should pull the *about.html* page from:

```
app.get("/about/:language", function(req, res) {
    res.render(`/${req.params.language}/about.html`);
});
```
Unlike our earlier examples where GET parameters were specified after a (?) character in the URL, the above example takes the parameter from the URL path (e.g. /about/en or /about/es). As the parameter is directly used within the *render()* function to specify the rendered file, we can change the URL to show a different file instead.


### Java
The same concept applies to many other web servers. The following examples show how web applications for a *Java* web server may include local files based on the specified parameter, using the include function:

```
<c:import url= "<%= request.getParameter('language') %>"/>
```

### .NET
Finally, let's take an example of how File Inclusion vulnerabilities may occur in .NET web applications. The *Response.WriteFile* function works very similarly to all of our earlier examples, as it takes a file path for its input and writes its content to the response. The path may be retrieved from a GET parameter for dynamic content loading, as follows:

```
@if (!string.IsNullOrEmpty(HttpContext.Request.Query['language'])) {
    <% Response.WriteFile("<% HttpContext.Request.Query['language'] %>"); %> 
}
```
Furthermore, the *@Html.Partial()* function may also be used to render the specified file as part of the front-end template, similarly to what we saw earlier:

```
@Html.Partial(HttpContext.Request.Query['language'])
```

Finally, the *include* function may be used to render local files or remote URLs, and may also execute the specified files as well:

```
<!--#include file="<% HttpContext.Request.Query['language'] %>"-->
```

The most important thing to keep in mind is that some of the above functions only read the content of the specified files, while others also execute the specified files. Furthermore, some of them allow specifying remote URLs, while others only work with files local to the back-end server.

In all cases, File Inclusion vulnerabilities are critical and may eventually lead to compromising the entire back-end server. Even if we were only able to read the web application source code, it may still allow us to compromise the web application, as it may reveal other vulnerabilities as mentioned earlier, and the source code may also contain database keys, admin credentials, or other sensitive information.


## Filename Prefix

On some occasions, our input may be appended after a different string. For example, it may be used with a prefix to get the full filename, like the following example:

```
include("lang_" . $_GET['language']);
```

In this case, if we try to traverse the directory with *../../../etc/passwd*, the final string would be *lang_../../../etc/passwd*, which is invalid. We can prefix a / before our payload, and this should consider the prefix as a directory, and then we should bypass the filename and be able to traverse directories. 

***Note**: This may not always work, as in this example a directory named lang_/ may not exist, so our relative path may not be correct. Furthermore, any prefix appended to our input may break some file inclusion techniques we will discuss in upcoming sections, like using PHP wrappers and filters or RFI.*

## Appended Extensions

Another very common example is when an extension is appended to the language parameter, as follows:

```
include($_GET['language'] . ".php");
```

This is quite common, as in this case, we would not have to write the extension every time we need to change the language. This may also be safer as it may restrict us to only including PHP files. In this case, if we try to read */etc/passwd*, then the file included would be */etc/passwd.php*, which does not exist.


## Second-Order Attacks

As we can see, LFI attacks can come in different shapes. Another common, and a little bit more advanced, LFI attack is a **Second Order Attack**. This occurs because many web application functionalities may be insecurely pulling files from the back-end server based on user-controlled parameters.

For example, a web application may allow us to download our avatar through a URL like *(/profile/$username/avatar.png)*. If we craft a malicious LFI username *(e.g. ../../../etc/passwd)*, then it may be possible to change the file being pulled to another local file on the server and grab it instead of our avatar.

In this case, we would be poisoning a database entry with a malicious LFI payload in our username. Then, another web application functionality would utilize this poisoned entry to perform our attack *(i.e. download our avatar based on username value)* . This is why this attack is called a **Second-Order** attack.


# Cross-site scripting XSS

## Introduction

Cross-site scripting *(also known as XSS)* is a web security vulnerability that allows an attacker to compromise the interactions that users have with a vulnerable application.

## How does XSS work?

Cross-site scripting works by manipulating a vulnerable web site so that it returns malicious JavaScript to users. When the malicious code executes inside a victim's browser, the attacker can fully compromise their interaction with the application.

## XSS proof of concept - PoC

You can confirm most kinds of XSS vulnerability by injecting a payload that causes your own browser to execute some arbitrary JavaScript. It's long been common practice to use the *alert()* function for this purpose because it's short, harmless, and pretty hard to miss when it's successfully called.

## What are the types of XSS attacks?

There are three main types of XSS attacks. These are:
 * **Stored XSS (Persitent)**, where the malicious script comes from the website's database and then displayed upon retrieval (e.g., posts or comments).
 * **Reflected XSS (Non persitent)** occur when user input is displayed on the page after being processed by the backend server, but without being stored (e.g., search result or error message).
 * **DOM-based XSS (Non persitent)**, where the vulnerability exists in client-side code rather than server-side code.

### Stored XSS or Persistent XSS

The first and most critical type of XSS vulnerability is Stored XSS or Persistent XSS. If our injected XSS payload gets stored in the back-end database and retrieved upon visiting the page, this means that our XSS attack is persistent and may affect any user that visits the page.

This makes this type of XSS the most critical, as it affects a much wider audience since any user who visits the page would be a victim of this attack. Furthermore, Stored XSS may not be easily removable, and the payload may need removing from the back-end database.

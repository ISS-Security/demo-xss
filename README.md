# HTML Injection and Cross-Site Security (XSS and CSRF) Demonstration

This project demonstrates how to conduct and prevent XSS attacks

## Install

    git clone <...>
    cd demo_xss
    bundlle install

## Execute

    ruby app.rb

Now view at the site at `http://localhost:4567` or whichever port it is on.

## Play

Look at the running site and open the 'instructions' link to see what kind of text input you could enter to conduct a script injection attack.

Search within the code of this project (`*.rb` and `views/*.slim`) for 'XSS' -- you should find comments on how make modifications to prevent XSS attacks.

## Readings on XSS

- Overview of XSS Concepts
  - [How to Prevent XSS](http://www.lauradhamilton.com/how-to-prevent-xss)
  - [An Overview of HTTP Security Headers](https://www.dionach.com/blog/an-overview-of-http-security-headers)
- XSS Security
  - Content Security Policy (CSP)
    - [An Introduction to Content Security Policy](http://www.html5rocks.com/en/tutorials/security/content-security-policy/)
    - [Content Security Policy 1.0](http://caniuse.com/#feat=contentsecuritypolicy)
  - Subresource Integrity and CORS
    - [Subresource Integrity: Securing CDN loaded assets](https://scotthelme.co.uk/subresource-integrity/)
- Cookie Security
  - [Protecting Your Cookies: *HttpOnly*](https://blog.codinghorror.com/protecting-your-cookies-httponly/)
  - [Preventing CSRF with the *same-site• cookie attribute](http://www.sjoerdlangkemper.nl/2016/04/14/preventing-csrf-with-samesite-cookie-attribute/)

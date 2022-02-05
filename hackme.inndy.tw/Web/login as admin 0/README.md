The source given:

```
<?php
require('config.php');

// table schema
// user -> id, user, password, is_admin

if($_GET['show_source'] === '1') {
    highlight_file(__FILE__);
    exit;
}

function safe_filter($str)
{
    $strl = strtolower($str);
    if (strstr($strl, 'or 1=1') || strstr($strl, 'drop') ||
        strstr($strl, 'update') || strstr($strl, 'delete')
    ) {
        return '';
    }
    return str_replace("'", "\\'", $str);
}

$_POST = array_map(safe_filter, $_POST);

$user = null;

// connect to database

if(!empty($_POST['name']) && !empty($_POST['password'])) {
    $connection_string = sprintf('mysql:host=%s;dbname=%s;charset=utf8mb4', DB_HOST, DB_NAME);
    $db = new PDO($connection_string, DB_USER, DB_PASS);
    $sql = sprintf("SELECT * FROM `user` WHERE `user` = '%s' AND `password` = '%s'",
        $_POST['name'],
        $_POST['password']
    );
    try {
        $query = $db->query($sql);
        if($query) {
            $user = $query->fetchObject();
        } else {
            $user = false;
        }
    } catch(Exception $e) {
        $user = false;
    }
}
?>
```

And
```
<?php if($user->is_admin) printf("<code>%s</code>, %s", htmlentities($flag1), $where_is_flag2); ?>
``` 

The `$user` comes from `$query->fetchObject()`, which will fetch the next row and returns it as an object.(check the table schema given)

> [fetchObject](https://www.php.net/manual/es/pdostatement.fetchobject.php)

So, What we need to do is that make the member `is_admin` of object returned by SQL true.

How to do that ?

1. Login as admin with true password or inject it to break the SQL statement.
2. Use `Union select` to combine the result with our custom data that `is_admin` is true.

BUT

Each parameter in `$_POST` will be run through the `safe_filter ` because `$_POST = array_map(safe_filter, $_POST);`.

As what function `safe_filter` do.It will

1. Replace `or 1=1`, `drop` ,`delete`,`update` with space.
2. Replace `'` with `\'`.

So, if the input goes `' or 1 #`. It will be converted to `\' or 1 #` .

Wait, where is the other `\`? It escape the next `\`, which takes away the special meaning of the latter, and send it to `$sql`. Some may ask that what is the difference betwwen single backslash and double? Actually, In this case, they are same.

SO?

It looks like a perfect SQLinjection protection right?

Let's take a look into a popular SQLinjection protection function `mysql_real_escape_string` in PHP.
> [mysql_real_escape_string](https://www.php.net/manual/en/function.mysql-real-escape-string.php)

As the description says, such characters like `\x00, \n, \r, \, ', " and \x1a` will be prepended a backslash to escape it.

Back to our task, It only prepends backslash to `'`, but the other characters above.

SO?

Take this into consideration. Our goal is to escpae the original SQL query to add other statement.

Only a `'` will not work anymore in this case, what if we change the input to `\'`?

The result after being filtered will be like `\\'`, and sent to database as a query statement.

The first backslash will escape the next backslash, which makes the latter become meaningless and unable to escape our single quote `'`.

That is it!

Payload be like:

`admin\' or 1 #`

But it doesn't give us flag.Why?

The SQL query statement be like `SELECT * FROM user WHERE `user` = 'admin\\'' or 1 #`

Remeber that the source code only call `fetObject` for once, which will return one result .

And for our SQL query, it will return the whole content of table `user`, but only the first one fetched by our code.

So?

1. Use `LIMIT`, and then we can constrain the the rows that returned by SELECT statement.

`\' or 1 LIMIT 1,1 #`

>[MySQL - Select Statement](https://dev.mysql.com/doc/refman/8.0/en/select.html)

2. Use `UNION SELECT` to combine our custom data with the original column.

`\' UNION SELECT 1,2,3,true #`

>[MySQL - Union Clause](https://dev.mysql.com/doc/refman/8.0/en/union.html)
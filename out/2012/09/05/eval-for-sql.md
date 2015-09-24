+++
title = "eval for SQL"
date = "2012-09-05"
categories = ["Programming"]
tags = ["PostgreSQL", "SQL"]
+++


postgresならできます

<!--more-->


``` sourceCode
CREATE FUNCTION eval(sql Text) RETURNS SETOF Record AS $$
BEGIN
RETURN QUERY EXECUTE sql;
RETURN;
END;
$$ LANGUAGE plpgsql;
```

使用例

``` sourceCode
SELECT 2012 2013 2014 _static _templates blog conf.py conf.pyc convert.sh index.html master.rst out FROM eval('SELECT 2012 2013 2014 _static _templates blog conf.py conf.pyc convert.sh index.html master.rst out FROM( VALUES (1,''a''), (3,''b'') ) AS t') AS (i Int, c Text);
DROP FUNCTION
CREATE FUNCTION
i | c
---+---
1 | a
3 | b
(2 rows)
```

SQLをテーブルに入れているみなさんもこれで安心ですね

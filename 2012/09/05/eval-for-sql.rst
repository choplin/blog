############
eval for SQL
############



.. author:: default
.. categories:: Programming
.. tags:: PostgreSQL, SQL
.. comments::

<blockquote class="twitter-tweet" lang="ja"><p>evalあるSQL処理系ないのかな</p>&mdash; トデス子さん (@todesking) <a href="https://twitter.com/todesking/status/243294372643344384" data-datetime="2012-09-05T10:27:53+00:00">9月 5, 2012</a></blockquote>
<script src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

postgresならできます

.. code-block:: postgres

    CREATE FUNCTION eval(sql Text) RETURNS SETOF Record AS $$
        BEGIN
            RETURN QUERY EXECUTE sql;
            RETURN;
        END;
    $$ LANGUAGE plpgsql;

使用例

.. code-block:: postgres

    SELECT * FROM eval('SELECT * FROM( VALUES (1,''a''), (3,''b'') ) AS t') AS (i Int, c Text);
    DROP FUNCTION
    CREATE FUNCTION
     i | c
    ---+---
     1 | a
     3 | b
    (2 rows)

SQLをテーブルに入れているみなさんもこれで安心ですね

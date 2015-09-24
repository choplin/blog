+++
title = "PostgreSQLでテーブル名カラム名を取得する方法"
date = "2013-11-07"
categories = ["Programming"]
tags = ["PostgreSQL"]
+++

Motivation
----------

[PostgreSQLのテーブルのカラム情報などを取得する | ExiZ.org](http://exiz.org/database/postgres/2013110716431/) を読んで気になったのでコメントしておきます

結論
----

psqlで\d使おう。

### 元エントリのクエリ

基本的には問題ないのですが

``` sourceCode
SELECT
relname AS table_name
FROM
pg_stat_user_tables
```

pg_stat* というテーブルは標準統計情報ビューと呼ばれます。ざっくりと説明すると、PostgreSQLは自身がどう使われているかについての情報を収集する機能があり、統計情報ビューを通してその情報を見ることができます。

このクエリの pg_stat_user_tables というビューではユーザーが定義したテーブルへのアクセスの状況を見ることができます。例えば、テーブルの大体の行数を調べたい時には、 select count(*) で計算しなおすのではなくて、このビューの n_live_tup を見ると分かります。

[統計情報コレクタ](http://www.postgresql.jp/document/current/html/monitoring-stats.html)

``` sourceCode
SELECT
2012 2013 2014 _static _templates blog conf.py conf.pyc convert.sh index.html master.rst out
FROM
information_schema.columns
WHERE
ORDER BY
ordinal_position;
```

information_schema とはデータベース内の様々メタデータを取得するために標準SQLで定められているビューの集合です。PostgreSQLでは直接メタデータを格納しているテーブルへのビューとして定義されています。

SQLの移植性を高めるという点ではinformation_schemaを用いる方が正解かも知れませんが、直接PostgreSQLでのメタデータのテーブルへ問い合わせる方が、少し"らしい"かも。[1]

[情報スキーマ](http://www.postgresql.jp/document/current/html/information-schema.html)

### システムカタログ

システムカタログとはPostgreSQL内のメタデータを管理するテーブルです。 CREATE TABLE や ALTER INDEX などのDDLを実行すると、このテーブルの値が書き換わります。

DB内部での処理も実際にこのテーブルの値を通して各種のメタデータへアクセスするようになっています。 [2] 即ち、内部での処理に利用する値がテーブルとして公開されており、ユーザーからSQLを通して取得できるようになっている、というわけです。 DBで管理している種々のメタデータがそのままユーザーに公開されているというのはPostgreSQLの一つの特徴といえるかもしれません。

管理する対象に応じて色々なテーブルがあるので、こちらを参照して下さい。

[システムカタログ](http://www.postgresql.jp/document/current/html/catalogs.html)

これらのシステムカタログを経由してテーブルや列の一覧を取得することができます。

### テーブルの一覧を取得

pg_class を参照します。

``` sourceCode
SELECT
2012 2013 2014 _static _templates blog conf.py conf.pyc convert.sh index.html master.rst out
FROM
pg_class
```

そのままだとインデックスやシステムテーブルまで入ってきてしまうので、 relnamespace でスキーマを指定したり、 relkind で通常テーブルだけを指定したりなどで絞りこむといいです。

[pg_class](http://www.postgresql.jp/document/current/html/catalog-pg-class.html)

### 列の一覧を取得

pg_attribute を参照します。

``` sourceCode
SELECT
2012 2013 2014 _static _templates blog conf.py conf.pyc convert.sh index.html master.rst out
FROM
pg_attribute
WHERE
```

attrelid という列はその列がどのテーブルに属しているかを持っています。型はOIDというPostgreSQL内部で行を一意に指定するための型です。 [3] OID自体は数値でユーザーが指定しにくいため、pg_classなど幾つかのテーブルの行については、分かりやすいtextから直接OIDへキャストできる方法が提供されています。

こちらもそのままだとシステム列や既に削除された列が含まれてしまいます。 attnum &gt; 0 でシステム列を除いたり、 NOT attisdropped で削除された列を除いたりすることが必要でしょう。

[pg_attribute](http://www.postgresql.jp/document/current/html/catalog-pg-attribute.html)

### psql

上記の方法はSQLを通してテーブルや列の一覧を取得する方法です。取得したテーブル名や列名を利用して何か処理するといったメタなSQLを書く必要があれば、こうした方法を取る必要がありますが、実際には一覧を見れれば十分なケースが殆どでしょう。

クライアントとしてpsqlを利用していれば簡単に確認することが可能です。通常はこちらを利用するべきでしょう。

\d
テーブル一覧

\d table_name
指定したテーブルの列一覧

[1] information_schema経由だとpostgres特有の情報を取得できないという事情もあります

[2] 本当はSysCache経由

[3] 実際には周回するので一意性は保証されていないのですが

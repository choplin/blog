###################
pg-jsonpathを書いた
###################



.. author:: default
.. categories:: PostgreSQL
.. tags:: none
.. comments::

********
はじめに
********

この記事は `PostgreSQL Advent Calendar 2012 <http://atnd.org/events/34176>`_ の21日目です。

************
JSON型の機能
************

PostgreSQLには9.2からJSON型が導入されました。JSON型が提供するのは主に次の2つです。

* JSONとしてのバリデーション
    * `JSONデータ型 <http://www.postgresql.jp/document/9.2/html/datatype-json.html>`_
* ROW型 配列型からのjson文字列の構築
    * `JSON関数 <http://www.postgresql.jp/document/9.2/html/functions-json.html>`_

****************
非構造化データ型
****************

ところでPostgreSQLには以前から非構造化データ型としてXML型があります。

XMLにはよく知られている通りXPathという内部の要素を指定する構文が標準化されており、libxmlなどのデファクトなライブラリを通して提供されています。

PostgreSQLでもlibxmlを利用したXPathでのアクセスが提供されています。

* `PostgreSQLでXMLを処理してみよう！ — Let's Postgres <http://lets.postgresql.jp/documents/tutorial/xml/1/>`_
* `XML型 <http://www.postgresql.jp/document/9.2/html/datatype-xml.html>`_
* `XML関数 <http://www.postgresql.jp/document/9.2/html/functions-xml.html>`_

新たに導入されたJSON型にも同様に内部の値にアクセスを求める声はあるようで、wiki上で議論があります。（ `JSON API Brainstorm - PostgreSQL wiki <http://wiki.postgresql.org/wiki/JSON_API_Brainstorm>`_ ）

ただ、コアでは提供されていないため、俺々ライブラリが色々作られています。（"postgresql json query"あたりでググると色々でてきます）

乱立した背景にはJSONにはXMLにおけるXPathのような標準化されたアクセス方法がないことがあります。

****************
そしてJSONPathへ
****************

XPathのように標準化されたわけではないですが、JSONにも仕様を定められたアクセス方法が存在します。それがJSONPathです。

`JSONPath - XPath for JSON <http://goessner.net/articles/JsonPath/>`_

デファクトと言えるほどには浸透していませんが、

* 仕様が文書として定められている
* 公式で実装が提供されている

という点で俺々で定義したライブラリよりは遥かにましと思われるので、PostgreSQLで動くようにしました。

JSONPathはjavascriptのライブラリが公式で提供されているのでplv8の上で動かしています。

******
使い方
******

ソースコード
============

`choplin/pg-jsonpath · GitHub <https://github.com/choplin/pg-jsonpath>`_

インストール
============

`plv8 <http://code.google.com/p/plv8js/wiki/PLV8>`_ が必要ですので先にインストールしておいて下さい。

EXTENSIONには対応していますが、pgxnには入れていないのでダウンロードしてmakeして下さい。

.. code-block:: sh

    git clone git://github.com/choplin/pg-jsonpath.git
    cd pg-jsonpath
    make && make install
    psql -e "CREATE EXTENSION jsonpath";

呼び出し
========

型は以下の通りです。

.. code-block:: none

    jsonPath(obj json, expr text) RETURNS json[]

exprはJSONPathの式になるので、公式ドキュメントを参照して下さい。

.. code-block:: postgres

    SELECT jsonPath('{"x": {"a":1, "b":2}}'::json, '$.x.[a,b]');
     jsonpath 
    ----------
     {1,2}
    (1 row)

queryとかindexとかjoin
======================

関数を通して内部の値にアクセスすることができるので、後はPostgreSQLの既存の機能と組み合わせれば大体できます。

.. code-block:: postgres

    CREATE TABLE tweets (
        id int,
        val json
    );
    
    INSERT INTO tweets VALUES
        (1, '{"user": "a", "content": "hi"}'),
        (2, '{"user": "a", "content": "ho"}'),
        (3, '{"user": "b", "content": "he"}'),
        (4, '{"user": "c", "content": "ha"}'),
        (5, '{"user": "c", "content": "hu"}'),
        (6, '{"user": "c", "content": "hihi"}');

SELECT
------

.. code-block:: postgres

    SELECT id, (jsonPath(val, '$.user'))[1] FROM tweets;
     id | jsonpath 
    ----+----------
      1 | "a"
      2 | "a"
      3 | "b"
      4 | "c"
      5 | "c"
      6 | "c"
    (6 rows)

WHERE
-----

.. code-block:: postgres

    SELECT * FROM tweets WHERE (jsonPath(val, '$.user'))[1]::text = '"a"'
     id |              val               
    ----+--------------------------------
      1 | {"user": "a", "content": "hi"}
      2 | {"user": "a", "content": "ho"}
    (2 rows)

Index
-----

.. code-block:: postgres

    CREATE INDEX idx_tweets_user ON tweets ( ((jsonPath(val, '$.user'))[1]::text) );
    SET enable_seqscan TO off;
    
    EXPLAIN SELECT * FROM tweets WHERE (jsonPath(val, '$.user'))[1]::text = '"a"'
                                      QUERY PLAN                                   
    -------------------------------------------------------------------------------
     Index Scan using idx_tweets_user on tweets  (cost=0.26..8.52 rows=1 width=36)
       Index Cond: (((jsonpath(val, '$.user'::text))[1])::text = '"a"'::text)
    (2 rows)

Join
====

.. code-block:: postgres

    CREATE TABLE users (
        name text,
        sex text
    );
    INSERT INTO users VALUES
        ('"a"', 'male'),
        ('"b"', 'female'),
        ('"c"', 'male');
    
    SET enable_nestloop TO off;
    
    EXPLAIN SELECT * FROM tweets t LEFT JOIN users u ON (jsonPath(t.val, '$.user'))[1]::text == u.name;
                                            QUERY PLAN                                        
    ------------------------------------------------------------------------------------------
     Hash Left Join  (cost=10000000029.35..10000000108.40 rows=26 width=100)
       Hash Cond: (((jsonpath(t.val, '$.user'::text))[1])::text = u.name)
       ->  Index Scan using idx_tweets_user on tweets t  (cost=0.00..12.34 rows=6 width=36)
       ->  Hash  (cost=10000000018.60..10000000018.60 rows=860 width=64)
             ->  Seq Scan on users u  (cost=10000000000.00..10000000018.60 rows=860 width=64)
    (5 rows)

****
TODO
****

文字列だけの値の場合、JSONとしてvalidであるためには "some string" のようにダブルクォーテーションで囲まれている必要があります。

jsonPathはjson[]を返すため、結果が文字列だけの場合でもjsonとしてvalidである必要があるので "result" のようになってしまいます。

その結果、上記の例のように、textにcastした後にも "" が複数回出現してめんどくさいことになります。

いい感じに収める方法があれば教えてください。

そもそもコアで対応されれば拡張は必要なくなるんですが今どんな状況なんでしょうか？

******
まとめ
******

pg-jsonpathを使えばJSON型の内部の値にアクセスできるようになります。

queryもindexもjoinも使えるので、スキーマレスという理由だけでドキュメント指向DBを検討している方はPostgreSQLも選択肢に入れてみてもいいかもしれません。

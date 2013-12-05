#####################################
SQL感覚でHiveQLを書くと痛い目にあう例
#####################################



.. author:: default
.. categories:: Programming
.. tags:: Hadoop,Hive
.. comments::

.. highlight:: sql

`Hadoop Advent Calendar 2013 <http://qiita.com/advent-calendar/2013/hadoop>`_ 4日目の記事です

*****
tl;dr
*****

* explainとjob historyを読め
* 1 reducerは悪
* data skewは悪

.. more::

******
前書き
******

みんな大好きSQLでHadoop上での処理を実行できるHiveにはみなさん普段からお世話になっていることでしょう。ちょっと調べ物でググる度に目に入る愛らいしいマスコットが、荒んだ心に清涼な風をはこんでくれます。

ですがHiveのクエリ言語はSQLではなくHiveQLですし、実行エンジンもRDBのそれとは全く異なるMapReduceです。SQLのつもりでHiveQLを書いていると地雷を踏んでしまうことがまれによくあります。本エントリでは陥りがちなHiveQLの落とし穴を2つ紹介します。

***
例1
***

::

    SELECT count(DISTINCT user_id) FROM access_log

SQLに慣れた方であれば、集約関数の中に `DISTINCT` や `ORDER BY` を入れて用いることは多いと思います。Hiveでは全ての集約関数で利用できるわけではないのですが、この例のように `count` 内での `DISTINCT` は利用することができます。

例のHiveQLではアクセスログからユニークユーザー数を計算しています。一つのクエリで完結していて美しいですね。一体どこが問題なのでしょうか？

データによるところが大きいですが、以下のようにクエリを書くと速くなる場合があります。

::

    SELECT
        count(*)
    FROM (
        SELECT
            DISTINCT
            user_id
        FROM
            access_log
    ) t


せっかく `count(DISTINCT )` で綺麗に一つにまとめられていたところをわざわざサブクエリに分割しています。なぜこちらの方が速くなるのでしょうか？

一つ目のクエリでEXPLAINを実行すると以下の様なプランになります。

ここで重要な事は、全体として一つのMapReduceになっている、ということです。一つのMapReduceで重複を除きつつカウントを行うなら、Reducerは一つで処理を実行する必要があります。そのためReducerで分散処理ができず、遅くなってしまうことがある、というわけです。

.. code-block:: none

    STAGE DEPENDENCIES:
      Stage-1 is a root stage
      Stage-0 is a root stage

    STAGE PLANS:
      Stage: Stage-1
        Map Reduce
          Alias -> Map Operator Tree:
            access_log
              TableScan
                alias: access_log
                Select Operator
                  expressions:
                        expr: user_id
                        type: string
                  outputColumnNames: user_id
                  Group By Operator
                    aggregations:
                          expr: count(DISTINCT user_id)
                    bucketGroup: false
                    keys:
                          expr: user_id
                          type: string
                    mode: hash
                    outputColumnNames: _col0, _col1
                    Reduce Output Operator
                      key expressions:
                            expr: _col0
                            type: string
                      sort order: +
                      tag: -1
                      value expressions:
                            expr: _col1
                            type: bigint
          Reduce Operator Tree:
            Group By Operator
              aggregations:
                    expr: count(DISTINCT KEY._col0:0._col0)
              bucketGroup: false
              mode: mergepartial
                        outputColumnNames: _col0
          Select Operator
            expressions:
                  expr: _col0
                  type: bigint
            outputColumnNames: _col0
            File Output Operator
              compressed: true
              GlobalTableId: 0
              table:
                  input format: org.apache.hadoop.mapred.TextInputFormat
                  output format: org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat

  Stage: Stage-0
    Fetch Operator
      limit: -1

一方、二つ目のクエリは、サブクエリを用いているためMapReduceの数は増えていますが、user_idをpartition keyとしてデータが分割されるため、Reducerでも効率よく分散処理を行うことができます。

.. code-block:: none

    STAGE DEPENDENCIES:
      Stage-1 is a root stage
      Stage-2 depends on stages: Stage-1
      Stage-0 is a root stage

    STAGE PLANS:
      Stage: Stage-1
        Map Reduce
          Alias -> Map Operator Tree:
            t:access_log
              TableScan
                alias: access_log
                Select Operator
                  expressions:
                        expr: user_id
                        type: string
                  outputColumnNames: user_id
                  Group By Operator
                    bucketGroup: false
                    keys:
                          expr: user_id
                          type: string
                    mode: hash
                    outputColumnNames: _col0
                    Reduce Output Operator
                      key expressions:
                            expr: _col0
                            type: string
                      sort order: +
                      Map-reduce partition columns:
                            expr: _col0
                            type: string
                      tag: -1
          Reduce Operator Tree:
            Group By Operator
              bucketGroup: false
              keys:
                    expr: KEY._col0
                    type: string
              mode: mergepartial
              outputColumnNames: _col0
              Select Operator
                  Select Operator
                    Group By Operator
                      aggregations:
                            expr: count()
                      bucketGroup: false
                      mode: hash
                      outputColumnNames: _col0
                      File Output Operator
                        compressed: true
                        GlobalTableId: 0
                        table:
                            input format: org.apache.hadoop.mapred.SequenceFileInputFormat
                            output format: org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat

    Stage: Stage-2
      Map Reduce
        Alias -> Map Operator Tree:
          hdfs://cdh4cluster/tmp/hive-okuno/hive_2013-12-04_13-33-10_514_1739731017764214960/-mr-10002
              Reduce Output Operator
                sort order:
                tag: -1
                value expressions:
                      expr: _col0
                      type: bigint
        Reduce Operator Tree:
          Group By Operator
            aggregations:
                  expr: count(VALUE._col0)
            bucketGroup: false
            mode: mergepartial
            outputColumnNames: _col0
            Select Operator
              expressions:
                    expr: _col0
                    type: bigint
              outputColumnNames: _col0
              File Output Operator
                compressed: true
                GlobalTableId: 0
                table:
                    input format: org.apache.hadoop.mapred.TextInputFormat
                    output format: org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat

    Stage: Stage-0
      Fetch Operator
        limit: -1

この二つの例のように、効率よくReducerを利用できているかどうか、というのは正直なところEXPLAINを見ているだけでは分かりません（熟練すれば分かるかもしれませんが）。そういう場合でも、実際にクエリを実行してみればReducerで詰まっている様子が一目で分かると思います。

***
例2
***

例2のクエリはこちら。

::

    SELECT
        sales.product_id,
        sum(product.price * sales.num)
    FROM
        sales
    INNER JOIN
        product ON sales.product_id = product.product_id
    GROUP BY
        sales.product_id

販売履歴に商品マスタをJOINして、商品毎の売上をだしている、と想定して下さい。

このクエリは以下のようにすると速くなる可能性があります。（もちろんデータによります）

::

    SELECT
        sales.product_id,
        product.price * total_num
    FROM (
        SELECT
            product_id,
            sum(num) AS total_num
        FROM
            sales
        GROUP BY
            product_id
    ) sales
    INNER JOIN
        product ON sales.product_id = product.product_id

このクエリもSQLに慣れた人なら避けて最初の例のように書くのではないでしょうか。

後者の例が速くなるポイントはデータの偏り(data skew)です。

一つ目のクエリでは、salesおよびproductのデータがproduct_idでpartitionされてReducerに配られます。その時、sales内に飛び抜けて売れた商品があると、あるReducerにだけデータが大量に集まってきてしまいます。そうした大量のデータに対するJOINは非常に遅い処理になってしまいます。その結果、そのReducerだけ処理時間が長くなってしまい、結局Job全体としても遅くなります。

一方、二つ目のクエリではMapReduceの数は増えてしまいますが、一段目のMapReduceではMap側集約を利用でき効率よく集約を行うことができます。二段目のMapReduceでは一段目でsalesがproduct_idで集約されて各product_idについて一行しか存在しないため、productとのJOINも非常に軽い処理で済むようになっています。

但し、product側が十分に小さくmap-site joinが利用できる場合は話が全く別です。その場合は、まず間違いなく一つ目のクエリの方が速くなるでしょう。

******
まとめ
******

Hiveは大変便利なのですが、上記の例のようにデータの量や偏りによって効率のいいクエリが全く異なるケースがあって厄介です（RDBでも同じですが）。クエリを選択する際にはSQLの常識は通じないことが多いので、Hiveを利用する際にはその事を意識しておくべきでしょう。めんどうでもEXPLAINでプランを見つつ、実際に実行してみて効率の悪いMapReduceになっていないか常にチェックしていくしかないと思います。

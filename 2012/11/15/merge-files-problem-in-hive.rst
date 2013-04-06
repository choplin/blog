#####################################################
hive.mergeにおけるSTOREと圧縮の問題とワークアラウンド
#####################################################



.. author:: default
.. categories:: Programming
.. tags:: Hadoop, Hive
.. comments::

****
問題
****

以下のブログでSTOREをTextFileにしてで圧縮を有効にしていると、hive.merge.(mapfiles|mapredfiles)が無視される問題が報告されています。

`Hiveのファイル圧縮とSTOREの種類とマージの関係 <http://dayafterneet.blogspot.jp/2012/07/hivestore.html>`_

Hiveは圧縮されたTextFileをインプットにした場合は、複数ファイルのCombineを行わないようなので、圧縮された細かいファイルは `small files problem <http://blog.cloudera.com/blog/2009/02/the-small-files-problem/>`_ によるパフォーマンスの悪化に繋がります。

また、RCFileでもマージはされるようです。が、実運用で用いているデータで試すとマージされないケースがあったので、下記のワークアラウンドを入れておくのが無難だと思います。

********
対応方法
********

ダメな形式の複数のMapper(Reducer)からファイルが出力されると、マージされずにそのまま残ります。

現状のワークアラウンドとしては

1. Reducerを起動させ
2. まとめたいファイルが1Reducerから出力されるようにする

とする方法が一番手っ取り早いかと思います。具体的には

* **パーティションキーでDISTRIBUTE BY、CLUSTER BYを行う**

とすると上記の条件を満たすことができます。(但し処理が増えるのでもちろん処理時間は延びますが)

パーティショニングされていない場合でも上記の条件を満たせばいいので、適当に考えてください。ORDER BYや全列でのGROUP BYとかでいけるのではと思います。(できれば何かしらパーティショニングすることをおすすめしますが）

********
確認方法
********

生ログをLOAD DATAして、パーティショニングされたテーブルにINSERT - SELECT するというユースケースを想定しています。

環境
====

* MacBook Pro
* CDH4.1.1
* Pseudo-Distributed
* \# of DataNode/TaskTracker: 1

DDL
===

.. code-block:: postgres

    -- 生ログをLOADするテーブル
    CREATE TABLE test_row (
      partition_id int,
      val string
    )
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
    STORED AS TextFile
    ;
    
    CREATE TABLE test_out (
      val string
    )
    PARTITIONED BY (partition_id int)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
    STORED AS TextFile
    ;

サンプルデータ。
================

パーティショニング処理で複数のMapを起動するためにそれぞれgzipで圧縮しておきます。
テキストファイルのままだとCombineされて1つのMapで処理されてしまいます。

.. code-block:: sh

    $ gzcat sample1.tsv.gz
    1   a
    2   a
    3   a

.. code-block:: sh

    $ gzcat sample2.tsv.gz
    1   b
    2   b
    3   b

.. code-block:: sh

    $ gzcat sample3.tsv.gz
    1   c
    2   c
    3   c

投入
====

.. code-block:: postgres

    LOAD DATA LOCAL INPATH 'sample1.tsv.gz'
    INTO TABLE test_row
    ;
    
    LOAD DATA LOCAL INPATH 'sample2.tsv.gz'
    INTO TABLE test_row
    ;
    
    LOAD DATA LOCAL INPATH 'sample3.tsv.gz'
    INTO TABLE test_row
    ;

.. code-block:: none

    hive> select * from test_row;
    OK
    1       a
    2       a
    3       a
    1       b
    2       b
    3       b
    1       c
    2       c
    3       c

.. code-block:: none

    $ hadoop fs -ls /user/hive/warehouse/test_row
    Found 3 items
    -rw-r--r--   3 hadoop supergroup         29 2012-11-02 21:09 /user/hive/warehouse/test_row/sample1.tsv.gz
    -rw-r--r--   3 hadoop supergroup         29 2012-11-02 21:09 /user/hive/warehouse/test_row/sample2.tsv.gz
    -rw-r--r--   3 hadoop supergroup         29 2012-11-02 21:09 /user/hive/warehouse/test_row/sample3.tsv.gz

オッケーです。

試しにクエリを投げると確かにMapperが複数起動していることが確認できます。

.. code-block:: none

    hive> SELECT count(*) FROM test_row;
    Total MapReduce jobs = 1
    Launching Job 1 out of 1
    Number of reduce tasks determined at compile time: 1
    In order to change the average load for a reducer (in bytes):
      set hive.exec.reducers.bytes.per.reducer=<number>
    In order to limit the maximum number of reducers:
      set hive.exec.reducers.max=<number>
    In order to set a constant number of reducers:
      set mapred.reduce.tasks=<number>
    Starting Job = job_201211021944_0008, Tracking URL = http://localhost:50030/jobdetails.jsp?jobid=job_201211021944_0008
    Kill Command = /home/hadoop/local/hadoop-mr1//bin/hadoop job  -Dmapred.job.tracker=localhost:9001 -kill job_201211021944_0008
    Hadoop job information for Stage-1: number of mappers: 3; number of reducers: 1
    2012-11-02 21:43:13,710 Stage-1 map = 0%,  reduce = 0%
    2012-11-02 21:43:15,720 Stage-1 map = 67%,  reduce = 0%
    2012-11-02 21:43:18,743 Stage-1 map = 100%,  reduce = 0%
    2012-11-02 21:43:19,751 Stage-1 map = 100%,  reduce = 100%
    Ended Job = job_201211021944_0008
    MapReduce Jobs Launched: 
    Job 0: Map: 3  Reduce: 1   HDFS Read: 0 HDFS Write: 0 SUCCESS
    Total MapReduce CPU Time Spent: 0 msec
    OK
    9
    Time taken: 10.392 seconds

オプション
==========

mergeとdynamic partitioningの設定をしておきます

.. code-block:: none

    set hive.merge.mapfiles = true;
    set hive.merge.mapredfiles = true;
    set hive.exec.dynamic.partition = true;
    set hive.exec.dynamic.partition.mode = nonstrict;

INSERT
======

TextFile
--------

そのままINSERTするとmergeされますが

.. code-block:: postgres

    INSERT OVERWRITE TABLE test_out
    PARTITION (partition_id)
    SELECT val, partition_id FROM test_row
    DISTRIBUTE BY partition_id
    ;

.. code-block:: none

    $ hadoop fs -ls /user/hive/warehouse/test_out/*
    Found 1 items
    -rw-r--r--   3 hadoop supergroup          6 2012-11-02 21:57 /user/hive/warehouse/test_out/partition_id=1/000000_0
    Found 1 items
    -rw-r--r--   3 hadoop supergroup          6 2012-11-02 21:57 /user/hive/warehouse/test_out/partition_id=2/000001_0
    Found 1 items
    -rw-r--r--   3 hadoop supergroup          6 2012-11-02 21:57 /user/hive/warehouse/test_out/partition_id=3/000002_0

圧縮を有効にすると、各Mapperが出力したファイルががそのまま残ってしまっています。

.. code-block:: postgres

    set hive.exec.compress.output = true;
    
    INSERT OVERWRITE TABLE test_out
    PARTITION (partition_id)
    SELECT val, partition_id FROM test_row
    ;

.. code-block:: none

    $ hadoop fs -ls /user/hive/warehouse/test_out/*
    Found 3 items
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=1/000000_0.deflate
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=1/000001_0.deflate
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=1/000002_0.deflate
    Found 3 items
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=2/000003_0.deflate
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=2/000004_0.deflate
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=2/000005_0.deflate
    Found 3 items
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=3/000006_0.deflate
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=3/000007_0.deflate
    -rw-r--r--   3 hadoop supergroup         10 2012-11-02 22:02 /user/hive/warehouse/test_out/partition_id=3/000008_0.deflate

SequenceFile
------------

SequenceFileでは圧縮を有効にしてもmergeされます

.. code-block:: postgres

    set hive.exec.compress.output = true;
    
    DROP TABLE test_out;
    
    CREATE TABLE test_out (
      val string
    )
    PARTITIONED BY (partition_id int)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
    STORED AS SequenceFile
    ;
    
    INSERT OVERWRITE TABLE test_out
    PARTITION (partition_id)
    SELECT val, partition_id FROM test_row
    ;

.. code-block:: none

    $ hadoop fs -ls /user/hive/warehouse/test_out/*
    Found 1 items
    -rw-r--r--   3 hadoop supergroup        196 2012-11-02 22:07 /user/hive/warehouse/test_out/partition_id=1/000000_0
    Found 1 items
    -rw-r--r--   3 hadoop supergroup        196 2012-11-02 22:07 /user/hive/warehouse/test_out/partition_id=2/000001_0
    Found 1 items
    -rw-r--r--   3 hadoop supergroup        196 2012-11-02 22:07 /user/hive/warehouse/test_out/partition_id=3/000002_0

RCFile
------

RCFileもこのテストデータではマージされます

.. code-block:: postgres

    set hive.exec.compress.output = true;
    
    DROP TABLE test_out;
    
    CREATE TABLE test_out (
      val string
    )
    PARTITIONED BY (partition_id int)
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe'
    STORED AS RCFile
    ;
    
    INSERT OVERWRITE TABLE test_out
    PARTITION (partition_id)
    SELECT val, partition_id FROM test_row
    ;

.. code-block:: none

    $ hadoop fs -ls /user/hive/warehouse/test_out/*
    Found 1 items
    -rw-r--r--   3 okuno supergroup        201 2012-11-15 17:11 /user/hive/warehouse/test_out/partition_id=1/000000_0
    Found 1 items
    -rw-r--r--   3 okuno supergroup        201 2012-11-15 17:11 /user/hive/warehouse/test_out/partition_id=2/000001_0
    Found 1 items
    -rw-r--r--   3 okuno supergroup        201 2012-11-15 17:11 /user/hive/warehouse/test_out/partition_id=3/000002_0

ですが、データによってはマージされないケースがあったので、実際に確認してみてマージされていなければワークアラウンドを入れて下さい。

Workaround
==========

INSERTのクエリにパーティションキーでのCLUSTER BYを追加します。

.. code-block:: postgres

    set hive.exec.compress.output = true;
    
    DROP TABLE test_out;
    
    CREATE TABLE test_out (
      val string
    )
    PARTITIONED BY (partition_id int)
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '\t'
    STORED AS TextFile
    ;
    
    INSERT OVERWRITE TABLE test_out
    PARTITION (partition_id)
    SELECT val, partition_id FROM test_row
    CLUSTER BY partition_id
    ;

.. code-block:: none

    $ hadoop fs -ls /user/hive/warehouse/test_out/*
    Found 1 items
    -rw-r--r--   3 okuno supergroup         14 2012-11-15 17:14 /user/hive/warehouse/test_out/partition_id=1/000000_0.deflate
    Found 1 items
    -rw-r--r--   3 okuno supergroup         14 2012-11-15 17:14 /user/hive/warehouse/test_out/partition_id=2/000000_0.deflate
    Found 1 items
    -rw-r--r--   3 okuno supergroup         14 2012-11-15 17:14 /user/hive/warehouse/test_out/partition_id=3/000000_0.deflate

無事1ファイルにマージできました。Jobのログを見ると先ほどとは違いReduceタスクが立ち上がっていることが分かります。

ちなみにこのワークアラウンドだと、正確にはマージされたわけではなくて1reducerから出力されたので1ファイルになっただけですので、 `hive.merge.size.per.task` は適用されません。

TextFileの場合はSplittableな圧縮方法にしないと危ないと思います。

******
まとめ
******

* `hive.merge.*` を有効にしていてもマージされないケースがあるのでHDFSを直接覗いて確認する
* HiveでTextFile、RCFileの出力を確実にマージさせたければDISTRIBUTE BY、CLUSTER BYを使う

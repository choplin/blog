+++
aliases = ["/blog/2013/04/20/json_vs_hstore.html"]
title = "PostgreSQLのJSON型とhstore型のパフォーマンス"
date = "2013-04-20"
categories = ["Programming"]
tags = ["PostgreSQL"]
+++

<!--more-->

## 概要

postgres 9.2で追加されたjson型に、今開発中の9.3で新たに演算子/関数が追加されることが予定されています。 この変更によって、JSON型の中の任意の値を取得することが可能になります。

ところで、postgresには以前からhstoreというキーバリューの形で構造化データを扱う拡張が存在します。 9.3で追加されたjson演算子と、hstoreでどの程度パフォーマンス差があるのか、極々簡単に計測してみました。


## リファレンス

### json演算子/関数
[PostgreSQL: Documentation: devel: JSON Functions and Operators](http://www.postgresql.org/docs/devel/static/functions-json.html)

### hstore演算子/関数
[PostgreSQL: Documentation: devel: hstore](http://www.postgresql.org/docs/devel/static/hstore.html)

## 準備

### postgres 9.3のビルド

まだリリースされてないのでmasterをビルド。hstoreを使うのでcontribも忘れずに。

```bash
git clone git://git.postgresql.org/git/postgresql.git
cd postgresql
./configure && make && make install
cd contrib
make && make install
```

### hstoreの有効化

```
CREATE EXTENSION hstore;
```

### サンプルデータの作成

```sql
CREATE TABLE json_tbl AS
SELECT
    '{"hoge":1, "fuga":2}'::json AS v
FROM
    generate_series(1,1000000)
;

CREATE TABLE hstore_tbl AS
SELECT
    '"hoge"=>1, "fuga"=>2'::hstore AS v
FROM
    generate_series(1,1000000)
;
```

### 演算子

計測する演算子はjsonにもhstoreにも用意されている `->` を使います。 キーを渡して値を取り出しものです。

```sql
   postgres=# select v->'fuga' from json_tbl limit 1;
    ?column?
   ----------
    2
   (1 row)

   postgres=# select v->'fuga' from hstore_tbl limit 1;
    ?column?
   ----------
    2
   (1 row)
```

簡単ですね。

### 計測

```
    postgres=# \timing
    Timing is on.

    postgres=# select v->'fuga' from json_tbl;
    Time: 2117.472 ms

    postgres=# select v->'fuga' from hstore_tbl;
    Time: 975.642 ms
```

多少はjson型の方が遅いだろうとは思っていましたが、倍以上遅くなりました。[^1]

念の為、正確なベンチマークにはデータサイズを変える、設定を変えるなどより深い検証が必要です。

今回はざっくりどの程度の差が出るのか知るだけということで。

## まとめ

どちらの型を用いるかという話になると思いますが、hstoreで表現できる範囲の値ならばhstoreを使った方が、現時点ではパフォーマンス面で有利そうです。 jsonでしか表現できないならば、もちろんjson型一択です。

投げるクエリによっては、一行のコストは問題にならない [^2] 場合もあるので、その辺りはよく検討してデータ型を選択して下さい。

[^1]: 数度繰り返しても同じ程度の値なのでバッファの影響はありません

[^2]: 例えば関数インデックスを使ってjson/hstoreの中の値を検索する場合、事前に計算された値でインデックスが構築されるので、検索時に演算子が使われるのはクエリに対する一度のみです。

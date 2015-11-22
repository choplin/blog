+++
aliases = ["/blog/2012/03/07/grass-on-sql.html"]
title = "Grass on SQL"
date = "2012-03-07"
categories = ["Programming"]
tags = ["PostgreSQL", "SQL", "Esoteric"]
+++

<!--more-->

Overview
--------

[ちょっと草植えときますね型言語 Grass](http://www.blue.sky.or.jp/grass/) をSQLで実装しましたという話.

Grassはλ計算をベースにした関数型プログラミング言語です.公式ページの仕様を元にSQL(PostgreSQL)で実装しました.

他Grassについては上記の公式ページとかここら辺を参照.

- [プログラミング言語/Grass - プログラミングスレまとめ in VIP](http://vipprog.net/wiki/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E/Grass.html)
- [うはｗｗｗ Mosh で Grass 実装したｗｗｗｗ - Higepon’s blog - Mona OS and Mosh](http://d.hatena.ne.jp/higepon/20080605/1212678422)

## Example

```sql
SELECT run_grass('wwWWwv wwwwWWWwwWwwWWWWWWwwwwWwwv wWWwwwWwwwwWwwwwwwWwwwwwwwww');

 run_grass
-----------
 ww
(1 row)


SELECT run_grass('wWWWwwwwWWWw');

 run_grass
-----------
 x
(1 row)
```

Homuhomu
--------

ついでに [「ほむほむ」](http://d.hatena.ne.jp/yuroyoro/20110601/1306908421) も入れておきました. 表現が異なるだけで中身はGrassとほぼ一緒.

```sql
SELECT
    run_homu($$
        ほむ ほむほむほむ ほむ ほむほむほむほむ ほむ
        ほむ ほむほむ ほむ ほむほむほむ ほむ
        ほむ ほむほむ ほむ ほむほむほむ ほむ
        ほむ ほむほむ ほむ ほむほむほむ ほむ
        ほむ ほむほむ ほむ ほむほむほむ ほむ
        ほむ ほむほむ ほむ ほむほむほむ ほむ
        ほむ ほむほむ ほむ ほむほむほむ ほむ
        ほむ ほむほむ ほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむ ほむ ほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ ほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむほむ
    $$)
;
   run_homu    
---------------
 Hello, world!
(1 row)
```

## Technique

主に利用したテクニックを紹介

### 入れ子集合モデル

ASTなどを表現するために木構造が必要になります。

SQLで木構造を扱うために [入れ子集合モデル](http://www.geocities.jp/mickindex/database/db_tree_ns.html) を採用しています。

### CASE

SQLにおけるIFのようなものです

### 再帰SQL

WITH RECURSIVEという構文を用いて、再帰的にSQLを実行することができます。

前回のSQLで定義された集合にたいして、再度問い合わせをしていくようなイメージです。

### 型定義

PostgreSQLでは列挙型や構造体のような型をユーザーで定義して用いることができます。

これらは列の別名のようなものなので、必須ではないのですが見やすさのために利用しています。

例)

```sql
CREATE TYPE Operation AS ENUM (
    'Abs'
    ,'App'
    ,'Out'
    ,'Succ'
    ,'Char'
    ,'In'
);
CREATE TYPE App AS (
    func Int
    ,arg Int
);

CREATE TYPE Node AS (
    l Int
    ,r Int
    ,op Operation
    ,app App -- for 'App'
    ,ascii Int -- for 'Char'
);
```

Source Code
-----------

全部載せると長いのでgithubのリポジトリを見てみて下さい.

https://github.com/choplin/grass_on_sql

以下簡単に概要を説明.

### Functions

#### run

Grassの実行を行うrun_grass関数ですが,大きく二つのステップに分けて実行しています.

- parse関数でソースコードからASTへの変換
- exec関数でASTを受け取って実行

```sql
CREATE OR REPLACE FUNCTION run_grass (Text) RETURNS text AS $$
SELECT
    exec( parse($1) )
$$ LANGUAGE SQL
;
```

#### parse

parse関数ではASTの構築

メインであるASTの構築はbuild_tree関数で行なっています。

動きはこんな感じです

- srcでw,Wのまとまり毎に区切って長さを取得
- recでWITH RECURSIVEを使ってまとまりを順番に消費し、長さをもとにASTを組み立てる

```sql
CREATE OR REPLACE FUNCTION build_tree (Text) RETURNS tree AS $$
WITH RECURSIVE
src(chr, len) AS (
    SELECT
        array_agg(substring(s[1] from 1 for 1))
        ,array_agg(char_length(s[1]))
    FROM
        regexp_matches($1, '(w+|W+)', 'g') AS t(s)
)
,rec(tree, idx, nextl) AS (
    SELECT
        tree( ARRAY[]::Node[] )::Tree
        ,1::Int
        ,1::Int
    UNION ALL
    SELECT
        CASE chr[idx]
            WHEN 'w' THEN add_abs_node_n_times(tree, len[idx])
            WHEN 'W' THEN add_node(tree, app_node(nextl,nextl+1,(len[idx],len[idx+1])))
        END
        ,CASE chr[idx]
            WHEN 'w' THEN idx + 1
            WHEN 'W' THEN idx + 2
        END
        ,CASE chr[idx]
            WHEN 'w' THEN nextl + len[idx]
            WHEN 'W' THEN nextl + 2
        END
    FROM
        rec, src
    WHERE
        idx <= array_length(chr, 1)
)
SELECT
    tree
FROM
    rec
ORDER BY
    idx DESC
LIMIT 1
$$ LANGUAGE SQL
;
```

#### exec

exec関数では

- initで初期状態の用意
- evalでWITH RECURSIVEを使ってASTを辿って実行

の様な動作になっています。

```sql
CREATE OR REPLACE FUNCTION exec (Code) RETURNS Text AS $$
WITH RECURSIVE
init(machine) AS (
    SELECT
    machine(
        $1
        ,env( ARRAY[ 4,3,2,1 ] )
        ,dump(
            ARRAY[
                dump_elem(
                    code( ARRAY[ tree( ARRAY[app_node(1,2,(1,1))] ) ] )
                    ,env( ARRAY[ ]::Int[] )
                )
                ,dump_elem(
                    code( ARRAY[ tree( ARRAY[]::Node[] ) ] )
                    ,env( ARRAY[ ]::Int[] )
                )
            ]
        )
        ,closure(
            ARRAY[
                closure_elem(
                    code( ARRAY[ tree( ARRAY[in_node()] ) ] )
                    ,env( ARRAY[ ]::Int[] )
                )
                ,closure_elem(
                    code( ARRAY[ tree( ARRAY[char_node(119)] ) ] )
                    ,env( ARRAY[ ]::Int[] )
                )
                ,closure_elem(
                    code( ARRAY[ tree( ARRAY[succ_node()] ) ] )
                    ,env( ARRAY[ ]::Int[] )
                )
                ,closure_elem(
                    code( ARRAY[ tree( ARRAY[out_node()] ) ] )
                    ,env( ARRAY[ ]::Int[] )
                )
            ]
        )
    )
)
,eval (idx, machine, output) AS (
    (
        WITH sub (tree) AS (
            SELECT
                (machine).code.trees[1]
            FROM
                init
        )
        SELECT
            1::Int AS idx
            ,machine
            ,''::Text
        FROM
            init,sub
    )
    UNION ALL(
        WITH
        prev(idx, machine) AS (
            SELECT
                idx
                ,machine
                ,output
            FROM
                eval
            LIMIT 1
        )
        ,sub(idx, tree, root) AS (
            SELECT
                idx
                ,tree
                ,root(tree)
            FROM(
                SELECT
                    idx
                    ,(machine).code.trees[1] AS tree
                FROM
                    prev
            )t
        )
        SELECT
            idx + 1
            ,CASE
                WHEN isEmpty((machine).code) THEN ret(machine)
                WHEN (sub.root).op = 'Abs' THEN exec_abs(subtrees(sub.tree), machine)
                WHEN (sub.root).op = 'App' THEN exec_app(sub.root, machine)
                WHEN (sub.root).op = 'Out' THEN ret(machine)
                WHEN (sub.root).op = 'Succ' THEN exec_succ(machine)
            END
            ,CASE
                WHEN (sub.root).op = 'Out' THEN output || get_char(machine)
                ELSE output
            END
        FROM
            prev
        INNER JOIN -- 直前以外のprevとJOINされてしまうためINNER JOINを行う
            sub USING(idx)
        WHERE
            NOT (isEmpty((machine).code) AND isEmpty((machine).dump))
    )
)
SELECT
    output
FROM
    eval
WHERE
    output IS NOT NULL
ORDER BY
    idx DESC
LIMIT 1
$$ LANGUAGE SQL IMMUTABLE STRICT
;
```

## Limitation

現状ではGrassの仕様を全ては実装しておらず、サブセットになります。

- SQLの制限上からINは実装してません
- FとTはパスしてます

Pull Requestお待ちしてます

後、読みやすさを重視しているので遅いです。誰か最適化して下さい。

## Turing Complete

また一つ [SQLがチューリング完全である](http://d.hatena.ne.jp/bleis-tift/20090610/1244615237) ことが証明されてしまいました。

[Wikipediaのチューリング完全のページ](http://ja.wikipedia.org/wiki/%E3%83%81%E3%83%A5%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E5%AE%8C%E5%85%A8) にはSQLはチューリング完全でないと堂々と書いてあるのでWikipedianの人は修正をお願いします。

## Appendix

余談ですが、こういう "XでYを実装してみた" は早い者勝ちなので、流行り始めた途端に主要な言語は食いつぶされてしまい、僕のような一般人が実装する隙は中々ありません。

そうした中でもSQLは今回のように余りがちなので、悔しい思いをしたことがある方は是非SQLをマスターしてチャレンジしてみて下さい。

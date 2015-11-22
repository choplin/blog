+++
aliases = ["/blog/2012/05/17/operator-to-json-type-in-postgres9.2-with-plv8.html"]
title = "Operator to JSON type in PG9.2 with plv8"
date = "2012-05-17"
categories = ["Programming"]
tags = ["DB", "PostgreSQL", "JavaScript"]
+++

<!--more-->

## Pg9.2

ついにPostgres9.2の [beta1](http://www.postgresql.org/about/news/1395/) がきましたね。先進的な象使いのみなさまは既にビルド済みのことと思います。私もgitのheadをビクビクしながらビルドするのではなくて、tagから9.2のbranchを切ることできてほっとしております。

9.2には様々な機能性能が目白押しですが、そんな中ついに待望のJSON型サポートが追加されました。

[PostgreSQL: Documentation: Manuals: JSON Type](http://www.postgresql.org/docs/devel/static/datatype-json.html)

## JSON型で何ができるの？

JSON型に関する機能としてコアで提供されているものは

1. バリデーション
2. JSON文字列の構築

の2つです。

### 1.バリデーション

JSON型を指定することによってValidなJSONであることを保証できます。

```sql
-- valid
json=# SELECT '{"a":1}'::json;
  json
---------
 {"a":1}
(1 row)

-- invalid
json=# SELECT '{a:1}'::json;
ERROR:  invalid input syntax for type json at character 8
DETAIL:  line 1: Token "a" is invalid.
STATEMENT:  SELECT '{a:1}'::json;
ERROR:  invalid input syntax for type json
LINE 1: SELECT '{a:1}'::json;
               ^
DETAIL:  line 1: Token "a" is invalid.
```

### 2.JSON文字列の構築

- 配列からJSON文字列を構築する `array_to_json`
- ROW型からJSON文字列を構築する `row_to_json`

が提供されています。

[PostgreSQL: Documentation: Manuals: JSON Functions](http://www.postgresql.org/docs/devel/static/functions-json.html)

```sql
json=# select array_to_json(ARRAY[1,2,3]);
 array_to_json
---------------
 [1,2,3]
(1 row)

json=# select row_to_json(ROW(1,2,3));
      row_to_json
------------------------
 {"f1":1,"f2":2,"f3":3}
(1 row)
```

### それだけ？

現状ではこれだけです。基本的にJSON型の値に対する操作は一切提供されていません。

### 中身は取れる？

取れません。正規表現を使えばあるいは可能かも。

### whereで絞り込める？

できません。演算子は何も提供されていません。

### Indexは張れる？

もちろん張れません。

## Workaround

どうしてもPG9.2でJSON型の操作がしたいのであれば、 [plv8js](http://code.google.com/p/plv8js/wiki/PLV8) を使って自分で演算子を定義してしまうのがオススメかなと思います。

そんなワガママなあなたの為にちょこっと書いておきました。

<script src="https://gist.github.com/choplin/2719269.js"></script>

### Indexも張れます

上で定義した演算子と [式インデックス](http://www.postgresql.jp/document/9.1/html/indexes-expressional.html) を組み合わせることでインデックスを張ることもできます。

```sql
-- データ準備
CREATE TABLE test (
    id serial
    ,json json
);

INSERT INTO test(json)
SELECT ('{"a":' || round(random() * 10000) || '}')::json
FROM generate_series(1,10000);

CREATE INDEX i_test_json ON test(((json @ 'a')::text::int));

-- クエリ
json=# EXPLAIN SELECT * FROM test WHERE (json @ 'a')::text::int = 30 ;                                QUERY PLAN                                 
---------------------------------------------------------------------------
 Bitmap Heap Scan on test  (cost=4.91..74.77 rows=50 width=36)
   Recheck Cond: ((((json @ 'a'::text))::text)::integer = 30)
   ->  Bitmap Index Scan on i_test_json  (cost=0.00..4.90 rows=50 width=0)
         Index Cond: ((((json @ 'a'::text))::text)::integer = 30)
(4 rows)

json=# EXPLAIN SELECT * FROM test WHERE (json @ 'a')::text::int > 30 ;
                                  QUERY PLAN                                  
------------------------------------------------------------------------------
 Index Scan using i_test_json on test  (cost=0.26..318.85 rows=3333 width=36)
   Index Cond: ((((json @ 'a'::text))::text)::integer > 30)
(2 rows)
```

## まとめ

Postgresの拡張性を活かせばJSON型の値を操作することは簡単にできます。ですが、PosgresでJSON型を操作するには

- 標準でない演算子を用いてしまうとSQLのポータビリティが低くなる
    - 最悪のケースでは今後のバージョンで@演算子が別の意味で使われてしまい全く動かなくなる可能性が

- JSON内の値は数値、文字列、Boolean、配列、オブジェクトなど様々な型の可能性があるので扱いが難しい
    - キャストもめんどくさい

- （パフォーマンスは計測してないので不明）

などの問題があります。リスクを認識した上で使いたい人は使うといいと思います。

9.2には他にも熱い機能や性能アップがあるのでまだビルドしていない人は早くビルドして試して下さい。

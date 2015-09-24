+++
title = "case classとList/Map/Tupleの相互変換"
date = "2013-02-22"
categories = ["Programming"]
tags = ["Scala"]
+++

case classとコレクションを相互変換したいことがたまにあるので方法をまとめておきます。

もちろんやり方は一つではないので一例です。

<!--more-->


準備
----

scala 2.9.2で確認

``` sourceCode
scala> case class Foo(i: Int, s: String)
defined class Foo

```

変換方法
--------

### List

Listにするのは簡単ですが、case classに戻すのはリフレクションが必須でasInstanceOfが頻発して嫌な感じですね。

productIteratorの段階で型情報が失われてしまうのが原因ではないかと思います。

ref: [scala - Instantiating a case class from a list of parameters - Stack Overflow](http://stackoverflow.com/questions/4290955/instantiating-a-case-class-from-a-list-of-parameters)

#### case class -&gt; List

``` sourceCode
```

#### List -&gt; case class

``` sourceCode
```

### Map

Mapへの変換はリフレクションでフィールド名を取得して、上記の値のリストにzipすればオッケーです。

Field.getを利用して直接value込のtupleを作る方法もあるようです。URL先参照。

case classへの変換はvalues.toListすれば後はListを同じ方法で。

ref: [Case class to map in Scala - Stack Overflow](http://stackoverflow.com/questions/1226555/case-class-to-map-in-scala)

#### case class -&gt; Map

``` sourceCode
```

#### Map -&gt; case class

``` sourceCode
```

### Tuple

Tupleはcase classと両者ともProductをmix-inされているなど意味的に近いので、変換は行きも帰りも素直にできます。

### case class -&gt; Tuple

``` sourceCode
```

### Tuple -&gt; case class

``` sourceCode
scala> Foo.tupled(t)
```

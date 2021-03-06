+++
aliases = ["/blog/2013/02/22/scala-case-class-to-list-map-tuple.html"]
title = "case classとList/Map/Tupleの相互変換"
date = "2013-02-22"
categories = ["Programming"]
tags = ["Scala"]
+++

<!--more-->

case classとコレクションを相互変換したいことがたまにあるので方法をまとめておきます。

もちろんやり方は一つではないので一例です。


## 準備

scala 2.9.2で確認

```scala
scala> case class Foo(i: Int, s: String)
defined class Foo
```

## 変換方法

### List

Listにするのは簡単ですが、case classに戻すのはリフレクションが必須でasInstanceOfが頻発して嫌な感じですね。

productIteratorの段階で型情報が失われてしまうのが原因ではないかと思います。

ref: [scala - Instantiating a case class from a list of parameters - Stack Overflow](http://stackoverflow.com/questions/4290955/instantiating-a-case-class-from-a-list-of-parameters)

#### case class -&gt; List

```scala
scala> val l = f.productIterator.toList
l: List[Any] = List(1, bar)
```

#### List -&gt; case class

```scala
scala> Foo.getClass.getMethods.find(_.getName == "apply").get.invoke(Foo, l.map(_.asInstanceOf[AnyRef]):_*).asInstanceOf[Foo]
res1: Foo = Foo(1,bar
```

### Map

Mapへの変換はリフレクションでフィールド名を取得して、上記の値のリストにzipすればオッケーです。

Field.getを利用して直接value込のtupleを作る方法もあるようです。URL先参照。

case classへの変換はvalues.toListすれば後はListを同じ方法で。

ref: [Case class to map in Scala - Stack Overflow](http://stackoverflow.com/questions/1226555/case-class-to-map-in-scala)

#### case class -&gt; Map

```scala
scala> val m = f.getClass.getDeclaredFields.map(_.getName).zip(f.productIterator.toList).toMap
m: scala.collection.immutable.Map[java.lang.String,Any] = Map(i -> 1, s -> bar)
```

#### Map -&gt; case class

```scala
scala> Foo.getClass.getMethods.find(_.getName == "apply").get.invoke(Foo, m.values.toList.map(_.asInstanceOf[AnyRef]):_*).asInstanceOf[Foo]
res2: Foo = Foo(1,bar)
```

### Tuple

Tupleはcase classと両者ともProductをmix-inされているなど意味的に近いので、変換は行きも帰りも素直にできます。

### case class -&gt; Tuple

```scala
scala> val t = Foo.unapply(f).get
t: (Int, String) = (1,bar)
```

### Tuple -&gt; case class

```scala
scala> Foo.tupled(t)
res3: Foo = Foo(1,bar)
```

###################
Scalaで型クラス入門
###################



.. author:: default
.. categories:: Programming
.. tags:: Scala, Functional Programming
.. comments::

型クラスについてつらつら考えていたことをまとめておきます。マサカリ歓迎。

**************
型クラスって？
**************

型クラスとは一言でいうと。

* **アドホック多相** を実現するもの

です。モから始まる名状し難いあれとは直接は関係ありません。

ではアドホック多相とは何かというと

* 異なる型の間で共通したインターフェースでの異なる振る舞いを
* 定義済みの型に対して拡張する

ような多相のことです。

.. more::

異なる型間での共通したインターフェースでの異なる振る舞い
========================================================

Javaの継承やインターフェース、Scalaのtraitを用いることで、異なる型間での共通したインターフェースを管理することができます。

.. code-block:: scala

    trait SomeTrait {
      def someMethod(): String
    }
    
    class Foo extends SomeTrait {
      def someMethod(): String = "foo"
    }
    
    class Bar extends SomeTrait {
      def someMethod(): String = "bar"
    }
    
    def someFunc(x: SomeTrait) = x.someMethod()
    
    someFunc(new Foo) //=> foo
    someFunc(new Bar) //=> bar

FooとBarで異なる振る舞いをするsomeMethodを、SomeTraitを通すことで共通して呼び出すことができています。

これらは型の階層関係に基づいた多相性を提供するものです。
定義済みの型に対して新たなインターフェースを追加することはできません。

定義済みの型に対して拡張する
============================

Rubyのようなオープンクラスを採用している言語であれば特に何もせずに実現できます。

.. code-block:: ruby

    class String
      def hoge
        "hoge"
      end
    end
    
    "fuga".hoge #=> hoge

Scalaであればimplicit conversionを使うことで定義済みの型を拡張でき（るように見せられ）ます。

.. code-block:: scala

    case class Hoge(s: String) {
      def hoge() = "hoge"
    }
    
    implicit def stringToHoge(s: String) = Hoge(s)
    
    "foo".hoge //=> hoge

Rich~で普段から使っていると使っていると思います。

これらの方法では型を拡張することはできますが、共通したインターフェースをまとめることは困難です。

そして型クラスへ
================

この2つの条件は型クラスによる多相では同時に満たすことが可能です。

Haskellでは言語レベルで型クラスをサポートしているのでHaskellの例を見てみましょう。

まず型クラス（とそのインターフェース）を定義します

.. code-block:: haskell

    class Who a where
      who :: a -> String

次にインスタンスを定義します。インスタンスでは、型クラスに属する型と、その型における振る舞いを定義します。

.. code-block:: none

    instance Who Int where
      who i = "Int"
    
    instance Who Double where
      who s = "Double"

最後に型クラスを利用します。

.. code-block:: none

    main = do
      print $ who (1::Int) -- => Int
      print $ who (1::Double) -- => Double

IntとDoubleという既存の型に対して、型名の文字列を返す `who` というインターフェースを追加しています。

この `who` はWho型クラスで管理されているので、 `who` を利用する際は多相を利用し一つにまとめて定義することが可能です。

.. code-block:: haskell

    sayWho :: Who a => a -> IO()
    sayWho x = who x
    
    main = do
      sayWho (1::Int)
      sayWho (1::Double)

参考資料
========

上記で型クラスの概要については理解できたでしょうか。

型クラスについての素晴らしい資料は多くあるので、より詳細な内容についてはそちらを参照してください。

* `A Gentle Introduction to Haskell: Classes <http://www.sampou.org/haskell/tutorial-j/classes.html>`_
* `Typeclassopedia - HaskellWiki <http://www.haskell.org/haskellwiki/Typeclassopedia>`_
* 日本語訳: `The Typeclassopediaを訳しました, The Typeclassopedia - #3(2009-10-20) <http://snak.tdiary.net/20091020.html>`_
* `Scala Implicits: 型クラス、襲来 | eed3si9n <http://eed3si9n.com/ja/node/15>`_

*****************
Scalaでの型クラス
*****************

Scalaでは言語レベルでの型クラスのサポートはありませんが、柔軟な言語仕様によって型クラスを実現することが可能です。

型クラスを実現する手順は

1. 型クラスを定義する
2. インスタンスを定義する
3. 型クラスを利用する

Haskellの場合と同じですね。もちろんそれぞれの段階ですべきことは異なります。

1. 型クラスを定義する
=====================

Haskellではclassという組み込みの構文で定義しましたが、scalaではtraitか抽象クラスを用いて型クラスとします。
（HaskellのclassはScalaのclassとは全く異なるので注意！）

traitの定義において、インスタンスを定義する型を、型パラメータとしておきます。

.. code-block:: scala

    trait Who[T] {
      def who(x: T): String
    }

2. インスタンスを定義する
=========================

Scalaでは型クラスの利用時に、 **implicit parameter** として明示的に型クラスのインスタンスを渡します。（具体的な呼び出し方は後述）

型クラスのインスタンスがグローバルに暗黙的に定義されるHaskellとはここが異なります。

よって、Scalaにおける型クラスのインスタンスはimplicit parameterとして渡せるものです

* implicit val/var
* implicit object
* 引数リストなしのimplict def

が利用できます。（解説によって上記のいずれかをバラバラに利用していて混乱しますが、要はimplicit parameterとして渡せればいいのでどれでもいいです）

1. 型クラスの定義をする際にパラメータ化した型に、インスタンスとして定義する型を当てはめながら、
2. 値が
    * val/var/defの場合はtraitを無名で実装し、そのインスタンス（newするということです。ややこしい、、、）を返す
    * objectの場合はtraitをミックスインして実装する

とすることで、型クラスのインスタンスを定義することができます。

文章にするとややこしいですが、例を見れば簡単です。

.. code-block:: scala

    implicit def WhoInt = new Who[Int] {
      def who(x: Int) = "Int"
    }
    
    implicit object WhoDouble extends Who[Double] {
      def who(x: Double) = "Double"
    }

ここで `WhoInt` `WhoDouble` がそれぞれInt、DoubleにおけるWho型クラスのインスタンスです。
暗黙的なHaskellのインスタンスとことなり、プログラム中のオブジェクトとして明示的に存在しています。

3. 型クラスを利用する
=====================

型クラスを利用する際は、型をパラメータ化した関数を用います。
この型パラメータにはインスタンスが存在する型が入ることになります。

.. code-block:: scala

    def sayWho[T](x: T)(implicit instance: Who[T]) = println(instance.who(x))
    
    val i = 1
    val d = 1.0
    
    sayWho(i) //=> Int
    sayWho(d) //=> Double

ここでは関数の引数として利用しました。一見単なるオーバーロードっぽく見えますが、実際には型クラスのインスタンスで多相を実現しているので、関数の定義はこの先インスタンスを増やしていってもこの一箇所のみです。

メソッドとして利用する場合は、メソッドを定義したtraitなりにimplicit conversionさせることで実現できます。

.. code-block:: scala

    trait WhoOps[T] {
      def self: T
      implicit def instance: Who[T]
    
      def whoMethod() = instance.who(self)
    }
    
    implicit def ToWhoOps[T](v: T)(implicit i: Who[T]) =
        new WhoOps[T] {
          def self = v;
          implicit def instance: Who[T] = i
        }
    
    val i = 1
    val d = 1.0
    
    println(i.whoMethod) //=> Int
    println(d.whoMethod) //=> Double

完成
====

以上で無事Scalaでの型クラスを実装することができました。

この流れが理解できていればscalazのコードも読めるはずですので、後はコードを読んで理解を深めればいいのではと思います。

context bound
=============

実際に型クラスを利用する際は、シンタックスシュガーであるcontext boundを用いて書くことが多いようです。

.. code-block:: scala

    def sayWho[T: Who](x: T) = println(implicitly[Who[T]].who(x))

シンタックスシュガーですので上記の `sayWho` と全く同じ内容を表しています。
但しimplicit parameterは暗黙になってしまったので、implicitlyで実体化する必要があります。

context boundの読み方としては "Who[T]がimplicit parameterとしてスコープ内に存在するT" といった感じでしょうか。

ところでcontext boundは型クラスのインスタンスとして渡すくらいしか使い道が思い浮かばないのですが、この為に作られたんでしょうか？
Scalaの歴史に詳しい人教えてください。

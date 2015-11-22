+++
aliases = ["/blog/2012/05/19/inverse-fizzbuzz-with-haskell.html"]
title = "Inverse FizzBuzz with Haskell"
date = "2012-05-19"
categories = ["Programming"]
tags = ["Haskell"]
+++

<!--more-->

## Inverse FizzBuzz

Inverse FizzBuzzについてはこちらを参照 [逆FizzBuzz問題 (Inverse FizzBuzz) - 猫とC#について書くmatarilloの雑記](http://d.hatena.ne.jp/matarillo/20120515/p1)

簡単に言うとFizzBuzzの列が与えられた時に、その列を生成する数列を返すという問題です。

にわかHaskellerですが、Haskellで書いてみたので誰かが添削してくれることを願って残しておきます

<script src="https://gist.github.com/choplin/2709561.js"></script>

## 方針

少し考えれば分かりますがFizzBuzzのパターンは7種類しかありません。

```haskell
data FizzBuzz = Fizz | Buzz | FizzBuzz deriving (Eq, Show)
type Pattern = (Int,[FizzBuzz])

patterns :: [Pattern]
patterns = [
    (6,[Fizz,Fizz])
    ,(3,[Fizz,Buzz,Fizz,Fizz])
    ,(9,[Fizz,Buzz,Fizz,FizzBuzz])
    ,(12,[Fizz,FizzBuzz])
    ,(5,[Buzz,Fizz,Fizz])
    ,(10,[Buzz,Fizz,FizzBuzz])
    ,(15,[FizzBuzz])
  ]
```

ですので最初の数FizzBuzzを調べるだけで、数列の始まりは簡単に判明します。

上の性質に着目して

1. FizzBuzz列の最初と上記のパターンを比較して始まりの数を取得
2. 始まりの数からのFizzBuzz列を生成して、与えられたFizzBuzz列と一致させる

という方針で解いています。

## 真のHaskellerによる美しい解答

はこちら

[Inverse FizzBuzz #Haskell - Qiita](http://qiita.com/items/659b5ff4d653f9f309c1)

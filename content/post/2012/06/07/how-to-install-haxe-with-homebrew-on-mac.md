+++
aliases = ["/blog/2012/06/07/how-to-install-haxe-with-homebrew-on-mac.html"]
title = "Haxeをhomebrewでインストールする方法"
date = "2012-06-07"
categories = ["Programming"]
tags = ["Haxe", "Mac"]
+++

<!--more-->

## Intro


- [JSXよりHaxeがイケてる3つの理由 - みずぴー日記](http://d.hatena.ne.jp/mzp/20120604/jsx)
- [haXe と JSX の最大の違いは null と undefined の扱い - kazuhoのメモ置き場](http://d.hatena.ne.jp/kazuhooku/20120605/1338860543)
- [JSX v.s. HaXeベンチマーク戦争 - Togetter](http://togetter.com/li/315178)

structural subtypingとか関数型のリテラルがイケてたりとか型推論とか中々良い感じですね。

## Problem

そんなHaxeですが、下記のブログで言及されているように、Macのhomebrewでインストールすると一部動きません。

- [HaxeでJavaScriptゲームを作ってみた - サンフラットの開発日記](http://d.hatena.ne.jp/sunflat/20120605/p1)

```
$ brew install neko haxe
$ haxelib setup
dyld: Library not loaded: @executable_path/libneko.dylib
  Referenced from: /usr/local/bin//haxelib
  Reason: no suitable image found.  Did find:
        /usr/local/bin//libneko.dylib: mach-o, but wrong architecture
```

haxeのコンパイラは動くのですが、パッケージマネージャのhaxelibでエラーが出ます。 メッセージを見るとhaxelibが依存しているlibneko.dylibのarchitectureが違うようです。

lipoで確認すると確かに違っています。

```
$ lipo -info /usr/local/bin/haxelib
Non-fat file: /usr/local/bin/haxelib is architecture: i386
$ lipo -info /usr/local/bin/libneko.dylib
Non-fat file: /usr/local/bin/libneko.dylib is architecture: x86_64
```

## Solution

これは `brew install haxe` は公式が提供しているバイナリをインストールする一方で、 `brew install neko` はソースコードからビルドしているためです。

nekoの公式を見るとバイナリが用意されておりそちらが推奨されているようなので、バイナリを取得するFormulaを用意すればOKです。

<script src="https://gist.github.com/choplin/2883027.js"></script>

```
$ brew edit neko
$ brew install neko haxe
$ haxelib setup
Please enter haxelib repository path with write access
Hit enter for default (/usr/local/share/haxe)
Path :
```

動きました。これでHaxeのベンチマークも取り放題ですね。

nekovmについては全く知らないのでファイルの配置がこれで正しいかは分かりません。at your own riskで。

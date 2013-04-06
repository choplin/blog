####################################
Haxeをhomebrewでインストールする方法
####################################



.. author:: default
.. categories:: Haxe, Mac
.. tags:: none
.. comments::

Intro
=====

JSXのおかげ？か俄に話題に登るようになってきたマルチプラットフォーム言語の `Haxe <http://haxe.org/?lang=jp>`_ です。

- `JSXよりHaxeがイケてる3つの理由 - みずぴー日記 <http://d.hatena.ne.jp/mzp/20120604/jsx>`_
- `haXe と JSX の最大の違いは null と undefined の扱い - kazuhoのメモ置き場 <http://d.hatena.ne.jp/kazuhooku/20120605/1338860543>`_
- `JSX v.s. HaXeベンチマーク戦争 - Togetter <http://togetter.com/li/315178>`_

structural subtypingとか関数型のリテラルがイケてたりとか型推論とか中々良い感じですね。

Problem
=======

そんなHaxeですが、下記のブログで言及されているように、Macのhomebrewでインストールすると一部動きません。

- `HaxeでJavaScriptゲームを作ってみた - サンフラットの開発日記 <http://d.hatena.ne.jp/sunflat/20120605/p1>`_

.. code-block:: sh

    $ brew install neko haxe
    $ haxelib setup
    dyld: Library not loaded: @executable_path/libneko.dylib
      Referenced from: /usr/local/bin//haxelib
      Reason: no suitable image found.  Did find:
            /usr/local/bin//libneko.dylib: mach-o, but wrong architecture

haxeのコンパイラは動くのですが、パッケージマネージャのhaxelibでエラーが出ます。
メッセージを見るとhaxelibが依存しているlibneko.dylibのarchitectureが違うようです。

lipoで確認すると確かに違っています。

.. code-block:: none

    $ lipo -info /usr/local/bin/haxelib
    Non-fat file: /usr/local/bin/haxelib is architecture: i386
    $ lipo -info /usr/local/bin/libneko.dylib
    Non-fat file: /usr/local/bin/libneko.dylib is architecture: x86_64

Solution
========

これは `brew install haxe` は公式が提供しているバイナリをインストールする一方で、 `brew install neko` はソースコードからビルドしているためです。

nekoの公式を見るとバイナリが用意されておりそちらが推奨されているようなので、バイナリを取得するFormulaを用意すればOKです。

.. raw:: html

    <script src="https://gist.github.com/choplin/2883027.js"></script>

.. code-block:: sh

    $ brew edit neko
    $ brew install neko haxe
    $ haxelib setup
    Please enter haxelib repository path with write access
    Hit enter for default (/usr/local/share/haxe)
    Path : 

動きました。これでHaxeのベンチマークも取り放題ですね。

nekovmについては全く知らないのでファイルの配置がこれで正しいかは分かりません。at your own riskで。

.. _octopress_to_tinkerer:

#################################
OctopressからTinkererに乗り換えた
#################################



.. author:: default
.. categories:: Programming
.. tags:: blog, Tinkerer
.. comments::

****
概要
****

ブログ用の静的ページの生成システムを `Octopress <http://octopress.org/>`_ から `Tinkerer <http://www.tinkerer.me/>`_ に乗り換えました。

****
動機
****

Tikererはまだ使い込んだわけではないのですが、Octopressから切り替えるにあたって自分にとってどのようなメリット・デメリットあるかを考えてみました。

Pros
====

* Sphinxがベースになっている
  * reStructuredTextが使える

    個人的な好みですが。markdownはシンプルなんですが、シンプル過ぎて手が行き届かないと感じることが多いです。例えばテーブルを書きたい時は生HTMLで<table>を書く必要があります。

  * Sphinxのエコシステムを利用できる

    Sphinxは広く使われているドキュメントシステムであり、拡張なども多く作られています。tinkerはビルドはSphinxが行うようになっているので、これらの拡張は全て利用することができます。
    また、Sphinxは公式ドキュメントが充実している上に、知見がweb上に多く公開されています。何か困った時に助けになるような情報が見つかる可能性が高いです。

* 軽い

  octopressに比べてビルドが明らかに速いです。同じ量の記事を入れてビルドの時間を測ったところ3倍弱の速度差がありました。

.. code-block:: bash

   $ time tinker -b

   ...

   tinker -b  3.37s user 0.17s system 99% cpu 3.547 tota

   $ time bundle exec rake generate

   ...

   bundle exec rake generate  10.98s user 0.61s system 99% cpu 11.597 total

* シンプル

  tinkererは基本的に記事の追加とビルドしかやりません。octopressはファイルの変更を監視して再ビルドや、リポジトリへのデプロイなどもサポートしています。これらは既存のツールとの組み合わせで実現できるので、コアはシンプルに保っている方が個人的には好ましいです。

Cons
====

* (恐らく)利用者が少ない

  正確に

****
課題
****

*URLの構造が変わってしまう* 

************************************
MarkdownからreStructuredTextへの変換
************************************



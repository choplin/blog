#####################################
Octopressで下書きをプレビューする方法
#####################################



.. author:: default
.. categories:: Octopress

.. tags:: none
.. comments::

Motivation
==========

他CMSからOctopress + github pages で快適なブログ生活を送っている方が増えているようです。

ところで、CMSやブログサービスの重要な機能の一つに記事の下書きを挙げられます。ちょっとずつ書き進めたいひとはもちろん、情熱に任せて一気に書き上げた記事も、すぐに公開せずに下書きで一晩寝かせて読み直すと恥ずかしいことに気付いたりと、色々役に立ちますね。

Octopressでこの便利な下書き機能を利用することはできるのでしょうか？

もちろん手で_postsに入れたり出したりすればできるのですが、かっこ悪いですね。

Solution
========

Writing
-------

まず作成した記事をHTMLに含めない方法です。

新規記事を作成した後、

.. code-block:: sh

    $ rake new_post[test]

publishedをfalseにします。

.. code-block:: none

    ---
    layout: post
    title: "test"
    published: false
    date: 2012-05-27 02:56
    ---

publishedをfalseにしている間は、その記事はrake generateで作成したHTMLに含まれないようになります。

Previewing
----------

preview unpublisedプラグインを使います。その名の通りpublished: falseな記事をpreviewするためのプラグインです。

ドキュメントにはないようですが、デフォルトでOctopressに含まれているので特にインストールは必要ありません。

環境変数 `OCTOPRESS_ENV` がpreviewの場合にのみ、rake generateの結果に表示されるようになります。

.. code-block:: sh

    $ OCTOPRESS_ENV=preview rake generate # 全ての下書きが表示される
    $ # OCTOPRESS_ENV=preview rake preview # previewコマンドであれば一回入力すればオーケー

Publishing
----------

後は公開する時にpublishedをtrueにしてrake gen_deployするだけです。複数の下書きがある場合もtrueにしたもののみが公開されます。

**rake deployだと全ての下書きが公開されてしまうので、必ずgen_deployを使用して下さい！**

.. code-block:: none

    ---
    published: true
    ---

.. code-block:: sh

    $ rake gen_deploy # リモートで表示される

これでOctopress生活がさらに快適になりますね。

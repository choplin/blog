#################################################################
Octopressで設定したディレクトリの画像を表示するプラグインを書いた
#################################################################



.. author:: default
.. categories:: Programming
.. tags:: Octopress
.. comments::

HowTo
=====

_config.ymlにディレクトリを書いて

.. code-block:: yaml

    image_dir: images/blog

ファイルを指定すると

.. code-block:: none

    {% include_img test.jpg %}

imgタグになります

.. code-block:: html

    <img src="/images/blog/test.jpg">

この場合 `{octopress_path}/sources/images/blog/test.jpg` に画像を置いておけばオッケーです。

Why
===

画像は特定の場所に置きたいので、画像URLのprefixを設定したいのですが、
標準のimageプラグインはURLでしか指定できないので作りました。

標準のプラグインを少し書き換えただけなので、作ったというにはおこがましいですが。

もしかしたら既存の機能でできたのかもしれませんが、情弱の私は作ったほうが早かったようです。

Code
====

.. raw:: html

    <script src="https://gist.github.com/choplin/2794594.js"></script>

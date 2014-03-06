###############################
fluent-tailというツールを書いた
###############################



.. author:: default
.. categories:: Programming
.. tags:: fluentd
.. comments::

fluentdを使っていると、そのストリームにどういうデータが流れているか確認したいことが頻繁にあって、そういう時に一々copy -> stdoutなconfigを追加してreloadするのが面倒なので、専用のツールを書きました。

これ -> `choplin/fluent-tail <https://github.com/choplin/fluent-tail>`_

.. more::

************
インストール
************

::

    $ fluent-gem install fluent-tail


********
事前準備
********

`in_debug_agent` が提供しているdrubyの入り口を使うので有効にしておいて下さい。

::

    <source>
      type debug_agent
    </source>

******
使い方
******

`<match>` と同様の形式でパターンを指定すると、そのパターンにマッチしたイベントが標準出力に出ます。

fluentdを起動して

::

    $ fluentd

fluent-tailを実行する

::

    $ fluent-tail "foo.**"

そこにイベントを流すと、指定したパターンにマッチしたイベントだけ表示されます

::

    $ '{"a":"b"}' | fluent-cat foo
    $ '{"a":"b"}' | fluent-cat foo.bar
    $ '{"a":"b"}' | fluent-cat hoge
    $ '{"a":"b"}' | fluent-cat foo.bar.foo

::

    2014-03-06 14:22:21 +0900 foo: {"a":"b"}
    2014-03-06 14:22:23 +0900 foo.bar: {"a":"b"}
    2014-03-06 14:22:27 +0900 foo.bar.foo: {"a":"b"}

以上。簡単ですね。

******
注意点
******

内部的には、 `druby` で実行中のfluentdプロセスに接続して、 `instance_eval` で `Engine#emit_stream` というfluentのルーティングの根幹の部分を、実行時に書き換えるということをしているので、安全性については何ともです。

私は今のところ問題なく使えてますが、↑を認識した上で注意して使って下さい。

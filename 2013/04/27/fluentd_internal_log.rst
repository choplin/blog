###################################
fluentd自身のログにまつわるノウハウ
###################################



.. author:: default
.. categories:: Programming
.. tags:: fluentd
.. comments::

*************
fluentdのログ
*************

流行に敏いみなさまは既にfluentdのクラスタを組まれているかと思います [1]_ が、fluentd自体のログはどうしてますでしょうか？

サーバーに直接入って確認している？せっかくログアグリゲーターを組んでいるのだから、fluentd自体のログもfluentdで管理しませんか。

fluentdでは以下の様な `match` を定義しておくと、自身のログをメッセージとして流すようになっています。

.. code-block:: none

    <match fluent.**>
    ...
    </match>

流れてくるメッセージはこんな感じ。

.. code-block:: none

   fluent.info: {"message":"force flushing buffered events"}
   fluent.warn: {"message":"emit transaction failed"}
   fluent.error: {"message":"forward error: queue size exceeds limit"}

ちなみに、 `no patterns matched tag` のwarningを不必要に出さ無いために、適切な `match` がない場合はメッセージを流さないようになっています。気が効いていますね。

また、ここでの適切な `match` とは、 `fluentd` というマッチするかどうかです。実際に流れるメッセージは `fluent.warn` などの形なので一見 `<match fluent.*>` でも大丈夫そうなのですが、これだと `fluent` タグはマッチしないのでメッセージは流れるようになりません。気をつけて下さい。

この設定を入れておくとfluentdにメッセージとして流れるようになるので、後は各種プラグインで好きに加工して下さい。

******
設定例
******

私の設定例を紹介しておきます。

全ノードの設定と、それを集約して利用するwatcherノード用の設定に分かれています。

全ノード用
==========

.. code-block:: none

    <match fluent.**>
      type record_modifier
      tag internal.message

      host ${hostname}
      include_tag_key
      tag_key original_tag
    </match>

    <match internal.message>
      type forward
      <server>
        name watcher
        host watcher.domain
        port 24224
      </server>
    </match>

`fluent-plugin-record-modifier <https://github.com/repeatedly/fluent-plugin-record-modifier>`_ を用いて、

* ログが発生したホスト名を `host` として
* 元々のタグ (fluent.warnなど)を `original_tag` として

recordに追加しています。これを入れておかないと、どこのfluentdのログか全く分からなくなるので強くオススメします。

その後、watcherノードに送出します。

***************
watcherノード用
***************

.. code-block:: none

    <match internal.message>
      type       filter
      all        allow
      deny       message: /^detected rotation of/, message: /^following tail of/, message: /^out_forest plants new output/
      add_prefix filtered
    </match>

    <match filtered.internal.message>
      type              suppress
      interval          10
      num               2
      attr_keys         host,message
      remove_tag_prefix filtered.
      add_tag_prefix    suppressed.
    </match>

    <match suppressed.internal.message>
      type     irc
      host     irc.domain
      channel  notify
      message  notice: %s [%s] @%s %s
      out_keys original_tag,time,host,message
    </match>

やっていることは

1. `fluent-plugin-filter <https://github.com/muddydixon/fluent-plugin-filter>`_ で不必要なログを弾く
2. `fluent-plugin-suppress <https://github.com/fujiwara/fluent-plugin-suppress>`_ で連続して流れてきたログをまとめる
3. `fluent-plugin-irc <https://github.com/choplin/fluent-plugin-irc>`_ でircに送信

特に凝ったことはやっていないのですが、この辺りをやっておかないとログの量が爆発して、流しても追いきれなくなります。

後は、 `fluent-plugin-notifier <https://github.com/tagomoris/fluent-plugin-notifier>`_ による通知も入れたいなと妄想しています。

以上の設定をしておくと、ircでは次のように表示されるようになります。

.. code-block:: none

   12:06  fluentd: [11:10:24] notice: fluent.error [2013/04/27 02:10:12] @serializer.domain forward error: queue size exceeds limit
   12:06  fluentd: [11:10:24] notice: fluent.warn [2013/04/27 02:10:16] @serializer.domain emit transaction failed

これで各ノードに入って直接ログをみる必要がなくなりますね

**********************
自作プラグインから流す
**********************

何かしらプラグインを書いている人は多いと思いますが、プラグインからもログを流すことができます。

上記の設定と組み合わせることで、プラグインからの任意のメッセージを受け取ることができて大変捗ります。

.. code-block:: none

   $log.warn("hoge")

例として、私のところでは `in_tail` を継承して少し手を入れたものを使っているのですが、パースに失敗した場合にメッセージを流すことで検知しています。

.. [1] まだの方はGWの間にお願いします

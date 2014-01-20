#####################################################################
fluentdのoutputプラグインでブロックするものはBufferedOutputを使うべき
#####################################################################



.. author:: default
.. categories:: Programming
.. tags:: fluentd
.. comments::


*****
tl;dr
*****

タイトルのまま

.. more::

******
前置き
******

fluentdクラスタのあるノードにだけ、そのノードに送信しているout_forwardがdetachされ続けるという症状が出ました。

調査したところ、外部への通知用に追加したhipchatプラグインを追加したところで症状が発生するようです。

****
原因
****

BufferedOutputプラグインでの `write` メソッドでのスタックトレースはこんな風になります。

::

    /home/choplin/git/fluentd/lib/fluent/buffer.rb:296:in `write_chunk'
    /home/choplin/git/fluentd/lib/fluent/buffer.rb:276:in `pop'
    /home/choplin/git/fluentd/lib/fluent/output.rb:309:in `try_flush'
    /home/choplin/git/fluentd/lib/fluent/output.rb:131:in `run'

一方、Outputプラグインでの `emit` メソッドでのスタックトレースはこんな感じ。

::

    /home/choplin/git/fluentd/lib/fluent/match.rb:36:in `emit'
    /home/choplin/git/fluentd/lib/fluent/engine.rb:151:in `emit_stream'
    /home/choplin/git/fluentd/lib/fluent/plugin/in_forward.rb:133:in `on_message'
    /home/choplin/git/fluentd/lib/fluent/plugin/in_forward.rb:185:in `feed_each'
    /home/choplin/git/fluentd/lib/fluent/plugin/in_forward.rb:185:in `on_read_msgpack'
    /home/choplin/git/fluentd/lib/fluent/plugin/in_forward.rb:173:in `call'
    /home/choplin/git/fluentd/lib/fluent/plugin/in_forward.rb:173:in `on_read'
    /home/choplin/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/cool.io-1.1.1/lib/cool.io/io.rb:108:in `on_readable'
    /home/choplin/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/cool.io-1.1.1/lib/cool.io/io.rb:170:in `on_readable'
    /home/choplin/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/cool.io-1.1.1/lib/cool.io/loop.rb:96:in `run_once'
    /home/choplin/.rbenv/versions/1.9.3-p194/lib/ruby/gems/1.9.1/gems/cool.io-1.1.1/lib/cool.io/loop.rb:96:in `run'
    /home/choplin/git/fluentd/lib/fluent/plugin/in_forward.rb:81:in `run'

ここで注目すべきは `in_forward.rb:133:in `on_message'` で、これは `Engine.emit_stream(tag, es)` の呼び出しです。つまりOutputプラグインの `emit` はInputプラグインの `Engine.emit` から(複数のメソッド呼び出しを経て)直接呼び出されています。

その為、Outputプラグイン `emit` でブロックする処理が入ると、その間in_forwardのイベントループがブロックされることになります。

in_forwardのイベントループはout_forwardの死活監視のheartbeat packetへの返信にも用いられているため、イベントループがブロックされることでheartbeatを返せなくなり、detachされるというわけです。

実際に私の環境でhipchatプラグイン `emit` で行っている処理の時間を測ったところ、平均で0.7sec、たまに3secを超えてタイムアウトする、という状況でした。これ位の値だとOutputではダメで、BufferedOutputにすべきなのでしょう。

********
解決方法
********

BuffereOutputに変える。Outputプラグインのまま回避するなら、ブロックしない処理に変えるか、out_forwardのheartbeatまわりのパラメータを調整すれば何とかなるかもしれません。

特に通知系のプラグインでは通知の即時性を担保するためかOutputプラグインを用いているケースが多いようですが、この問題にはまりやすいように思うので気をつけて下さい。

追記
====

@kazegusuri氏の `fluent-plugin-bufferize <https://github.com/sabottenda/fluent-plugin-bufferize>`_ を使うと、Outputプラグインはそのままでも、前段にbufferを挟むことができます。痒いところに手が届く素晴らしいプラグインですね。

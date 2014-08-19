###################################################
fluent-plugin-event-snifferというプラグインを書いた
###################################################



.. author:: default
.. categories:: Programming
.. tags:: fluentd
.. comments::

******
tl;dr;
******

fluetndに流れているイベントをWeb UI上で確認できる fluent-plugin-event-sniffer というプラグインを書いた。

https://github.com/choplin/fluent-plugin-event-sniffer


.. more::


概要
====

以前、コマンドラインからfluentdのイベントを見ることができる、 `fluent-tailというツールを書いた <http://chopl.in/log/2014/03/06/introduction_of_fluent_tail.html>`_ んですが、Webアプリ版が欲しいという声がチラホラあったので作りました。


デモ
====

.. raw:: html

   <iframe width="480" height="320" src="//www.youtube.com/embed/_ykzeP2xGNg?rel=0" frameborder="0" allowfullscreen></iframe>

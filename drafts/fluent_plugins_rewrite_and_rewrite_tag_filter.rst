#######################################################################
fluent-plugin-rewriteのメモリリークの話とrewrite-tag-filterで解決した話
#######################################################################



.. author:: default
.. categories:: Programming
.. tags:: fluentd
.. comments::

******
まとめ
******

rewriteでメモリリークが発生したらrewrite-tag-filterを試しましょう

********
あらすじ
********

ある日、メモリリークが起きてOOM Killerにfluentdが殺されました。プラグインを１つずつ外して原因を調べたところ、 `fluent-plugin-rewrite <https://github.com/kentaro/fluent-plugin-rewrite>`_ を外したところでリークが出なくなりました。

rewriteが使えないと困るので、同じようなプラグインである `fluent-plugin-rewrite-tag-filter <https://github.com/y-ken/fluent-plugin-rewrite-tag-filter>`_ に置き換えたところ、メモリリークもなく機能的にも以前と同じことが実現できて丸くおさまりました。めでたしめでたし。

************
リークの様子
************

********
注意事項
********

rewriteのコードを読んだわけではないので、リークの直接の原因は分かっていません。自分のケースではrewrite-tag-filterへの置き換えで決着が着いてしまったので。

ですので、どういう条件でrewriteでリークが発生するかは分かりませんし、rewrite-tag-filterでリークが発生しないかも分かりません。ご注意を。

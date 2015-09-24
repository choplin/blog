+++
title = "fluent-plugin-event-snifferというプラグインを書いた"
date = "2014-07-28"
categories = ["Programming"]
tags = ["fluentd"]
+++

tl;dr;
------

fluetndに流れているイベントをWeb UI上で確認できる fluent-plugin-event-sniffer というプラグインを書いた。

<!--more-->


<https://github.com/choplin/fluent-plugin-event-sniffer>

<!--more-->


### 概要

以前、コマンドラインからfluentdのイベントを見ることができる、 [fluent-tailというツールを書いた](http://chopl.in/log/2014/03/06/introduction_of_fluent_tail.html) んですが、Webアプリ版が欲しいという声がチラホラあったので作りました。

### デモ



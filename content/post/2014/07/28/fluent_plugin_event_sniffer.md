+++
aliases = ["/blog/2014/07/28/fluent_plugin_event_sniffer.html"]
title = "fluent-plugin-event-snifferというプラグインを書いた"
date = "2014-07-28"
categories = ["Programming"]
Tags = ["fluentd"]
+++

<!--more-->

## tl;dr;

fluetndに流れているイベントをWeb UI上で確認できる fluent-plugin-event-sniffer というプラグインを書いた。

<https://github.com/choplin/fluent-plugin-event-sniffer>

## 概要

以前、コマンドラインからfluentdのイベントを見ることができる、 [fluent-tailというツールを書いた](http://chopl.in/blog/2014/03/06/introduction_of_fluent_tail.html) んですが、Webアプリ版が欲しいという声がチラホラあったので作りました。

## デモ

<iframe width="480" height="320" src="//www.youtube.com/embed/_ykzeP2xGNg?rel=0" frameborder="0" allowfullscreen></iframe>

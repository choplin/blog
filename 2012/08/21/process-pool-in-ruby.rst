##################
RubyでProcess Pool
##################



.. author:: default
.. categories:: Programming
.. tags:: Ruby
.. comments::

Summary
=======

RubyでProcess Poolを簡単に作れるクラスを書いてみました。Ruby歴は浅いのでアホな書き方をしているかもしれません。ツッコミ歓迎。

.. more::


Motivation
==========

Rubyは1.9からNative Threadにはなったんですが、GVLがあって結局コア数でスケールしないし、Multi Processで速度をかせぐライブラリがもっとあってもよさそうなんですが、あまり見つからないので自分で書くことに。

(組み込みライブラリはGVLを解放するものがあるそうなんですが、gemにあるのは対応していないものが多いような)

`grosser/parallel <https://github.com/grosser/parallel>`_ はあるんですが、配列の並行処理に機能を絞っているので用途に合わなかったのです。がっつり一枚岩で外部から触りにくいので、もう少し細かい要素に分けてほしいところですね。

Usage
=====

使い方はこんな感じです

.. code-block:: ruby

    require 'process_pool'
    
    class MyWorker < ProcessPool::Worker
      def initialize
      end
    
      def work(item)
        puts item
      end
    end
    
    pool = ProcessPool.new(8, worker_class:MyWorker)
    pool.start
    100.times do |n|
      pool.enqueue n
    end
    pool.wait
    
    while 
    
    pool.stop

* ProcessPool::Workerの子クラスを作成
    * workで処理内容を実装
* newで子プロセス生成
    * 引数は子プロセス数とワーカークラス
* startで処理を開始
* enqueueは処理待ちキューにデータを投入
    * このデータがworkに渡される
* waitはキューが空になるまで待つ
* stopは子プロセスをkill

Misc
====

* 一応ワーカーが返してきた結果を取得できるようにしてあるんですが、順番は保存されません

Code
====

.. raw:: html

    <script src="https://gist.github.com/choplin/3416408.js"></script>

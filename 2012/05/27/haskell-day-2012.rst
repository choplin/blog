################################
Haskell Day 2012に行ってきました
################################



.. author:: default
.. categories:: Programming
.. tags:: Haskell, Event
.. comments::

Haskell Day 2012
================

「すごいHaskellたのしく学ぼう」の発売を記念して開催された `Haskell Day 2012 <http://partake.in/events/ab7f77b4-7541-47a4-867d-21a096ca883c>`_ に参加してきました。

発表の内容は入門から応用まで、笑いもあれば学術研究のガチ発表まで多岐に渡っており、まさにHaskell尽くしの一日でした。

.. more::

感想
====

Haskellのイベントにも関わらず(と言っては失礼ですが)180人近くが集まる大規模なイベントでした。Haskellの存在感は日毎に増しているようです。

しかし、個人的な感触ですが、@Lost_dog_さんの発表にありましたが、Haskellは近頃の注目度に反して実用レベルのコードを書いている人はあまりいないように思います。(私が正にそうなのですが、、、)

今回の発表ではGlossやYesodのライブコーディングやPersistentの紹介、（私は理解できませんでしたが）学術的な利用など、実践に近い発表も多く、とてもいい刺激になりました。

SPJの理念にあるように、Toy言語ではなく実践言語としてHaskellを使えるようになるように、少しずつ精進していこうと思います。

他の方の感想など
================

- `Haskell Day 2012 - Togetter <http://togetter.com/li/310866>`_
- `Haskell Day 2012に行ってきました - Logic Dice <http://d.hatena.ne.jp/a-hisame/20120527/1338124591>`_

各発表の感想&メモ
=================

メモは全体的に飛び飛び&不正確なので参考程度に。Togetterや他の方の記事で補完して下さい。

すごいHaskellたのしく裏話 by @tanakhさん
----------------------------------------

資料: `すごいHaskellたのしく裏話！ <http://tanakh.jp/pub/haskell-day-2012-05-27.html#1>`_

「すごいHaskellたのしく学ぼう」の翻訳の裏話でした。

原著ではなるべく飽きさせない為にジョークなどの言い回しが多く含まれており、そこを自然に日本語に持ってくるのに苦労したそうです。

e.g) "Texus Ranges" (Texus Rangersという野球チームがあるそう) -> "レンジでチン！"

また訳語の対応なども初心者を置いて行かないように気を使ったとのことでした。

e.g.) map over -> 持ち上げでいい？

"As Pattern"は"Asにゃんぺろぺろパターン"だそうです。

スタートHaskellとHaskellの歴史 by @Lost_dog_さん
------------------------------------------------

SPJによる `Escape From the Ivory Tower: The Haskell Journey, From 1990 to 2011 <http://yow.eventer.com/events/1004/talks/1054>`_ の発表内容の紹介でした。元資料もググれば公開されています。

- Haskellは話題性はすごいのに誰も使ってない
- 一般に研究用の言語は長くても3-5年で消えてしまう
- CとかPerlは一気に使われる
- Haskellは委員会で策定している
    - そういう言語は流行らない
- Haskellは2010年位に急に広まってきた
- 最近になってcabalとかhaskell platformなどが揃ってきた
    - 割と使える言語になってきた
- Haskellの歴史をたどるとLispの誕生に 1960年
- それを受けて1970-80頃に関数型言語の色々なアイデアが
    - パターンマッチング
    - 内包表記
    - 何よりも遅延評価
- Backus Turing Award 1977
    - 関数型言語の夢を語った論文
- その結果オレオレ言語の乱立
    - 特に遅延評価を備えたもの
- 遅延評価の関数型言語の統一が必要では by John and Simon
- FPCA 1987でlazy functional languageの統合について
    - 教育 研究 実用に最適なこと
    - 文法が形式的に定義されていること
    - 自由に利用できること
- 1990/4/1にHaskell 1.0 が誕生
    - 図らずもエイプリルフール
- Avoiding Success at all costs
    - Haskellの相反する二つの目標
        - Toy言語にさせたくない
        - 実用に耐えうるものにしたい
            - その為に色々なユーザーに実際使ってもらいたい
                - だが増えすぎると下位互換を保つ必要が出てくる
    - 多すぎず少なすぎずを目指す
        - 寛容で新しい技術が好き
- deep, simple princples
    - purity and layziness
    - type class
- なんで最近はHaskell人気なの?
    - 抑えきれ無くなってきた
- スタートHaskell2の紹介
    - すごいHaskellを題材に

Vimの開発環境 by @eaglemtさん
-----------------------------

Vimで快適にHaskellをプログラミングするために作ったプラグインの紹介でした。

私は全部導入済みでした。ありがとうございます。

- ghc-mod
    - https://github.com/eagletmt/ghcmod-vim
    - コンパイルエラーなどをquickfixに表示
    - GhcModCHeck
        - ghcからのコンパイルエラー、警告をquickfixに表示
    - GhcModCheckAsync
        - 非同期にチェックできる
    - GhcModLint
        - hlintからの提案をquickfixに表示
    - GhcModType
        - カーソル位置の型を表示
- neco-ghc
    - https://github.com/ujihisa/neco-ghc
    - オムニ補完を行う
    - neocomplcacheを導入することで自動補完が可能に
- unte-haddock
    - https://github.com/eagletmt/unite-haddock
    - Uniteインターフェースでモジュールのドキュメントを閲覧
    - Unite hoogleも提供

Emacsとglossでお絵描きしてみるよ by @master_qさん
-------------------------------------------------

資料: `EmacsとGlossでお絵描きしてみるよ <http://www.slideshare.net/master_q/emacsgloss>`_

描画ライブラリの `gloss <http://gloss.ouroborus.net/>`_ を用いたライブコーディングでした。

Emacs + ghc-modを用いた流れるようなコーディングが見事でした。あの短時間で動くところまで持っていけるのはすごいです。

- インストール
    - apt-get- install ghc-mod
    - cabal install gloss
- 参考書
    - Preludeのhaddock
    - Glossのhaddock
    - Hoogle

cabal の使い方と dependency hell by @khibinoさん
------------------------------------------------

Haskellのモジュール管理ツールであるcabalの紹介と、問題点の解説でした。

私はcabal問題にはまったことはないのですが、本格的に使い出すとよく直面するそうです。

- cabal
    - 便利
    - モジュールはHackageに蓄積されている
- 使い方
    - cabal install {package name}
    - 上手くいったらOK
- 問題点
    - 依存解決
        - B: C,D >= 1に依存
        - A: 1 <= C < 2、 B >= 1に依存
        - Bをインストールした際にC@2がインストールされる
        - その後にAをインストールすると、C@2ではAが動かないので、Bのインストールをやり直すことに
        - 必要なバックトラックの回数が多くなりすぎる
        - 解決
            - バックトラック回数を明示的に指定 --max-backjumps
            - --dry-run
    - 壊れる依存関係
        - B: 1 <= C < 2, D >= 1
        - A: C >= 2
        - Bの後にAをインストールするとBが壊れる
        - 解決法
            - 同時にインストールする
            - 個別にバージョンを指定することも可能
- Debianを使おう
    - Debianのパッケージシステムが依存関係を壊さないように保ってくれる
- まとめ
    - cabalは便利
    - 複雑な依存関係をcabalだけで解決するのは大変
- 次のcabalでは対応が盛り込まれている

Yesod の紹介とライブコーディング by @seizansさん
------------------------------------------------

資料: `20120527yesod <http://www.slideshare.net/ssuser6c06ba/20120527yesod>`_

最近話題によく上がるWAFのYesodを用いたライブコーディングでした。ご結婚おめでとうございます。(※驚きのHaskellerご夫婦だそうです)

- Haskell初心者勉強会

- プログラミンができるようになるには? @mayahjp
    - 関数型言語を勉強する
    - Haskellがいいのでは
- Yesodを始めたきっかけは？
    - 結婚が決まったので
    - 二次会サイトをYesodで作成
- Yesod
    - メリット
        - デフォルトで書くと安全な感じになる
        - コンパイルが通れば実行時エラーは少ない
        - セキュリティ関係をデフォルトでちゃんとやってくれる
            - XSS, CSRF, SQLi, セッション・ハイジャックなど
    - デメリット
        - 型が難しい
        - <del>セキュリティ関係が今ひとつ</del>
            - <del>XSS, CSRF, SQLi, セッション・ハイジャックなんかは大丈夫</del>
    - スケーラブル
        - セッションがスティッキーではないので

Haskell status update by @shelarcyさん
--------------------------------------

Haskell Platformの次バージョン2012.2.0.0で入る予定の機能の紹介でした。

5/30にリリース予定だそうです。楽しみですね。 `2012.2.0.0 final count down <http://projects.haskell.org/pipermail/haskell-platform/2012-May/001906.html>`_

- Haskell Platform 2012.2
    - GHC 7.4
    - cabal-install 1.14
    - alex 3.0.1
- GHC 7.4
    - 日本語対応の強化
    - スタックトレース
    - モナド内包表記
        - 要MonadPlusのインスタンス
        - GHCの言語拡張にも対応
            - 並列内包表記
            - 一般化(SQL風)リスト内包表記
        - シンタックスシュガーを解く前のエラーを出せるようになったので
- cabal-install
    - solverの改良
        - dependency-hellの解決
    - 他にmultiple instanceの許可なども模索されている
        - モジュールやパッケージに型システムを
    - benchに対応
        - cabal test相当
- alex
    - haskell用のlexical analyzer generator
    - 3.0でUTF8対応
- 利用環境の拡充
    - 2011.4
        - Mac OS X64bit 対応
        - Lion対応
- ライブラリ
    - containers 0.5
        - Data.Mapなどの不必要な互換性を解消
        - 正格評価版、遅延評価版の区別

Haskell で Behavior Driven Development by @kazu_yamamotoさん
------------------------------------------------------------

Haskellでいかにテストを書いていくかという話でした。

doctestにHUnit/QuickCheckがその内揃うそうです。便利そうですね。

- Haskellerはあまりテストを書かない！
    - コンパイルが通れば大体思い通りに動く
- 静的片付け言語では同じでは？
    - 一般的な言語と関数型言語では違う
        - コンパイル時にエラーを見つけられる
            - sezyな型システム by SPJ
- Haskellでは全てが式
    - LispやRubyもそう謳っているが式を文として利用することがある
    - 文と文の型の関係は検査されない
        - Haskellではあらゆる場所で検査される
- 型システムを台無しにするものがない
    - 言外の型変換
    - スーパーな型
    - スーパーなデータ
- コンパイルが通れば大体思い通りに動く
- とはいえ値に関する間違いはある
    - HUnitは面倒なので
    - QuickCheckにコーナーケースを見つけさせる
- QuickCheckとは
    - 関数の性質をを記述する
    - 純粋な関数は性質を見つけやすい
        - 訓練すれば表現できるように
- Haskellは型を見れば純粋かどうか分かる
    - 右にIOがあるか
    - 純粋な関数
        - QuickCheck
    - 純粋でない関数
        - HUnitがオススメ（だった）
- ビューティフルコード
    - ビューティフルテスト
        - 二分探索に対するテスト
- 美しきテストたち
    - スモークテスト
    - 境界テスト
    - ランダムテスト
    - 突然変異テスト
- QuickCheckがあればこれらのテストは冗長
    - 仕様はモデル実装と同じと表現するだけ
        linearSearch = binarySearch
- 本当にQuickCheckでテストしてるの？
    - テストをしたくなる仕組みが必要
- doctest
    - pythonのドキュメントに使用例を書く仕組み
        - 実はあまり使われていないらしい
- Haddock
    - コメントの中にドキュメントを書く
- コードブロックは使えるか?
    - 利用例用のマークアップと
    - 性質用のマークアップが必要
        - \>\>\> を導入
- doctestの実装
    - Haddockから利用例を切り出す
    - GHCiで評価 文字列で結果を比較
        - 0.7では爆速
- 性質用のマークアップ
    - prop> を導入
        - パラメータのある性質は無名関数で
        - prefixは省略可
    - その内利用可に
- どうやってprefixを補うか
     - GHCiが教えてくれる
- doctestによる設計、ドキュメント、自動テストの一体化
- doctestに載せるべきではない利用例/性質は？
    - チケットが切られたケース
- HSpec
    - BDDとは
        - TDDのテストコードを仕様書の言葉で書く
    - Haskellには振る舞いという言葉は不適切かも
    - IOのsetupとteardownは
        - 高階関数で
        - いわゆるローンパターン


見た目は指数、中身は線形。〜GTAプログラミング、by 江本さん
----------------------------------------------------------

元論文: `http://www.keisu.t.u-tokyo.ac.jp/research/techrep/data/2011/METR11-01.pdf <http://www.keisu.t.u-tokyo.ac.jp/research/techrep/data/2011/METR11-01.pdf>`_
資料: `emoto / GTALib / source — Bitbucket <https://bitbucket.org/emoto/gtalib/src/79bf1de583bb/slides>`_

感動しました。二乗の計算量(の様に見えるコード)で書くと、内部でDPに変換されて線形の計算量になるという、魔法のようなGTAライブラリの紹介でした。

計算をDPに変換するところは全く理解できませんでしたが、利用するだけであれば何とかなりそうです。

近いうちに使ってみたいと思います。

- GTAプログラミング
    - 見た目は指数コストのプログラムを書くと
    - 中身は線形コストで効率的に計算してくれる
    - おまけに並列で動いてくれる
    - ESOP2012で発表
- インストール
    - cabal install GTAlib
    - ソースコードはbitbucketに
- 例題 0-1 ナップサック問題
    - 愚直な解き方
        - 全ての選択肢を生成
        - 容量制限を超える選択肢を排除
        - 金額が最大のものを選択
    - GTAではそのまま書く
- GTAプログラミング
    - 問題をGとTとAに分割
    - G
        - 必要な解候補を全部用意
            - subsを使うか自分で再設計
    - T
        - 不必要なものを削除
            - 重さを計算して制限以下どうかチェック
    - A
        - 残りから計算
            - 価値の合計を計算し最大のものを出力
            - 既存のものか自分で再設計
- Generatorの用意
    - 基本はライブラリにあるものを適宜選択
        - segs
        - inits
        - tails
        - subs
    - 必要なら自分で再設計
    - ナップサックの場合
        - subs
- Testerの用意
    - フィルタの為の述語を設計する
        - 破棄したいリストに対してFalseを返す
    - joinList上の準同型 + 軽い計算 とする
        - joinList上の準同型hは単純なDevide & Conquerで、結合的な演算子 `times` と、適当な関数singleと、 `times` の単位元Nil
    - 準同型の値域が小さい方がいい
    - ナップサック問題では
        - 1
            - 与えられた荷物の選択の重さの想話を求め
            - それが宣言w以下であるか調べる
        - 2
            - w+1以上の数値は不要
        - 3
            - 準同型を決める演算子の定義に機械的に書き換え
- Aggregaterの用意
    - 基本的にはライブラリにあるものを試用
        - result
        - count
        - maxsumWith
        - maxsumsolutionWith f
        - maxprodWith f
        - maxprodsolutionWith f
        - maxsumsolutionKWith f
    - 必要なら自分で設計
        - セミリング準同型な関数
    - ナップサック問題であれば
        - maxsumsolutionWith getValue
- ナップサック問題 改
    - 価値30以上の荷物は高々ひとつという条件を追加
        - Testerに追加
- 中で起こっていること
    - テーブルを作成
        - マージする
        - 要はDP
        - 計算の構造はGから継承
        - テーブルの構造と演算はTAから継承
    - 2つの変換
        - Filter-emgedding
        - Semiring Fusion
- 応用例
    - Viterbi score/pathの計算
    - Assemply-lin scheduling
    - 最長連続部分列を探す
    - etc.
- Q&A
    - DP以外のアルゴリズムへ適用できるか？
        - いま研究中。述語の変換を利用しているアルゴリズムであれば恐らくできるのでは。


Persistentの使い方 by @rf044さん
--------------------------------

Yesodに付属のDBライブラリPersistentの紹介でした。

Scalaのコードを書いていて感じたのですが、静的型付け言語でRDBを触っていると、SQLエラーが実行時にしか分からないのが非常に気になります。
Persistentであれば型安全にアクセスできるそうなので試してみようと思います。(とはいえ、引換にSQLのパワーをスポイルされると私にとっては意味がないのですが）

- Persistent
    - Yesodを入れると付いてくる
    - DB部分
    - 型安全
- インストール
    - cabao install persistent-template
        - cabao install persistent-sqlite
        - cabao install persistent-mongodb
        - etc.
- DBへ接続
- Modelの定義
    - YesodのModelを使いたい
        - importにYesodに依存する部分があるので切り離したい
- Migrationもある

参照透過性とは何だったのか by @ruiccさん
----------------------------------------

資料: http://www.slideshare.net/RuiccRail/haskell-day2012

関数型言語について話す際によく話題に上がる参照透過性。これはアカデミックな概念のみではなく、実際のプログラミングにも非常に役立つ性質であるという話でした。

- Haskellこわい
    - CSの結晶
    - 巨人の肩に乗っている
- 対象
    - 強い片付け
    - 静的型付け
    - 参照透明
- 純粋関数型言語
    - (純粋 && 実用的) な言語
- 参照透明性
    - 引数のみで決まる
    - 引数が同じなら返り値が同じ
        - 強い制約
- よくある説明
    - メモ化が容易
    - マルチコアプログラミングが容易
- それより実際に何が得られるのか
- 型と参照透明性
    - 関数と型
        - モナドはコンテクスト
    - 設計とモナド
        - 既存のモナドを組み合わせ必要なコンテクストを作る
            - モナド変換子
    - 型に依存関係があらわれる
- 設計と参照透過性
    - 型を決めることが設計
        - 設計がソースコードに表れる
- 抽象化と参照透過性
    - 直行した部品を組み合わせるのが理想
        - IOを見れば参照透過か分かる
        - コンビネータ
        - 高いパフォーマンス
- テストと参照透過性
    - 型で何とかする
    - 値のテスト
- 参照透過性すごい
    - 参照透過性を持つHaskellを使おう

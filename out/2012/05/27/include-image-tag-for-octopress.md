+++
title = "Octopressで設定したディレクトリの画像を表示するプラグインを書いた"
date = "2012-05-27"
categories = ["Programming"]
tags = ["Octopress"]
+++

HowTo
-----

_config.ymlにディレクトリを書いて

``` sourceCode
image_dir: images/blog
```

ファイルを指定すると

``` sourceCode
{% include_img test.jpg %}
```

imgタグになります

``` sourceCode
```

この場合 {octopress_path}/sources/images/blog/test.jpg に画像を置いておけばオッケーです。

<!--more-->


Why
---

画像は特定の場所に置きたいので、画像URLのprefixを設定したいのですが、 標準のimageプラグインはURLでしか指定できないので作りました。

標準のプラグインを少し書き換えただけなので、作ったというにはおこがましいですが。

もしかしたら既存の機能でできたのかもしれませんが、情弱の私は作ったほうが早かったようです。

Code
----



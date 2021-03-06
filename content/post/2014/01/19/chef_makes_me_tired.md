+++
aliases = ["/blog/2014/01/19/chef_makes_me_tired.html"]
title = "chefの辛み"
date = "2014-01-19"
categories = ["Programming"]
tags = ["chef"]
+++

<!--more-->

**※注: chefがクソだというつもりは毛頭なくて、我々のツールの選定や運用の方法が間違っている気がするという話です**

現在、社内の構成管理ツールにはchefを使っています。使い始めて一年ちょっと経つんですが、色々と辛いと感じる部分が出てきたのでまとめておきます。



## 前提

- ノードの数は150程度、種類は15程度
- cookbookは40程度
- chef serverを使用
- chef-clientの実行は手動で行っている。意図しない変更が本番に入るのを防ぐため。
- 一部まだの部分はあるけど大体の構成の管理はchefに移行出来ている
- まだの部分もchef管理へ移行することが推奨されている
- 運用で必要になることが多いので、サーバーでの直接の変更は禁止されていない

## 辛み

### chef-clientが遅い

今適当なサーバーで測ったら、適用するものがない状態で20秒弱かかりました。実行前にwhy runで差分を確認するようにしているので、この時間分は必ず待たされることになります。

時間がかかっているcookbooksのcompile、ついでyumなどの一部遅いresourceな感じです。後者はしょうがない気もしますが。

### 最終的にどういう状態になるか把握しにくい

chefは大変柔軟に設定ができるんですが、その半面、結局サーバーがどういう状態になる設定なのか、chefリポジトリの内容を眺めているだけでは分かりにくくなっているように感じます。

分かりにくくなる要因としては、以下のようなところでしょうか。

- run_listが複数箇所(node, role)で設定できる
- run_listに設定できる要素が複数(role, recipe)ある
- recipeを集約する方法が複数(run_list, include_recipe)ある
- attributeの設定箇所が複数ある
- 内部DSLなのでrubyで何でもできてしまう

chefのリポジトリを見通しのいい状態に保つためには利用方法に合わせた運用ルールをチームで共有する必要があるのではないかと思うのですが、そもそもコードに残らない運用を減らすために構成管理ツールを導入したので、そういったルールは最小限に留めたいです。berkshelfなどの運用方法をある程度強制するツールを導入すれば楽になるかも。

### node, roleの内容がweb UIから設定できる

言いがかりなんですが、node、roleはweb UIから設定できるので、chefリポジトリにない設定を入れてしまうことが可能です。そうなってしまうと、サーバーの状態の追跡が、chefリポジトリのみからでは分かりにくいだけでなく不可能になってしまう。運用ルールで禁止すればいいんですが同上。

### その他

他、細かいところだと

- run_listの一部の適用が若干やりにくい
- 変更したrecipeがどのnodeに適用されるかが分かりにくい (knifeのクエリでできるかも。利用してないのですが。）
- chefリポジトリの状態がgitとchef serverの二重管理になっているのでまとめたい。hookかけてuploadしてもいいかもしれない。

## まとめ

この記事を書いていて思いついたのはこんなところでしょうか。思いつくままに書いたので余りまとまったないですが。

冒頭に書いたようにdisるつもりは全くなくて、むしろそのやり方間違っているからこうしろというのを教えて欲しいです。

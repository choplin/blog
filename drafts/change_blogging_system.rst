#####################################################
BlogシステムをTinkerer + AWS + drone.ioに入れ替えた話
#####################################################



.. author:: default
.. categories:: Programming
.. tags:: blog
.. comments::

ここしばらくの空いた時間でブログのシステム構成を大幅に入れ替えました。主な目的は静的ページの生成システムを `Octopress <http://octopress.org/>`_ から `Tinkerer <http://www.tinkerer.me/>`_ に乗り換えることですが、それに併せてホスティングを `Amazon S3 <http://aws.amazon.com/jp/s3/>`_ に、デプロイを `GitHub <https://github.com/>`_ + `drone.io <https://drone.io/>`_ を使うようにしました。

詳細は各記事に

* :ref:`octopress_to_tinkerer`
* :ref:`blog_hosting_with_aws_s3`
* :ref:`deploying_blog_with_github_and_drone_io`

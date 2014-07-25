*****************************************************************
RHEL6系でansibleを使うならrecord_host_keysをFalseにすると速くなる
*****************************************************************



.. author:: default
.. categories:: Programming
.. tags:: ansible
.. comments::

tl;dr;
======

タイトルの通り。RHEL6系なのでCentOS6、ScientificLinux6なども該当。

.. more::

Pramiko
=======

ansibleは各ホストとの接続にはsshと使います。この時、sshにはControlPersistという機能に対応していることが必要で、opensshならバージョン5.6以上が対象です。ansibleのデフォルトの動作では、PATH上のsshコマンドがControlPersistに対応していればsshを使い、そうでない場合はparamikoというpythonのsshライブラリが用いられるようになっています。

RHEL6系のopensshはバージョン5.3の為、何も設定せずに使うとparamikoが用いられます。

Paramikoが遅い
==============

ところがこのparamikoを用いたansibleの実行はかなり遅いです。どの程度遅いかは末尾を参照。特に台数が多い場合にその影響が目立ち、forkを増やして実行してもあまり速く感じないです。

ansibleコマンドを実行した時に、どこが遅いかコードを辿って行くと

1. `Runner#run <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/bin/ansible#L186>`_
2. `_parallel_exec <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/__init__.py#L1268>`_
3. `multiprocessing.Processをtarget=_execution_hookで実行 <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/__init__.py#L1180>`_
4. `_executor <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/__init__.py#L78>`_
5. `_executor_internal <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/__init__.py#L558>`_
6. `_executor_internal_inner <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/__init__.py#L687>`_
7. `Connection#close <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/__init__.py#L910>`_
8. `hostkeyの追加処理 <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/connection_plugins/paramiko_ssh.py#L337>`_

の辺りがボトルネックになっていることが分かりました。

対応
====

ansible.cfgでrecord_host_keysをFalseに設定すると、`このif <https://github.com/ansible/ansible/blob/4a8e0688555e7dcccb84732962d00af0b8274431/lib/ansible/runner/connection_plugins/paramiko_ssh.py#L325>`_ の分岐でConnection#closeのhostkeyの処理をまとめて飛ばせるので、かなり高速化します。



もしくはこの処理はparamiko特有の処理なので、sshを接続に用いれば影響はなくなります。

諸々検証が済んだ後に気づいたのですが、実はそのあたりのことは `公式ドキュメント <http://docs.ansible.com/intro_configuration.html#record-host-keys>`_ に書いてあります。


速度
====

50ホストを対象に、copyを中心に10タスクずつのplaybookの実行時間

Paramiko record_host_keys=True
------------------------------

::

    real    8m6.174s
    user    8m59.837s
    sys     0m14.554s

Paramiko record_host_keys=False
------------------------------

::

    real    1m23.947s
    user    1m54.972s
    sys     0m10.593s

OpenSSH 6.6p1
-------------

::

    real    0m46.788s
    user    0m43.508s
    sys     0m15.472s

opensshが一番速いですが、独自ビルドして利用するのはちょっとという場合は、record_host_keysをFalseにしておくだけでも十分な効果が見込めますね。

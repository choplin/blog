#########################################
FLunetd::MultiOutputとmonitor_agentの関係
#########################################

.. author:: default
.. categories:: Programming
.. tags:: fluentd
.. comments::

*************
monitor_agent
*************

`fluentd` v0.10.33で `in_monitor_agent <https://github.com/fluent/fluentd/commit/0f88bf02721034b1b6962cc3ec9b6bc53413c098#L0R4>`_ が追加されました。

`in_monitor_agent` は次の様なsourceを定義しておくと

.. code-block:: none

   ...
    <source>
      type monitor_agent
      bind 0.0.0.0
      port 24220
    </source>
    ...

http経由で、各pluginの内部の状態を取得することができるようになります。

.. code-block:: none

   $ curl http://localhost:24220/api/plugins
   plugin_id:object:3f8747e35fa4   type:forward    output_plugin:false
   plugin_id:object:3f8747e34c30   type:debug_agent        output_plugin:false
   plugin_id:object:3f874864f2f8   type:monitor_agent      output_plugin:false
   plugin_id:object:3f8749cf16a0   type:stdout     output_plugin:true
   plugin_id:object:3f87498b79f4   type:webhdfs    output_plugin:true      buffer_queue_length:4   buffer_total_queued_size:39798319       retry_count:0
   plugin_id:object:3f8747837580   type:forward    output_plugin:true      buffer_queue_length:0   buffer_total_queued_size:0      retry_count:0

特にBufferedOutputなpluginで内部のbufferの状態を見れるのが嬉しいですね。

値を監視して `queue size exceeds limit` が出る前にアラートを上げたり、グラフ化してピーク時にどの程度余裕があるかを測るなどの使い方ができます。

******************************************
内部で別のpluginを立ち上げるpluginとの関係
******************************************

`fluentd` のpluginは内部で別のpluginを立ち上げるものがあります。 `copy` などがそうですね。

`copy` の場合は子pluginも `monitor_agent` を通して取得することができます。

.. code-block:: none

    <source>
      type monitor_agent
    </source>

    <match **>
      type copy
      <store>
        type stdout
      </store>
    </match>

.. code-block:: none

   $ curl http://localhost:24220/api/plugins
   plugin_id:object:3fdddd23c774   type:monitor_agent      output_plugin:false
   plugin_id:object:3fdddd43e158   output_plugin:true      config:
   plugin_id:object:3fdddd43d67c   type:stdout     output_plugin:true

`copy` 内の子pluginである `stdout` もちゃんと見れてますね。

ですが、monitor_agentで見れないpluginもあります。例えば `config-expander <https://github.com/tagomoris/fluent-plugin-config-expander>`_ などがそうです。

.. code-block:: none

    <source>
      type monitor_agent
    </source>

    <match **>
      type config_expander
      <config>
        type stdout
      </config>
    </match>

.. code-block:: none

   curl http://localhost:24220/api/plugins
   plugin_id:object:3ffa68cb3f70   type:monitor_agent      output_plugin:false
   plugin_id:object:3ffa68d620fc   type:config_expander    output_plugin:true

`config-expander` 自体の状態は見れていますが、 `stdout` は表示されません。

****
原因
****

`MonitorAgentInput.collect_children` はv0.10.33時点では次のような実装になっています。

.. code-block:: ruby

  def self.collect_children(pe, array=[])
    array << pe
    if pe.is_a?(MultiOutput) && pe.respond_to?(:outputs)
      pe.outputs.each {|nop|
        collect_children(nop, array)
      }
    end
    array
  end

`pe` はoutput pluginの1つを表しています。 `array` でmonitorする対象のpluginを返却しています。

`array` にはplugin自身と、 `MultiOutput` であるかつ `outputs` を呼べる場合に子pluginを呼べる場合には、 `outputs` の中にあるpluginが追加されます。

******
解決法
******

つまり、内部で別のpluginを立ち上げる場合は、 `MultiOutput` を継承し、 `outputs` を外部から参照できる形にしておけば、 `monitor_agent` で子pluginの状態を見ることができるようになります。

`config-expander` についてはパッチを書いた（pullreq/release済み）なので参考にしてください。

.. code-block:: diff

    diff --git a/lib/fluent/plugin/out_config_expander.rb b/lib/fluent/plugin/out_config_expander.rbindex a5357b6..c040da0 100644
    --- a/lib/fluent/plugin/out_config_expander.rb
    +++ b/lib/fluent/plugin/out_config_expander.rb
    @@ -1,6 +1,6 @@
     require_relative 'expander'

    -class Fluent::ConfigExpanderOutput < Fluent::Output
    +class Fluent::ConfigExpanderOutput < Fluent::MultiOutput
       Fluent::Plugin.register_output('config_expander', self)

       config_param :hostname, :string, :default => `hostname`.chomp
    @@ -22,6 +22,8 @@ class Fluent::ConfigExpanderOutput < Fluent::Output
         ex
       end

    +  attr_reader :outputs
    +
       def configure(conf)
         super

    @@ -33,6 +35,8 @@ class Fluent::ConfigExpanderOutput < Fluent::Output
         @plugin = Fluent::Plugin.new_output(ex['type'])
         @plugin.configure(ex)

    +    @outputs = [@plugin]
    +
         mark_used(configs.first)
       end

******
まとめ
******

他のpluginのパッチはお願いします。

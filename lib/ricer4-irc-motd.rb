require "ricer4-irc"
module Ricer4
  module Plugins
    module Irc
      
      add_ricer_plugin_module(File.dirname(__FILE__)+'/ricer4/irc_motd')
      
    end
  end
end
module Ricer4::Plugins::Irc
  class IrcMotd < Ricer4::Plugin
    
    connector_is :irc

    version_is 1
    license_is :MIT
    author_is 'gizmore@wechall.net'

    def plugin_init
      arm_subscribe("irc/375") do |sender, message|
        motd = Motd.static_for_server(message.server)
        motd.text = ""
      end
      arm_subscribe("irc/372") do |sender, message|
        motd = Motd.static_for_server(message.server)
        motd.text += message.args[1] + "\n"
      end
      arm_subscribe("irc/376") do |sender, message|
        motd = Motd.static_for_server(message.server)
        arm_publish("ricer/server/save/motd", message.server, motd.text.trim)
      end
      arm_subscribe("ricer/server/save/motd") do |sender, server, line|
        unless line.empty?
          bot.log.info("Saving Message of the day for #{server.display_name}")
          motd = Motd.static_for_server(server)
          motd.text = line
          motd.save!
        end
      end
    end
    
    trigger_is :motd
    #has_usage '' and 
    has_usage '<server>'
    def execute(server=nil)
      server = server || current_message.server
      motd = Motd.for_server(server)
      rply :msg_motd, server: server.display_name, motd: motd.text
    end
    
  end
end

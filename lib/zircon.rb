require "zircon/version"
require "zircon/callback"
require "zircon/message"
require "socket"

class Zircon
  include Callback

  attr_accessor(
    :server,
    :port,
    :channel,
    :username,
    :nickname,
    :realname
  )

  COMMAND_NAMES = %w[
    ADMIN
    AWAY
    CREDITS
    CYCLE
    DALINFO
    INVITE
    ISON
    JOIN
    KICK
    KNOCK
    LICENSE
    LINKS
    LIST
    LUSERS
    MAP
    MODE
    MOTD
    NAMES
    NICK
    NOTICE
    PART
    PASS
    PING
    PONG
    PRIVMSG
    QUIT
    RULES
    SETNAME
    SILENCE
    STATS
    TIME
    TOPIC
    USER
    USERHOST
    VERSION
    VHOST
    WATCH
    WHO
    WHOIS
    WHOWAS
  ].freeze

  def initialize(args = {})
    @server       = args[:server]
    @port         = args[:port]
    @channel      = args[:channel]
    @password     = args[:password]
    @username     = args[:username]
    @nickname     = args[:nickname] || @username
    @realname     = args[:realname] || @username
    on_ping { |message| pong(message.raw) }
  end

  def run!
    login
    wait_message
  end

  COMMAND_NAMES.each do |name|
    define_method(name.downcase) do |*params|
      command(name, *params)
    end
  end

  def login
    pass @password if @password
    nick @nickname
    user @username, 0, "*", ":" + @realname
    join @channel if @channel
  end

  # Start blocking-loop.
  # Call trigger_message and trigger_xxx on a message received.
  # (xxx is determined by the command type of the message)
  def wait_message
    loop do
      message = Message.new(gets)
      trigger_message(message)
      send("trigger_#{message.type}", message)
    end
  end

  private

  def command(*args)
    write(args * " " + "\r\n")
  end

  def write(text)
    socket << text
  end

  def gets
    socket.gets
  end

  def socket
    @socket ||= TCPSocket.new(@server, @port)
  end
end

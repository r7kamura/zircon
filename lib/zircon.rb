require "zircon/version"
require "zircon/callback"
require "zircon/message"
require "socket"
require "openssl"

class Zircon
  include Callback

  attr_accessor(
    :server,
    :port,
    :channel,
    :username,
    :nickname,
    :realname,
    :use_ssl
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
    NUMERICREPLY
  ].freeze

  def initialize(args = {})
    @server       = args[:server]
    @port         = args[:port]
    @channel      = args[:channel]
    @password     = args[:password]
    @username     = args[:username]
    @nickname     = args[:nickname] || @username
    @realname     = args[:realname] || @username
    @use_ssl      = args[:use_ssl]  || false
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
      next if message == :invalid_message
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
    @socket ||= @use_ssl ? ssl_socket : tcp_socket
  end

  def tcp_socket
    TCPSocket.new(@server, @port)
  end

  def ssl_socket
    socket = OpenSSL::SSL::SSLSocket.new(tcp_socket)
    socket.sync_close = true
    socket.connect
  end
end

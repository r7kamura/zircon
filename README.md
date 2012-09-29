# Zircon
IRC client library written in Pure Ruby.

## Installation

```
$ gem install zircon
```

## Example

```ruby
require "zircon"

client = Zircon.new(
  :server   => "example.com",
  :port     => "6667",
  :channel  => "#chatroid",
  :username => "zircon"
)

client.on_privmsg do |message|
  client.privmsg "#chatroid", ":zircon!"
end

client.on_message do |message|
  puts "*** `on_message` responds with all received message ***"
  puts message.from
  puts message.to
  puts message.type
  puts message.body
end

client.run!
```

## Features
IRC has following commands.

```
ADMIN   KICK    MOTD     QUIT     VERSION
AWAY    KNOCK   NAMES    RULES    VHOST
CREDITS LICENSE NICK     SETNAME  WATCH
CYCLE   LINKS   NOTICE   SILENCE  WHO
DALINFO LIST    PART     STATS    WHOIS
INVITE  LUSERS  PING     TIME     WHOWAS
ISON    MAP     PONG     TOPIC    USER
JOIN    MODE    PASS     USERHOST PRIVMSG
```

You can use sender and receiver methods for each commands.

```
# For example about PRIVMSG
# [sender - privmsg]
privmsg("#channel", ":Hello")

# [receiver - on_privmsg]
on_privmsg {|message| puts message.body }
```

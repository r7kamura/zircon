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

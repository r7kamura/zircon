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
  :server   => "chat.freenode.net",
  :port     => "6667",
  :channel  => "#chatroid",
  :username => "zircon"
)

client.on_privmsg do |message|
  client.privmsg "#chatroid", ":zircon!"
end

client.run!
```

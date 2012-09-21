# coding: ASCII-8BIT

class Zircon
  class Message
    module Patterns
      # IRC Message Pseudo BNF code
      # http://www.haun.org/kent/lib/rfc1459-irc-ja.html
      # ------------------------------------------------
      # <message>  ::= [':' <prefix> <SPACE> ] <command> <params> <crlf>
      # <prefix>   ::= <servername> | <nick> [ '!' <user> ] [ '@' <host> ]
      # <command>  ::= <letter> { <letter> } | <number> <number> <number>
      # <SPACE>    ::= ' ' { ' ' }
      # <params>   ::= <SPACE> [ ':' <trailing> | <middle> <params> ]
      # <middle>   ::= <先頭が':'ではなく,SPACE,NUL,CR,CFを含まない、空でないオクテットの列>
      # <trailing> ::= <SPACE,NUL,CR,CFを含まないオクテットの列(空のオクッテトの列も可)>
      # <crlf>     ::= CR LF

      # unit
      DIGIT      = "0-9"
      LETTER     = "A-Za-z"
      HEXDIGIT   = "#{DIGIT}A-Fa-f"
      CRLF       = '\x0D\x0A'
      NOSPCRLFCL = '\x01-\x09\x0B-\x0C\x0E-\x1F\x21-\x39\x3B-\xFF'

      # units
      COMMAND    = "(?:[#{LETTER}]+|[#{DIGIT}]{3})"
      SHORTNAME  = "[#{LETTER}#{DIGIT}](?:[-#{LETTER}#{DIGIT}]*[#{LETTER}#{DIGIT}])?"
      HOSTNAME   = "#{SHORTNAME}(?:\\.#{SHORTNAME})*"
      SERVERNAME = HOSTNAME
      IP4ADDR    = "\d{1,3}(?:\\.\d{1,3}){3}"
      IP6ADDR    = "(?:[#{HEXDIGIT}]+(?::[#{HEXDIGIT}]+){7}|0:0:0:0:0:(?:0|FFFF):#{IP4ADDR})"
      HOSTADDR   = "(?:#{IP4ADDR}|#{IP6ADDR})"
      HOST       = "(?:#{HOSTNAME}|#{HOSTADDR})"
      USER       = '[\x01-\x09\x0B-\x0C\x0E-\x1F\x21-\x3F\x41-\xFF]+'
      NICKNAME   = "\\S+"
      MIDDLE     = "[#{NOSPCRLFCL}][:#{NOSPCRLFCL}]*"
      TRAILING   = "[: #{NOSPCRLFCL}]*"
      PARAMS     = "(?:((?: #{MIDDLE}){0,14})(?: :(#{TRAILING}))?|((?: #{MIDDLE}){14}):?(#{TRAILING}))"
      PREFIX     = "(?:#{NICKNAME}(?:(?:!#{USER})?@#{HOST})?|#{SERVERNAME})"
      MESSAGE    = "(?::(#{PREFIX}) )?(#{COMMAND})#{PARAMS}\s*#{CRLF}"

      # pattern
      CLIENT_PATTERN  = /\A#{NICKNAME}(?:(?:!#{USER})?@#{HOST})\z/on
      MESSAGE_PATTERN = /\A#{MESSAGE}\z/on
    end
  end
end

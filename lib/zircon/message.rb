require "zircon/message/patterns"

class Zircon
  class Message
    attr_reader :prefix, :command, :raw

    def initialize(text)
      if match = Patterns::MESSAGE_PATTERN.match(text)
        @text    = text
        @prefix  = match[1]
        @command = match[2]
        @rest    = match[3..-1]
      else
        raise ArgumentError.new("Invalid message")
      end
    end

    def type
      @type ||= @command.to_s.downcase
    end

    def from
      @from ||= begin
        @prefix && @prefix.split("!").first
      end
    end

    def to
      params[0]
    end

    def body
      params[1]
    end

    def params
      @params ||= begin
        params = []
        case
        when !@rest[0].blank?
          middle, trailer, = *@rest
          params = middle.split(" ")
        when !@rest[2].blank?
          middle, trailer, = *@rest[2, 2]
          params = middle.split(" ")
        when @rest[1]
          trailer = @rest[1]
        when @rest[3]
          trailer = @rest[3]
        end
        params << trailer if trailer
        params
      end
    end
  end
end

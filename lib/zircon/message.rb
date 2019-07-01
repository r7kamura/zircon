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

        puts @command.inspect
        case @command
        when /\A\Z/
          return invalid_message(text)
        when nil
          return invalid_message(text)
        when "ERROR"
          return invalid_message(text)
        end
      else
        return invalid_message(text)
      end
    end

    def invalid_message(text)
      warn "Invalid message: #{text}, skipping."
      :invalid_message
    end

    def to_hash
      {
        body: body,
        from: from,
        to: to,
        type: type,
      }
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
        when @rest.nil?
          warn "No params"
        when !@rest[0].empty?
          middle, trailer, = *@rest
          params = middle.split(" ")
        when !@rest[2].nil? && !@rest[2].empty?
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

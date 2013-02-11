class Zircon
  # You can call methods like this:
  # * list_message    : return Array of callbacks for "message"
  # * on_message      : store a given block as callback for "message"
  # * trigger_message : trigger callbacks for "message" with given args
  module Callback
    private

    def method_missing(method_name, *args, &block)
      case method_name
      when /(list|on|trigger)_([0-9]+)/
        send($1, 'numericreply', *args, &block)
      when /(list|on|trigger)_([a-z0-9]+)/
        send($1, $2, *args, &block)
      else
        super
      end
    end

    def list(type)
      callbacks[type]
    end

    def on(type, &block)
      callbacks[type] << block
    end

    def trigger(type, *args)
      callbacks[type].each do |callback|
        callback.call(*args)
      end
    end

    def callbacks
      @callbacks ||= Hash.new do |hash, key|
        hash[key] = []
      end
    end
  end
end

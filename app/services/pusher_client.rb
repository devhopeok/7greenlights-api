class PusherClient
  def self.trigger(channel, event, data = {})
    Pusher.trigger(channel, event, data)
  end
end

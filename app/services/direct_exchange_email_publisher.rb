require "bunny"

class DirectExchangeEmailPublisher
  include Helpers::RabbitmqHelper
  attr_accessor :message, :options

  def initialize(message:, options:)
    @message = message
    @options = options
  end

  def publish
    @connection = create_connection
    channel = @connection.create_channel
    queue = channel.queue(@options[:queue_name], durable: true)
    exchange = if @connection.exchange_exists?("email.exchange")
      channel.direct("email.exchange", no_declare: true, durable: true, auto_delete: true)
    else
      Bunny::Exchange.new(channel, :direct, "email.exchange")
    end
    queue.bind(exchange, routing_key: @options[:routing_key])
    exchange.publish(
      message.to_json,
      routing_key: @options[:routing_key],
      content_type: "application/json",
      content_encoding: "UTF-8",
      persistent: true
    )
    @connection.close
  end
end

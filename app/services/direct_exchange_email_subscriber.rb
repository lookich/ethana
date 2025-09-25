require "bunny"

class DirectExchangeEmailSubscriber
  include Helpers::RabbitmqHelper
  def initialize
    @connection = create_connection
  end

  def subscribe(queue_name)
    Thread.new do
      channel = create_channel
      queue = channel.queue(queue_name, durable: true)
      begin
        queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
          process_message(payload)
          channel.ack(delivery_info.delivery_tag)
        end
      rescue Interrupt => _e
        channel.reject(delivery_info.delivery_tag, true)
      end
    end
  end

  def process_message(payload)
    data = JSON.parse(payload)
    UserMailer.with(data: data).send_email.deliver
  end

  def create_channel
    @connection.start
    @connection.create_channel
  end
end

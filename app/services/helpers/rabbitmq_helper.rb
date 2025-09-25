require "bunny"

module Helpers::RabbitmqHelper
  def create_connection
    begin
      connection = Bunny.new(
        addresses: ENV["RABBITMQ_AMQP_ADDRESSES"].split(","),
        user: ENV["RABBITMQ_WEB_USERNAME"],
        password: ENV["RABBITMQ_WEB_PASSWORD"],
        vhost: ENV["RABBITMQ_VHOST"],
        automatically_recover: true
      )
      connection.start
    rescue Bunny::TCPConnectionFailed => error
      puts "Connection to server failed: #{error}"
    end
  end
end

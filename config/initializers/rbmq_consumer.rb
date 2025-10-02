Rails.application.config.after_initialize do
  if defined?(Rails::Server) && Rails.env != "test"
    DirectExchangeEmailSubscriber.new.subscribe("email_queue")
  end
end

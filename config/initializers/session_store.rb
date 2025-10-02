session_url = "#{ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/1')}/session"
secure = Rails.env.production?
key = Rails.env.production? ? "_app_session" : "_app_session_#{Rails.env}"
domain = ENV.fetch("REDIS_HOST", "localhost")

Rails.application.config.session_store :redis_store,
  url: session_url,
  connect_timeout: 30,
  read_timeout: 0.2,
  write_timeout: 0.2,
  reconnect_attempts: 2,
  expire_after: 180.days,
  key: key,
  domain: domain,
  hreadsafe: true,
  secure: secure,
  same_site: :lax,
  httponly: true

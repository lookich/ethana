require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ethana
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Mount Action Cable outside the main process or domain.
    # config.action_cable.mount_path = nil
    # config.action_cable.url = ENV.fetch("ACTION_CABLE_FRONTEND_URL") { "ws://localhost:28080" }

    # Only allow connections to Action Cable from these domains.
    # origins = ENV.fetch("ACTION_CABLE_ALLOWED_REQUEST_ORIGINS") { "http:\/\/localhost*" }.split(",")
    # origins.map! { |url| /#{url}/ }
    # config.action_cable.allowed_request_origins = origins

    # Set Sidekiq as the back-end for Active Job.
    config.active_job.queue_adapter = :sneakers

    # Generate: bin/rails db:encryption:init
    config.active_record.encryption.primary_key = ENV.fetch("ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY", "primary_key_for_dev")
    config.active_record.encryption.deterministic_key = ENV.fetch("ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY", "deterministic_key_for_dev")
    config.active_record.encryption.key_derivation_salt = ENV.fetch("ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT", "key_derivation_salt_for_dev")
    config.paths.add File.join("app", "api"), glob: File.join("**", "*.rb")
    config.autoload_paths += Dir[Rails.root.join("app", "api", "*")]
  end
end

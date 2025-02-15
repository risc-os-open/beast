require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Beast
  class Application < Rails::Application
    include HubSsoLib::Core

    hubssolib_register_user_change_handler(
      app_name:  Rails.application.name,
      app_root:  Rails.root,
      task_name: 'hub:update_user'
    )

    # Initialize configuration defaults for originally generated Rails version.
    #
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    #
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc

    # Custom format and rotation for logs.
    #
    class CustomLoggerFormatter < Logger::Formatter
      include ActiveSupport::TaggedLogging::Formatter

      def call(severity, time, progname, msg)
        "#{severity[0]} #{time.iso8601(2)} #{tag_stack.format_message(msg)}\n"
      end
    end

    config.log_tags         = [ :request_id ] # To match against reports in Sentry, should need arise
    config.logger           = ActiveSupport::TaggedLogging.logger(Rails.root.join('log', "#{Rails.env}.log"), 'daily')
    config.logger.formatter = CustomLoggerFormatter.new

    # Add the shared ROOL view components.
    #
    shared_views_path = if ENV['SHARED_FILES_PATH'].blank?
      Rails.root.join('..', 'common', 'views')
    else
      Rails.root.join(ENV['SHARED_FILES_PATH'], 'views')
    end
    config.paths['app/views'].unshift(shared_views_path)

    # If running in a deployed environment, allow requests to Epsilon. Send
    # e-mail via Beta, which is on the same local network.
    #
    if Socket.gethostname == 'epsilon'
      config.hosts << "epsilon.arachsys.com"

      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address:        'beta.arachsys.com',
        port:           25,
        domain:         'riscosopen.org',
        user_name:      nil,
        password:       nil,
        authentication: nil,
        enable_starttls_auto: true
      }
    end

  end
end

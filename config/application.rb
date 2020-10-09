require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Project
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:delete,:put,:get, :post, :options]
      end
    end
    config.load_defaults 5.2
    config.autoload_paths << Rails.root.join('lib')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.middleware.use BatchApi::RackMiddleware do |batch_config|
      # you can set various configuration options:
      batch_config.verb = :put # default :post
      batch_config.endpoint = "/batchapi" # default /batch
      batch_config.limit = 100 # how many operations max per request, default 50

      # default middleware stack run for each batch request
      batch_config.batch_middleware = Proc.new { }
      # default middleware stack run for each individual operation
      batch_config.operation_middleware = Proc.new { }
    end
    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'  
  end

  
end

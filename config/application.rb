require_relative 'boot'

require 'rails/all'
require 'roo'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MedicalMachine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.assets.compile = true
    # config.assets.image_optim.nice = 20
    # config.assets.image_optim.svgo = false
    # config.assets.image_optim.gifsicle.careful = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.paths << Rails.root.join('/app/assets/fonts')

    # Fix issue environment variables be not loaded in production.rb file
    # Load defaults from config/*.env in config
    Dotenv.load *Dir.glob(Rails.root.join("**/*.env"), File::FNM_DOTMATCH)
    # Override any existing variables if an environment-specific file exists
    Dotenv.overload *Dir.glob(Rails.root.join("**/*.env.#{Rails.env}"), File::FNM_DOTMATCH)

    config.time_zone = "Asia/Ho_Chi_Minh"

    #don't auto generate test file
    config.generators.test_framework false
    config.action_controller.include_all_helpers = false

    config.autoload_paths << Rails.root.join('lib/')
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor #{config.root}/config/routes)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.middleware.use Rack::Deflater
    config.exceptions_app = self.routes
    require 'monkey_patch/string'

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }
  end
end

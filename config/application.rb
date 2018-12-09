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

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.paths << Rails.root.join('/app/assets/fonts')

    config.time_zone = "Asia/Ho_Chi_Minh"

    #don't auto generate test file
    config.generators.test_framework false
    config.action_controller.include_all_helpers = false

    config.autoload_paths << Rails.root.join('lib/')
    require 'monkey_patch/string'
  end
end

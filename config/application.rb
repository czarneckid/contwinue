require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "action_view/railtie"

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Contwinue
  class Application < Rails::Application
    config.generators do |g|
      g.orm :mongoid
      g.test_framework :rspec, fixture: false, views: false
      g.integration_tool :rspec
      g.template_engine :haml
      g.javascript_engine :coffee
    end

    config.encoding = "utf-8"
    config.autoload_paths += %W(#{config.root}/lib/twitter)
  end
end

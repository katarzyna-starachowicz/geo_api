# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Types
  include Dry.Types
end

module GeoApi
  class Application < Rails::Application
    config.load_defaults 5.2
    config.autoload_paths += %W[#{config.root}/lib]
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
  end
end

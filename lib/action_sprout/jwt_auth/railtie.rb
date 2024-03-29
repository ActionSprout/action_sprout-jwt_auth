require 'rails/railtie'
require 'action_sprout/jwt_auth/rails_controller_helpers'

class ActionSprout::JWTAuth::Railtie < Rails::Railtie
  config.after_initialize do |app|
    if Rails.env.test?
      require 'action_sprout/jwt_auth/test/rspec' if defined?(RSpec) && RSpec.respond_to?(:configure)
    end
  end

  initializer 'action_sprout-jwt_auth.setup_action_controller' do
    ActiveSupport.on_load :action_controller do
      class_eval do
        include ActionSprout::JWTAuth::RailsControllerHelpers
      end
    end
  end

  rake_tasks { Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |f| load f } }
end


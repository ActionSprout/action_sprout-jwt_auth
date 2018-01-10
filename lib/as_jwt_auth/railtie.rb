require 'rails/railtie'
require 'as_jwt_auth/rails_controller_helpers'

class AsJWTAuth::Railtie < Rails::Railtie
  config.after_initialize do |app|
    if Rails.env.test?
      require 'as_jwt_auth/test/rspec' if defined?(RSpec) && RSpec.respond_to?(:configure)
    end
  end

  initializer 'as_jwt_auth.setup_action_controller' do
    ActiveSupport.on_load :action_controller do
      class_eval do
        include AsJWTAuth::RailsControllerHelpers
      end
    end
  end

  rake_tasks { Dir[File.join(File.dirname(__FILE__), 'tasks/*.rake')].each { |f| load f } }
end


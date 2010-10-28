if defined? Rails and Rails.version > '3'
  module Portier
    class Railtie < Rails::Railtie
      config.before_initialize do
        require 'portier/base'
        require 'portier/controller'
        ActiveRecord::Base.send     :extend, Portier::Base
        ActionController::Base.send :include, Portier::Controller
      end
    end
  end
end

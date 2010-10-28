module Portier
  module Controller
    attr_reader :current_user

    def self.included controller
      controller.send :extend, ClassMethods
      controller.send :helper_method, :current_user, :logged_in?
      controller.send :prepend_before_filter, :do_authentication
    end

    def logged_in?
      !!current_user
    end

    protected

    def do_authentication
      (self.class.authentication_engines.keys rescue []).find do |engine|
        @current_user = send("authenticate_from_#{engine}")
      end
    end

    module ClassMethods
      def self.extended controller
        controller.send :cattr_reader, :authentication_engines
      end

      def user_model_for engine
        @@authentication_engines[engine].constantize
      end

      def authenticate_from *args
        opts = args.extract_options!
        model = opts[:model] || 'User'

        args.flatten!
        data = class_variable_get(:@@authentication_engines) || class_variable_set(:@@authentication_engines, {})
        args.each do |engine|
          include "Portier::Engines::#{engine.to_s.camelize}".constantize
          data[engine] = model
        end
      end
    end
  end
end

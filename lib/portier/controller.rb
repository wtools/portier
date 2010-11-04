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
      a = self.class.read_inheritable_attribute(:portier_engines) or return
      a.keys.find { |e| @current_user = send("authenticate_from_#{e}") }
    end

    module ClassMethods
      def user_model_for engine
        read_inheritable_attribute(:portier_engines)[engine].constantize
      end

      def authenticate_from *args
        opts = args.extract_options!
        model = opts[:model] || 'User'

        args.flatten!
        data = read_inheritable_attribute(:portier_engines) || write_inheritable_attribute(:portier_engines, {})
        args.each do |engine|
          require "portier/engines/#{engine}"
          include "Portier::Engines::#{engine.to_s.camelize}".constantize
          data[engine] = model
        end
      end
    end
  end
end

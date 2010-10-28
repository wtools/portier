require 'bcrypt'

module Portier::Authenticated
  module ByPassword
    def self.included model
      model.send :extend, ClassMethods
      model.send :attr_reader, :password
    end

    def self.configure model, opts
      model.send :write_inheritable_attribute,
                 :portier_identity, opts[:identity] || :username
      model.send :write_inheritable_attribute,
                 :portier_scope,    opts[:scope]    || :scoped
    end

    def password= value
      self.crypted_password = BCrypt::Password.create(value).to_s
      @password = value
    end

    module ClassMethods
      def authenticate params
        identity = read_inheritable_attribute :portier_identity
        u = send(read_inheritable_attribute(:portier_scope)).
            where(identity => params[identity]).first
        u if u && BCrypt::Password.new(u.crypted_password) == params[:password]
      end
    end
  end
end

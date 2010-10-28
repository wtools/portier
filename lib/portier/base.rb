module Portier
  module Base
    def authenticated engine, opts={}
      require "portier/authenticated/#{engine}"
      mod = Portier::Authenticated.const_get engine.to_s.camelize
      send :include, mod
      mod.configure self, opts
      true
    end
  end
end

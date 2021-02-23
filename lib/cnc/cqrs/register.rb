module Cnc
  module Cqrs
    class Register
      class << self
        def handler(klass, name = 'default')
          Cnc::Cqrs.handlers[name] = klass
        end
      end
    end
  end
end

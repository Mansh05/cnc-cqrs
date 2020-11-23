module Cnc
  module Cqrs
    class CommandHandler
      class << self
        def handle(name, resource)
          command = Cnc::Cqrs.commands[name.to_s]

          if command['handle_with']
            Cnc::Cqrs.handlers[command['handle_with']].new(command, resource).call
          else
            Cnc::Cqrs.handlers['default'].new(command, resource).call
          end

          Cnc::Cqrs::EventBus.drive(resource, command)
        end
      end
    end
  end
end

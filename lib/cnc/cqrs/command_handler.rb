module Cnc
  module Cqrs
    class CommandHandler
      class << self
        def handle(name, resource)
          command = Cnc::Cqrs.commands[name.to_s]

          # if command is not defined then raise a command not found error
          if command.nil?
            raise Cnc::Cqrs::CommandNotFound, "#{name} command not found, please check if the command exists or not"
          end

          if command['handle_with']
            Cnc::Cqrs.handlers[command['handle_with']].new(command, resource).call
          else
            Cnc::Cqrs.handlers['default'].new(command, resource).call
          end

          Cnc::Cqrs::EventBus.drive(resource, command)
        end

        def execute(name, arguments = {}, stream = nil)
          begin
            Cnc::Cqrs::Command.stream = stream || SecureRandom.uuid

            Cnc::Cqrs::Record.create(stream: Cnc::Cqrs::Command.stream, command: name)

            handle(name, arguments)

            arguments[:response] || { done: true }
          rescue => e
            Cnc::Cqrs::ErrorHandler.handle(e.message)

            raise
          end
        end
      end
    end
  end
end

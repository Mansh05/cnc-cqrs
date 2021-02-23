require 'cnc/cqrs/command_handler'
require 'cnc/cqrs/record'
require 'cnc/cqrs/error_handler'

module Cnc
  module Cqrs
    module CommandBus

      def command(name, arguments = {}, stream = nil)
        Cnc::Cqrs::Command.stream = stream || SecureRandom.uuid

        Cnc::Cqrs::Record.find_by(stream: Cnc::Cqrs::Command.stream) ||
          Cnc::Cqrs::Record.create(stream: Cnc::Cqrs::Command.stream, command: name)

        resource = {
          params: params,
          current_user: current_user,
          response: { done: true }
        }
        resource = resource.merge(arguments)

        handle_command(name, resource, stream)
      end

      def handle_command(name, resource, stream)
        begin
          Cnc::Cqrs::CommandHandler.handle(name, resource)

          return if stream.present?

          render json: resource[:response]
        rescue => e
          Cnc::Cqrs::ErrorHandler.handle(e.message)

          raise
        end
      end
    end
  end
end

module Cnc
  module Cqrs
    class EventBus
      class << self
        def drive(resource, command)
          Cnc::Cqrs::Command.stream ||= SecureRamdom.uuid

          if command['event'].present?
            event = Cnc::Cqrs.commands[command.dig('event', 'name')]

            # Either a custom handler or the default one
            handler = Cnc::Cqrs.handlers[event['handle_with'] ? event['handle_with'] : 'default']

            Cnc::Cqrs.event_source.call(command.dig('event', 'name'), handler.source(event, resource))
          end
        end
      end
    end
  end
end

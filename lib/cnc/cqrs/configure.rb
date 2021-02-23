require 'yaml'

module Cnc
  module Cqrs
    class Configure
      class << self
        def run(config)
          Dir[Pathname("#{config}/**/*.yml")].each do |file|
            data = YAML.load_file(file)
            set_command(data)
          end
          set_event_source(nil)
        end

        def set_command(command, type = 'command')
          command['type'] = type
          Cnc::Cqrs.commands[command['name']] = command

          if command['event'].present?
            set_command(command['event'], 'event')
          end
        end

        def set_event_source(source)
          # Need to figure out a way to set different sources
          if source.nil?
            require 'cnc/cqrs/event_sources/active_job'
            Cnc::Cqrs.event_source = Cnc::Cqrs::EventSources::ActiveJob
          end
        end
      end
    end
  end
end

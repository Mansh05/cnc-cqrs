module Cnc
  module Cqrs
    module EventSources
      class ActiveJob
        def self.call(name, source)
          Cnc::Cqrs::EventSources::Job.perform_later(Cnc::Scope::Tenant.current, name, source, Cnc::Cqrs::Command.stream)
        end
      end

      class Job < ::ApplicationJob
        def perform(tenant, name, data, stream)
          Cnc::Cqrs::Command.stream = stream
          Cnc::Scope::Tenant.with(tenant) do
            puts "Tenant: #{tenant} with stream #{stream}, Event Name: #{name}, data: #{data}"

            begin
              resource = {}
              record = Cnc::Cqrs::Record.find_by(stream: stream)
              record.update(event: name, data: data)

              data.each do |meta|
                if meta[:direct]
                  resource[meta[:key]] = meta[:value]
                else
                  data = meta[:klass].constantize.find(meta[:id])

                  meta[:key].each do |key|
                    resource[key] = data
                  end
                end
              end

              event = Cnc::Cqrs.commands[name]
              # Either a custom handler or the default one

              handler = Cnc::Cqrs.handlers[event['handle_with'] ? event['handle_with'] : 'default']

              handler.new(event, resource).call
            rescue => e
              Cnc::Cqrs::ErrorHandler.handle(e.message)

              raise
            end
          end
        end
      end
    end
  end
end

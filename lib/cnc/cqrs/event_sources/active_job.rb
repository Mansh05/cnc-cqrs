module Cnc
  module Cqrs
    module EventSources
      class ActiveJob
        def self.call(name, source, resource = {})
          performer = ENV['CQRS_PERFORMER']

          # if the request comes from the controller than this will help a lot
          params = {}
          if resource[:params].present?
            params = resource[:params].as_json
          end

          if performer == 'now'
            Cnc::Cqrs::EventSources::Job.perform_now(::Cnc::Cqrs.tenant.call, name, source, Cnc::Cqrs::Command.stream, params)
          else
            Cnc::Cqrs::EventSources::Job.perform_later(::Cnc::Cqrs.tenant.call, name, source, Cnc::Cqrs::Command.stream, params)
          end
        end
      end

      class Job < ::ApplicationJob
        def perform(tenant, name, data, stream, params)
          Cnc::Cqrs::Command.stream = stream
          ::ApartmentService.switch tenant

          # Cnc::Scope::Tenant.with(tenant) do
          puts "Tenant: #{tenant} with stream #{stream}, Event Name: #{name}, data: #{data}"

          begin

            record = Cnc::Cqrs::Record.where(stream: stream).last
            record.update(event: name, data: data)

            resource = {
              'actor' => {
                'uuid' => record.current_user
              },
              'params' => params
            }

            data.each do |meta|
              if meta[:direct]
                resource[meta[:key]] = meta[:value]
              else
                klass = meta[:klass].constantize
                data = klass.find_by(id: meta[:id]) || klass.find_by(id: meta[:id].to_i)

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
          # end
        end
      end
    end
  end
end

module Cnc
  module Cqrs
    module Specs
      class ActiveJob
        def self.call(name, source , resource = {})

          # if the request comes from the controller than this will help a lot
          params = {}
          if resource[:params].present?
            params = resource[:params].as_json
          end

          Cnc::Cqrs::EventSources::Job.perform_now(::Cnc::Cqrs.tenant.call, name, source, Cnc::Cqrs::Command.stream, params)
        end
      end
    end
  end
end

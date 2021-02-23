module Cnc
  module Cqrs
    module Specs
      class ActiveJob
        def self.call(name, source)
          Cnc::Cqrs::EventSources::Job.perform_now(::Cnc::Cqrs.tenant.call, name, source, Cnc::Cqrs::Command.stream)
        end
      end
    end
  end
end

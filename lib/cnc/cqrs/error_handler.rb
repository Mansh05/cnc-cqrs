module Cnc
  module Cqrs
    module ErrorHandler
      def self.handle(error)
        record = Cnc::Cqrs::Record.find_by(stream: Cnc::Cqrs::Command.stream)

        record.update(event_errors: error.to_s)
      end
    end
  end
end

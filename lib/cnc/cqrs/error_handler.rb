module Cnc
  module Cqrs
    module ErrorHandler
      def self.handle(error)
        record = Cnc::Cqrs::Record.where(stream: Cnc::Cqrs::Command.stream).last

        record.update(event_errors: error.to_s)
      end
    end
  end
end

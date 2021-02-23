module Cnc
  module Cqrs
    class Record
      include Mongoid::Document
      include Mongoid::Timestamps

      field :stream, type: String
      field :command, type: String
      field :event, type: String
      field :event_errors, type: String
      field :data, type: Array, default: []

      def command_fulfiled?
        event.present?
      end

      # Add cnc scope as one of the values
      store_in database: -> { "cnc_event_store" }
    end
  end
end

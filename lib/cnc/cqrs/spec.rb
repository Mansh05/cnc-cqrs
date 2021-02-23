require 'cnc/cqrs/specs/active_job'

# This modules work is to just require all the spec related files
# IT will not be autoloaded but will be used while running specs in the application onlt
module Cnc
  module Cqrs
    class Spec
      class << self
        def update_event_source(klass)
          Cnc::Cqrs.event_source = klass
        end
      end
    end
  end
end

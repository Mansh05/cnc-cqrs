require "cnc/cqrs/version"
require 'yaml'

module Cnc
  module Cqrs
    class Error < StandardError; end
    # Your code goes here...

    def self.setup
      yield self
      configure
    end

    def self.configure
      Cnc::Cqrs::Configure.run(file_path)
    end

    # This configuration will contain all the commands
    mattr_accessor :commands, default: {}

    # This is the default path that the will be looked into
    mattr_accessor :file_path, default: ''

    # Main Adaptor to handle commands
    mattr_accessor :handlers, default: {}

    # Main Event Source apadptor
    mattr_accessor :event_source, default: 'active_job'
  end
end

require 'cnc/cqrs/command_bus'
require 'cnc/cqrs/configure'
require 'cnc/cqrs/event_bus'
require 'cnc/cqrs/command'
require 'cnc/cqrs/register'

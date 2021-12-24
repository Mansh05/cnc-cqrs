require "cnc/cqrs/version"
require 'yaml'

module Cnc
  module Cqrs
    class Error < StandardError; end

    class CommandNotFound < StandardError; end
    # Your code goes here...

    def self.setup
      yield self
      configure
    end

    def self.configure
      Cnc::Cqrs::Configure.run(file_path)
    end

    # # This configuration will contain all the commands
    @@commands = {}

    def self.commands
      @@commands
    end

    # # This is the default path that the will be looked into
    @@file_path = ''

    def self.file_path
      @@file_path
    end

    def self.file_path=(path)
      @@file_path = path
    end

    # # Main Adaptor to handle commands
    @@handlers = {}
    def self.handlers
      @@handlers
    end

    # # Main Event Source adaptor
    @@event_source = 'active_job'
    def self.event_source
      @@event_source
    end

    def self.event_source=(source)
      @@event_source = source
    end

    # Main tenant source
    @@tenant = nil

    def self.tenant
      @@tenant
    end

    def self.tenant=(tenant)
      @@tenant = tenant
    end
  end
end

require 'cnc/cqrs/command_bus'
require 'cnc/cqrs/configure'
require 'cnc/cqrs/event_bus'
require 'cnc/cqrs/command'
require 'cnc/cqrs/register'

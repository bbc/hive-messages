require "virtus"
require "roar/representer/json"
require "openssl"

require "active_support/version"

if ActiveSupport.version >= Gem::Version.new("4.1")
  require "active_support/core_ext/object/json"
else
  require "active_support/core_ext/object/to_json"
end

require "hive/messages/version"
require "hive/paths"
require "hive/messages/configuration"

require "hive/representers/job_representer"
require "hive/messages/execution_variables_base"
require "hive/messages/job"

module Hive
  module Messages

    class << self
      attr_accessor :configuration

      def root
        File.expand_path '../../..', __FILE__
      end

      def configure

        self.configuration = Configuration.new
        yield(configuration)
        Hive::Paths.base = self.configuration.base_path
      end
    end
  end
end

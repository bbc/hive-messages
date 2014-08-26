require "virtus"
require "roar/representer/json"

require "active_support"
require "active_support/core_ext/object/json"

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

      def configure

        self.configuration = Configuration.new
        yield(configuration)
        Hive::Paths.base = self.configuration.base_path
      end
    end
  end
end

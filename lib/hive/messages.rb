require "virtus"
require "roar/representer/json"
require "openssl"
require "version"
require "active_model"

require "active_support/version"

if ActiveSupport.version >= Gem::Version.new("4.1")
  require "active_support/core_ext/object/json"
else
  require "active_support/core_ext/object/to_json"
end

require "roar/representer/transport/net_http/request_patch"

require "hive/paths"
require "hive/messages/configuration"

require "hive/representers/job_representer"
require "hive/representers/artifact_representer"


require "hive/messages/base"
require "hive/messages/execution_variables_base"
require "hive/messages/job"
require "hive/messages/artifact"

module Hive
  module Messages
    is_versioned

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

require "hive/paths/queues"
require "hive/paths/jobs"

module Hive
  module Paths

    class << self
      attr_accessor :base
    end
  end
end

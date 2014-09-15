
module Hive
  module Messages
    class ExecutionVariablesBase
      include Virtus.model
      include ActiveModel::Validations

      attribute :job_id, Integer
      attribute :version, String
      attribute :queue_name, String

      validates :job_id, :version, :queue_name, presence: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "ExecutionVariables")
      end

#       def to_s
# require "pry"; binding.pry
#       end

#       def to_json(*args)
# require "pry"; binding.pry
#       end
    end
  end
end

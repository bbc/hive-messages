require 'virtus/attribute/execution_variables'
require 'roar/representer/json'

module Hive
  module Messages
    class Job
      include Virtus.model
      include ActiveModel::Validations
      # include Roar::Representer::JSON
      # include Hive::Representers::JobRepresenter

      attribute :command, String
      attribute :job_id, Integer
      attribute :repository, String
      attribute :execution_directory, String
      attribute :target, Hash
      attribute :execution_variables, ExecutionVariables

      validates :command, :job_id, :repository, :execution_directory, :target, :execution_variables, presence: true

      def initialize(*args)
        self.extend(Hive::Representers::JobRepresenter)
        super(*args)
      end
    end
  end
end

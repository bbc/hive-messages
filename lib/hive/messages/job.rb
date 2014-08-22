require 'virtus/attribute/execution_variables'
require 'roar/representer/json'
require 'roar/representer/feature/client'

module Hive
  module Messages
    class Job
      include Virtus.model
      include ActiveModel::Validations
      include Roar::Representer::JSON
      include Hive::Representers::JobRepresenter
      include Roar::Representer::Feature::Client

      attribute :command, String
      attribute :job_id, Integer
      attribute :repository, String
      attribute :execution_directory, String
      attribute :target, Hash
      attribute :execution_variables, ExecutionVariables

      validates :command, :job_id, :repository, :execution_directory, :target, :execution_variables, presence: true
    end
  end
end

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
      attribute :reservation_details, Hash
      attribute :device_id, Integer

      validates :command, :job_id, :repository, :execution_directory, :target, :execution_variables, presence: true

      class << self

        def reserve(queues, reservation_details)
          job = self.new
          job.reservation_details = reservation_details
          job.patch(uri: Hive::Paths::Queues.job_reservation_url(queues), as: "application/json")
        end
      end

      def start(device_id)
        self.device_id = device_id
        self.put(uri: Hive::Paths::Jobs.start_url(self.job_id), as: "application/json")
      end
    end
  end
end

module Hive
  module Representers
    module JobRepresenter
      include Roar::Representer::JSON

      property :command
      property :job_id
      property :repository
      property :execution_directory
      property :target
      property :execution_variables
      property :reservation_details
      property :device_id
      property :running_count
      property :passed_count
      property :failed_count
      property :errored_count
      property :state
    end
  end
end

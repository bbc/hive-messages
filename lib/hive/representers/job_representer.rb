module Hive
  module Representers
    module JobRepresenter
      include Roar::JSON

      property :command
      property :job_id
      property :repository
      property :branch
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
      property :result
      property :exit_value
      property :message
      property :result_details
      property :test_results
      property :log_files
    end
  end
end

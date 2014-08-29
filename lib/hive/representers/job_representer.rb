
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
    end
  end
end

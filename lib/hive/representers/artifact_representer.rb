module Hive
  module Representers
    module ArtifactRepresenter
      include Roar::JSON

      property :artifact_id
      property :job_id
      property :asset_file_name
      property :asset_content_type
      property :asset_file_size
    end
  end
end

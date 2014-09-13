
module Hive
  module Messages
    class Artifact < Hive::Messages::Base
      include Hive::Representers::ArtifactRepresenter

      attribute :job_id
      attribute :asset_file_name
      attribute :asset_content_type
      attribute :asset_file_size

      validates :job_id, :asset_file_name, :asset_content_type, :asset_file_size, presence: true
    end
  end
end

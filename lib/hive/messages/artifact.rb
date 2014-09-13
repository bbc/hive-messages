
module Hive
  module Messages
    class Artifact < Hive::Messages::Base
      include Hive::Representers::ArtifactRepresenter

      attribute :job_id, Integer
      attribute :asset_file_name, String
      attribute :asset_content_type, String
      attribute :asset_file_size, Integer

      validates :job_id, :asset_file_name, :asset_content_type, :asset_file_size, presence: true
    end
  end
end

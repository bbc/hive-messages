require "spec_helper"

describe Hive::Representers::ArtifactRepresenter do

  class TestArtifact
    include Virtus.model

    attribute :job_id
    attribute :asset_file_name
    attribute :asset_content_type
    attribute :asset_file_size
  end

  let(:upstream_artifact) do
    artifact = TestArtifact.new(artifact_attributes)
    artifact.extend(Hive::Representers::ArtifactRepresenter)
    artifact
  end

  let(:artifact_attributes) do
    {
        job_id:             123,
        asset_file_name:    "screenshot1.png",
        asset_content_type: "image/png",
        asset_file_size:    2300
    }
  end

  describe "serialization " do

    let(:downstream_artifact) do
      artifact = TestArtifact.new
      artifact.extend(Hive::Representers::ArtifactRepresenter)
      artifact.from_json(upstream_artifact.to_json)
      artifact
    end


    subject { downstream_artifact }

    its(:job_id)              { should eq artifact_attributes[:job_id] }
    its(:asset_file_name)     { should eq artifact_attributes[:asset_file_name] }
    its(:asset_content_type)  { should eq artifact_attributes[:asset_content_type] }
    its(:asset_file_size)     { should eq artifact_attributes[:asset_file_size] }
  end
end

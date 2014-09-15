require "spec_helper"
require "shoulda/matchers"
require "shoulda/matchers/active_model/validate_presence_of_matcher"
require 'webmock/rspec'

describe Hive::Messages::Artifact, type: :model do

  describe "validations" do

    it { should validate_presence_of(:artifact_id) }
    it { should validate_presence_of(:job_id) }
    it { should validate_presence_of(:asset_file_name) }
    it { should validate_presence_of(:asset_content_type) }
    it { should validate_presence_of(:asset_file_size) }
  end

  describe "serialization" do

    let(:artifact_attributes) do
      {
          artifact_id:        321,
          job_id:             123,
          asset_file_name:    "screenshot1.png",
          asset_content_type: "image/png",
          asset_file_size:    2300
      }
    end

    describe "#to_json" do

      let(:artifact_message) { Hive::Messages::Artifact.new(artifact_attributes) }

      it  "outputs valid payload JSON" do
        expect(artifact_message.to_json).to eq artifact_attributes.to_json
      end
    end

    describe "#from_json" do

      let(:artifact_message) { Hive::Messages::Artifact.new.from_json(artifact_attributes.to_json) }
      subject { artifact_message }

      its(:artifact_id)        { should eq artifact_attributes[:artifact_id] }
      its(:job_id)             { should eq artifact_attributes[:job_id] }
      its(:asset_file_name)    { should eq artifact_attributes[:asset_file_name] }
      its(:asset_content_type) { should eq artifact_attributes[:asset_content_type] }
      its(:asset_file_size)    { should eq artifact_attributes[:asset_file_size] }
    end
  end
end

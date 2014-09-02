require "spec_helper"

describe Hive::Paths::Artifacts do

  describe "class methods" do

    let(:base_path) { "http://hive.bbc" }

    before(:each) do
      Hive::Paths.base=base_path
    end

    describe ".create_url" do

      let(:job_id) { 99 }

      it "generates a valid create artifact url" do
        expect(Hive::Paths::Artifacts.create_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/artifacts"
      end
    end
  end
end

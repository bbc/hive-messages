require "spec_helper"

describe Hive::Paths::Jobs do

  describe "class methods" do

    let(:base_path) { "http://hive.bbc" }

    before(:each) do
      Hive::Paths.base = base_path
    end

    describe ".start_url" do

      let(:job_id) { 99 }

      let(:start_path) { Hive::Paths::Jobs.start_url(job_id) }

      it "generates a valid job start url" do
        expect(start_path).to eq "#{base_path}/api/jobs/#{job_id.to_s}/start"
      end
    end

    describe ".end_url" do

      let(:job_id) { 99 }

      let(:start_path) { Hive::Paths::Jobs.end_url(job_id) }

      it "generates a valid job start url" do
        expect(start_path).to eq "#{base_path}/api/jobs/#{job_id.to_s}/end"
      end
    end
  end
end

require "spec_helper"

describe Hive::Paths::Jobs do

  describe "class methods" do

    let(:base_path) { "http://hive.bbc" }
    let(:job_id) { 99 }

    before(:each) do
      Hive::Paths.base = base_path
    end

    describe ".start_url" do

      it "generates a valid job start url" do
        expect(Hive::Paths::Jobs.start_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/start"
      end
    end


    describe ".update_counts_url" do

      it "generates a valid update counts url" do
        expect(Hive::Paths::Jobs.update_counts_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/update_counts"
      end
    end

    describe ".end_url" do

      it "generates a valid job end url" do
        expect(Hive::Paths::Jobs.end_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/end"
      end
    end
  end
end

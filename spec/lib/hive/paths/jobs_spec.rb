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

    describe ".report_artifacts_url" do

      it "generates a valid report artifacts url" do
        expect(Hive::Paths::Jobs.report_artifacts_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/report_artifacts"
      end
    end

    describe ".end_url" do

      it "generates a valid job end url" do
        expect(Hive::Paths::Jobs.end_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/end"
      end
    end

    describe ".error_url" do

      it "generates a valid job error url" do
        expect(Hive::Paths::Jobs.error_url(job_id)).to eq "#{base_path}/api/jobs/#{job_id.to_s}/error"
      end
    end
  end
end

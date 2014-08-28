require "spec_helper"

describe Hive::Representers::JobRepresenter do

  class TestJob
    include Virtus.model

    attribute :command
    attribute :job_id
    attribute :repository
    attribute :execution_directory
    attribute :target
    attribute :execution_variables
    attribute :reservation_details
    attribute :extra
  end

  let(:upstream_job) do
    job = TestJob.new(job_attributes)
    job.extend(Hive::Representers::JobRepresenter)
    job
  end

  let(:target) { { "build" => "http://hive/download/99" } }
  let(:execution_variables) { { "tests" => [] } }
  let(:reservation_details) { { "hive" => "99", "pid" => "1024" } }


  let(:job_attributes) do
    {
        command:             "cmd",
        job_id:              99,
        repository:          "svn://",
        execution_directory: ".",
        target:              target,
        execution_variables: execution_variables,
        reservation_details: reservation_details,
        extra:               "thing"
    }
  end

  describe "serialization " do

    let(:downstream_job) do
      job = TestJob.new
      job.extend(Hive::Representers::JobRepresenter)
      job.from_json(upstream_job.to_json)
      job
    end


    subject { downstream_job }

    its(:command) { should eq job_attributes[:command] }
    its(:job_id) { should eq job_attributes[:job_id] }
    its(:repository) { should eq job_attributes[:repository] }
    its(:execution_directory) { should eq job_attributes[:execution_directory] }
    its(:target) { should eq job_attributes[:target] }
    its(:execution_variables) { should eq execution_variables }
    its(:reservation_details) { should eq reservation_details }
    its(:extra) { should be_nil }
  end
end

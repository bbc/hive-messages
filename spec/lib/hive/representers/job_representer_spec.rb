require "spec_helper"

describe Hive::Representers::JobRepresenter do

  class TestJob
    include Virtus.model

    attribute :command
    attribute :job_id
    attribute :repository
    attribute :branch
    attribute :execution_directory
    attribute :target
    attribute :install_build
    attribute :execution_variables
    attribute :reservation_details
    attribute :device_id
    attribute :running_count
    attribute :passed_count
    attribute :failed_count
    attribute :state
    attribute :errored_count
    attribute :result
    attribute :exit_value
    attribute :message
    attribute :result_details
    attribute :test_results
    attribute :log_files

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
        branch:              "test_branch",
        execution_directory: ".",
        target:              target,
        install_build:       true,
        execution_variables: execution_variables,
        reservation_details: reservation_details,
        device_id:           23,
        running_count:       4,
        passed_count:        3,
        failed_count:        2,
        errored_count:       1,
        state:               "running",
        extra:               "thing",
        result:              "test result",
        exit_value:          0,
        message:             "Hello, mum",
        result_details:      "Blah!",
        test_results:        [ test_case: 'Testing', urn: '/tmp/test.txt', status: 'passed' ],
        log_files:           { "stdout" => 'Standard out' }
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

    its(:command)             { should eq job_attributes[:command] }
    its(:job_id)              { should eq job_attributes[:job_id] }
    its(:repository)          { should eq job_attributes[:repository] }
    its(:branch)              { should eq job_attributes[:branch] }
    its(:execution_directory) { should eq job_attributes[:execution_directory] }
    its(:target)              { should eq job_attributes[:target] }
    its(:install_build)       { should eq job_attributes[:install_build] }
    its(:execution_variables) { should eq execution_variables }
    its(:reservation_details) { should eq reservation_details }
    its(:device_id)           { should eq job_attributes[:device_id] }
    its(:running_count)       { should eq job_attributes[:running_count] }
    its(:passed_count)        { should eq job_attributes[:passed_count] }
    its(:failed_count)        { should eq job_attributes[:failed_count] }
    its(:errored_count)       { should eq job_attributes[:errored_count] }
    its(:state)               { should eq job_attributes[:state] }
    its(:result)              { should eq job_attributes[:result] }
    its(:exit_value)          { should eq job_attributes[:exit_value] }
    its(:message)             { should eq job_attributes[:message] }
    its(:result_details)      { should eq job_attributes[:result_details] }
    its(:log_files)           { should eq job_attributes[:log_files] }

    # Attribute that should be ignored
    its(:extra)               { should be_nil }
  end
end

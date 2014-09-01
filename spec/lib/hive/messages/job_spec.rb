require "spec_helper"
require "shoulda/matchers"
require "shoulda/matchers/active_model/validate_presence_of_matcher"
require 'webmock/rspec'

describe Hive::Messages::Job, type: :model do

  describe "validations" do

    it { should validate_presence_of(:command) }
    it { should validate_presence_of(:job_id) }
    it { should validate_presence_of(:repository) }
    it { should validate_presence_of(:execution_directory) }
    it { should validate_presence_of(:target) }
    it { should validate_presence_of(:execution_variables) }
  end

  describe "serialization" do

    let(:job_attributes) do
      {
          command:             "cucumber -t @all",
          job_id:              99,
          repository:          "svn://...",
          execution_directory: "/some_dir",
          target:              { application_url: "http://www.bbc.co.uk/mobile", application_url_parameters: "thing=value" },
          execution_variables: { job_id: 99, version: "1.0", queue_name: "nexus-4", run_id: "88", tests: ["test one", "test two"] },
          reservation_details: { hive_id: 99, pid: 1024 },
          device_id:           23

      }
    end

    describe "#to_json" do

      let(:job_message) { Hive::Messages::Job.new(job_attributes) }

      it  "outputs valid payload JSON" do
        expect(job_message.to_json).to eq job_attributes.to_json
      end
    end

    describe "#from_json" do

      let(:job_message) { Hive::Messages::Job.new.from_json(job_attributes.to_json) }
      subject { job_message }

      its(:command)             { should eq job_attributes[:command] }
      its(:job_id)              { should eq job_attributes[:job_id] }
      its(:repository)          { should eq job_attributes[:repository] }
      its(:execution_directory) { should eq job_attributes[:execution_directory] }
      its(:target)              { should eq job_attributes[:target].stringify_keys }
      it "assigned the correct values to the execution variables object" do
        expect(job_message.execution_variables.attributes).to eq job_attributes[:execution_variables]
      end
      its(:reservation_details) { should eq job_attributes[:reservation_details].stringify_keys }
      its(:device_id)           { should eq job_attributes[:device_id] }
    end
  end

  describe "class methods" do

    describe ".reserve" do

      let(:base_path)           { "http://hive.bbc" }
      let(:remote_job)          { Hive::Messages::Job.new(job_id: 99, command: "cmd", repository: "repository") }
      let(:queue_names)         { ["queue_one", "queue_two"] }
      let(:reservation_details) { { hive_id: 99, worker_pid: 1024 } }

      before(:each) do
        Hive::Messages.configure { |config| config.base_path = base_path }
        stub_request(:patch, Hive::Paths::Queues.job_reservation_url(queue_names))
          .with( body: {reservation_details: reservation_details}.to_json, headers: { "Content-Type" => "application/json" } )
          .to_return( body: remote_job.to_json )
      end

      let(:reservation)         { Hive::Messages::Job.reserve(queue_names, reservation_details) }

      describe "reserved job" do

        subject { Hive::Messages::Job.reserve(queue_names, reservation_details) }

        its(:job_id) { should eq remote_job.job_id }
        its(:command) { should eq remote_job.command }
        its(:repository) { should eq remote_job.repository }
      end
    end
  end

  describe "instance methods" do

    let(:base_path)   { "http://hive.bbc" }
    let(:remote_job)  { Hive::Messages::Job.new(job_id: job_id, command: "cmd", repository: "repository") }

    let(:job_id)    { 99 }

    before(:each) do
      Hive::Messages.configure { |config| config.base_path = base_path }
    end

    describe "#start" do

      let(:device_id) { 33 }

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.start_url(job_id))
        .with( body: {job_id: job_id, device_id: device_id}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        Hive::Messages::Job.new(job_id: job_id).start(device_id)
      end

      it "made the request to start the job" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#end" do

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.end_url(job_id))
        .with( body: {job_id: job_id}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        Hive::Messages::Job.new(job_id: job_id).end
      end

      it "made the request to start the job" do
        expect(stubbed_request).to have_been_requested
      end

    end
  end
end

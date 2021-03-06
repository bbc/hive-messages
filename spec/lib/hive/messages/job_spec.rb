require "spec_helper"
require "shoulda/matchers"
require "shoulda/matchers/active_model/validate_presence_of_matcher"
require 'webmock/rspec'

describe Hive::Messages::Job, type: :model do

  describe "validations" do

    it { should validate_presence_of(:command) }
    it { should validate_presence_of(:job_id) }
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
          device_id:           23,
          state:               "running"

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
      its(:state)               { should eq job_attributes[:state] }
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
        .to_return( body: http_body, status: http_status )
      end

      subject { Hive::Messages::Job.reserve(queue_names, reservation_details) }

      context "when a job is available for reservation" do

        let(:http_status) { 200 }
        let(:http_body) { remote_job.to_json }

        its(:job_id) { should eq remote_job.job_id }
        its(:command) { should eq remote_job.command }
        its(:repository) { should eq remote_job.repository }
      end

      context "when NO job is available for reservation" do

        let(:http_status) { 404 }
        let(:http_body) { nil }

        it { should be_nil }
      end
    end
  end

  describe "instance methods" do

    let(:base_path)   { "http://hive.bbc" }
    let(:remote_job)  { Hive::Messages::Job.new(job_id: job_id, command: "cmd", repository: "repository") }

    let(:local_job) { Hive::Messages::Job.new(job_id: job_id) }

    let(:job_id)    { 99 }

    before(:each) do
      Hive::Messages.configure { |config| config.base_path = base_path }
    end

    describe "#prepare" do
      let(:device_id) { 33 }

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.prepare_url(job_id))
        .with( body: {job_id: job_id, device_id: device_id}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        local_job.prepare(device_id)
      end

      it "made the request to prepare the job" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#start" do
      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.start_url(job_id))
        .with( body: {job_id: job_id}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        local_job.start
      end

      it "made the request to start the job" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#update_results" do

      let(:device_id) { 33 }

      let(:running_count)  { 4 }
      let(:failed_count)   { 3 }
      let(:errored_count)  { 2 }
      let(:passed_count)   { 1 }

      let(:counts) {
        {   running_count: running_count,
            passed_count:  passed_count,
            failed_count:  failed_count,
            errored_count: errored_count
        }
      }

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.update_results_url(job_id))
        .with( body:    {job_id:job_id}.merge(counts).to_json,
               headers: { "Content-Type" => "application/json" }
              )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        local_job.update_results(counts)
      end

      it "made the request to start the job" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#report_artifact" do

      let(:remote_artifact) { Hive::Messages::Artifact.new(job_id: 99, asset_file_name: "screenshot_1.png", asset_content_type: "image/png", asset_file_size: 2300) }

      let!(:stubbed_request) do
        stub_request(:post, Hive::Paths::Artifacts.create_url(job_id))
        .with(
            body: "-------------RubyMultipartPost\r\nContent-Disposition: form-data; name=\"data\"; filename=\"#{artifact_basename}\"\r\nContent-Length: 26\r\nContent-Type: #{artifact_mime}\r\nContent-Transfer-Encoding: binary\r\n\r\nThis is a sample log file.\r\n-------------RubyMultipartPost--\r\n\r\n",
            headers: {'Accept'=>'*/*', 'Content-Length'=>'254', 'Content-Type'=>'multipart/form-data; boundary=-----------RubyMultipartPost', 'User-Agent'=>'Ruby'}
        )
        .to_return( body: remote_artifact.to_json )
      end

      let(:artifact_mime) { MimeMagic.by_path(artifact_path) }
      let(:artifact_basename) { Pathname.new(artifact_path).basename }

      let(:artifact_path) { File.expand_path("spec/fixtures/upload_sample.log", Hive::Messages.root) }

      let!(:returned_artifact) { Hive::Messages::Job.new(job_id: job_id).report_artifact(artifact_path) }

      it "returns an Artifact object" do
        expect(returned_artifact).to be_instance_of(Hive::Messages::Artifact)
      end

      it "populates the resulting Artifact with the attributes returned upstream" do
        expect(returned_artifact.attributes).to eq remote_artifact.attributes
      end

      it "uploaded the artifact" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#end" do

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.end_url(job_id))
        .with( body: {job_id: job_id, exit_value: 0}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        Hive::Messages::Job.new(job_id: job_id).end 0
      end

      it "made the request to end the job" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#complete" do

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.complete_url(job_id))
        .with( body: {job_id: job_id}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        Hive::Messages::Job.new(job_id: job_id).complete
      end

      it "made the request to complete the job" do
        expect(stubbed_request).to have_been_requested
      end
    end

    describe "#error" do

      let!(:stubbed_request) do
        stub_request(:patch, Hive::Paths::Jobs.error_url(job_id))
        .with( body: {job_id: job_id, message: 'Test error message'}.to_json, headers: { "Content-Type" => "application/json" } )
        .to_return( body: remote_job.to_json )
      end

      before(:each) do
        Hive::Messages::Job.new(job_id: job_id).error 'Test error message'
      end

      it "made the request to start the job" do
        expect(stubbed_request).to have_been_requested
      end
    end
  end
end

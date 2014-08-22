require "spec_helper"
require "shoulda/matchers"

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
          execution_variables: { job_id: 99, version: "1.0", queue_name: "nexus-4", run_id: "88", tests: ["test one", "test two"] }
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

      its(:command)             { job_attributes[:command] }
      its(:job_id)              { job_attributes[:job_id] }
      its(:repository)          { job_attributes[:repository] }
      its(:execution_directory) { job_attributes[:execution_directory] }
      its(:target)              { job_attributes[:target] }
      its(:execution_variables) { job_attributes[:execution_variables] }
    end
  end
end

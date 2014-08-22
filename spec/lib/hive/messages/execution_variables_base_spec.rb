require "spec_helper"
require "shoulda/matchers"

describe Hive::Messages::ExecutionVariablesBase, type: :model do

  describe "validations" do

    it { should validate_presence_of(:job_id) }
    it { should validate_presence_of(:version) }
    it { should validate_presence_of(:queue_name) }
  end
end

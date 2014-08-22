require "spec_helper"

describe Hive::Messages::Configuration do

  describe "attributes" do

    subject { Hive::Messages::Configuration.new.attributes.keys }

    it { should include(:base_path) }
  end
end

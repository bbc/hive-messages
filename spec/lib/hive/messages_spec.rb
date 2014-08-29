require "spec_helper"

describe Hive::Messages do

  describe "class methods" do

    describe ".configure" do

      let(:base_path) { "http://localhost:3000" }

      before(:each) do
        Hive::Messages.configure do |config|
          config.base_path = base_path
        end
      end

      it "creates a Configuration instance" do
        expect(Hive::Messages.configuration).to be_instance_of(Hive::Messages::Configuration)
      end

      it "set the Hive::Paths.base" do
        expect(Hive::Paths.base).to eq(base_path)
      end

      it "set the base_path on the Configuration" do
        expect(Hive::Messages.configuration.base_path).to eq(base_path)
      end
    end
  end
end

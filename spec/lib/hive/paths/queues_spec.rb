require "spec_helper"

describe Hive::Paths::Queues do

  describe "class methods" do

    let(:base_path) { "http://localhost:3000" }

    before(:each) do
      Hive::Paths.base=base_path
    end

    describe ".job_reservation_path" do

      let(:queues) { ["queue_one", "queue_two"] }

      let(:job_reservation_path) { Hive::Paths::Queues.job_reservation_path(queues) }

      context "single queue name provided" do

        let(:queues) { "queue_one" }

        it "adds the single queue to the reservation path" do
          expect(job_reservation_path).to eq "#{base_path}/api/queues/queue_one/jobs/reserve"
        end
      end

      context "multiple queue names provided" do
        it "adds the provided queues to the reservation path" do
          expect(job_reservation_path).to eq "#{base_path}/api/queues/queue_one,queue_two/jobs/reserve"
        end
      end
    end
  end
end

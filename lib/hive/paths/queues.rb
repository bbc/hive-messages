module Hive
  module Paths

    class Queues

      class << self

        def job_reservation_url(queues)
          queues=[*queues].join(",")
          "#{queues_base}/#{queues}/jobs/reserve"
        end

        private

        def queues_base
          "#{Hive::Paths.base}/api/queues"
        end
      end
    end
  end
end

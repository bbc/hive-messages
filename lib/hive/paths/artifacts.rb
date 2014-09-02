module Hive
  module Paths

    class Artifacts

      class << self

        def create_url(job_id)
          "#{Hive::Paths::Jobs.job_base(job_id)}/artifacts"
        end

        private

        def queues_base
          "#{Hive::Paths.base}/api/queues"
        end
      end
    end
  end
end

module Hive
  module Paths

    class Jobs

      class << self

        def start_url(job_id)
          "#{jobs_base}/#{job_id.to_s}/start"
        end

        def end_url(job_id)
          "#{jobs_base}/#{job_id.to_s}/end"
        end

        private

        def jobs_base
          "#{Hive::Paths.base}/api/jobs"
        end
      end
    end
  end
end

module Hive
  module Paths

    class Jobs

      class << self

        def start_url(job_id)
          "#{job_base(job_id)}/start"
        end

        def update_counts_url(job_id)
          "#{job_base(job_id)}/update_counts"
        end

        def end_url(job_id)
          "#{job_base(job_id)}/end"
        end

        private

        def job_base(job_id)
          "#{jobs_base}/#{job_id.to_s}"
        end

        def jobs_base
          "#{Hive::Paths.base}/api/jobs"
        end
      end
    end
  end
end

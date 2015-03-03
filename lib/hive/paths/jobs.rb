module Hive
  module Paths

    class Jobs

      class << self

        def prepare_url(job_id)
          "#{job_base(job_id)}/prepare"
        end

        def start_url(job_id)
          "#{job_base(job_id)}/start"
        end

        def end_url(job_id)
          "#{job_base(job_id)}/end"
        end
       
        def update_results_url(job_id)
          "#{job_base(job_id)}/update_results"
        end

        def report_artifacts_url(job_id)
          "#{job_base(job_id)}/report_artifacts"
        end
        
        def complete_url(job_id)
          "#{job_base(job_id)}/complete"
        end

        def error_url(job_id)
          "#{job_base(job_id)}/error"
        end

        def job_base(job_id)
          "#{jobs_base}/#{job_id.to_s}"
        end

        private

        def jobs_base
          "#{Hive::Paths.base}/api/jobs"
        end
      end
    end
  end
end

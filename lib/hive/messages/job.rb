require 'hive/messages/nil_job'

module Hive
  module Messages
    class Job < Hive::Messages::Base
      include Hive::Representers::JobRepresenter

      attribute :command, String
      attribute :job_id, Integer
      attribute :repository, String
      attribute :execution_directory, String
      attribute :target, Hash
      attribute :execution_variables, ExecutionVariables
      attribute :reservation_details, Hash
      attribute :device_id, Integer
      attribute :running_count, Integer
      attribute :failed_count, Integer
      attribute :errored_count, Integer
      attribute :passed_count, Integer
      attribute :state, String
      attribute :result, String
      attribute :exit_value, Integer

      validates :command, :job_id, presence: true

      class << self

        def reserve(queues, reservation_details)
          job = self.new
          job.reservation_details = reservation_details
          begin
            job.patch(uri: Hive::Paths::Queues.job_reservation_url(queues), as: "application/json")
          rescue => e
            Hive::Messages::NilJob.new(e)
          end
        end
      end

      def prepare(device_id)
        self.device_id = device_id
        self.patch(uri: Hive::Paths::Jobs.prepare_url(self.job_id), as: "application/json")
      end

      def start
        self.device_id = device_id
        self.patch(uri: Hive::Paths::Jobs.start_url(self.job_id), as: "application/json")
      end

      def end(exit_value)
        self.send("#{exit_value}=", exit_value)
        self.patch(uri: Hive::Paths::Jobs.end_url(self.job_id), as: "application/json")
      end

      def update_results(counts)
        counts = counts.slice(:running_count, :failed_count, :errored_count, :passed_count)
        counts.each_pair do |count_key, count_value|
          self.send("#{count_key}=", count_value)
        end
        self.patch(uri: Hive::Paths::Jobs.update_results_url(self.job_id), as: "application/json")
      end

      def report_artifact(artifact_path)
        url = URI.parse(Hive::Paths::Artifacts.create_url(self.job_id))

        basename = Pathname.new(artifact_path).basename.to_s

        mime =  MimeMagic.by_path(artifact_path)
        mime_type = mime ? mime.type : 'text/plain'

        net_http_args = {:use_ssl => url.instance_of?(URI::HTTPS)}

        if Hive::Messages.configuration.pem_file
          pem = File.read(Hive::Messages.configuration.pem_file)
          net_http_args[:cert] = OpenSSL::X509::Certificate.new(pem)
          net_http_args[:key] = OpenSSL::PKey::RSA.new(pem)
          net_http_args[:verify_mode] = Hive::Messages.configuration.ssl_verify_mode
        end

        File.open(artifact_path) do |artifact|
          req = Net::HTTP::Post::Multipart.new url.path, "data" => UploadIO.new(artifact, mime_type, basename)
          res = Net::HTTP.start(url.host, url.port, net_http_args) do |http|
            http.request(req)
          end
          Hive::Messages::Artifact.new.from_json(res.body)
        end
      end

      def complete
        self.patch(uri: Hive::Paths::Jobs.complete_url(self.job_id), as: "application/json")
      end

      def error
        self.patch(uri: Hive::Paths::Jobs.error_url(self.job_id), as: "application/json")
      end
    end
  end
end

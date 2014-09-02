require 'virtus/attribute/execution_variables'
require 'roar/representer/json'
require 'roar/representer/feature/client'
require 'net/http/post/multipart'
require 'mimemagic'
require 'pathname'

module Hive
  module Messages
    class Job
      include Virtus.model
      include ActiveModel::Validations
      include Roar::Representer::JSON
      include Hive::Representers::JobRepresenter
      include Roar::Representer::Feature::Client

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

      validates :command, :job_id, :repository, :execution_directory, :target, :execution_variables, presence: true

      class << self

        def reserve(queues, reservation_details)
          job = self.new
          job.reservation_details = reservation_details
          job.patch(uri: Hive::Paths::Queues.job_reservation_url(queues), as: "application/json")
        end
      end

      def start(device_id)
        self.device_id = device_id
        self.patch(uri: Hive::Paths::Jobs.start_url(self.job_id), as: "application/json")
      end

      def update_counts(counts)
        counts = counts.slice(:running_count, :failed_count, :errored_count, :passed_count)
        counts.each_pair do |count_key, count_value|
          self.send("#{count_key}=", count_value)
        end
        self.patch(uri: Hive::Paths::Jobs.update_counts_url(self.job_id), as: "application/json")
      end

      def report_artifact(artifact_path)
        url = URI.parse(Hive::Paths::Artifacts.create_url(self.job_id))
        mime =  MimeMagic.by_path(artifact_path)
        basename = Pathname.new(artifact_path).basename.to_s

        File.open(artifact_path) do |artifact|
          req = Net::HTTP::Post::Multipart.new url.path,
                                               "data" => UploadIO.new(artifact, mime.type, basename)
          res = Net::HTTP.start(url.host, url.port) do |http|
            http.request(req)
          end
        end
      end

      def end
        self.patch(uri: Hive::Paths::Jobs.end_url(self.job_id), as: "application/json")
      end

      def error
        self.patch(uri: Hive::Paths::Jobs.error_url(self.job_id), as: "application/json")
      end
    end
  end
end

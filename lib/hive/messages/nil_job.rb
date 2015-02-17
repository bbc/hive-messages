module Hive
  module Messages
    class NilJob
      attr_accessor :exception

      def initialize(exception)
        @message = exception
      end

      def nil?
        true
      end
    end
  end
end

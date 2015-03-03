require "roar/transport/net_http/request"

module Roar
  module Transport
    class NetHTTP
      class Request

        class <<self

          def new(options)
            options[:pem_file] = Hive::Messages.configuration.pem_file
            options[:ssl_verify_mode] = Hive::Messages.configuration.ssl_verify_mode
            super(options)
          end
        end
      end
    end
  end
end

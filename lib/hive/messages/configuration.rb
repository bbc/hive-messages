module Hive
  module Messages

    class Configuration
      include Virtus.model

      attribute :base_path, String
      attribute :pem_file, String
      attribute :ssl_verify_mode, Integer, default: OpenSSL::SSL::VERIFY_PEER
    end
  end
end

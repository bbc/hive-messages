module Hive
  module Messages

    class Configuration
      include Virtus.model

      attribute :base_path, String
    end
  end
end

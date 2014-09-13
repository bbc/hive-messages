require 'virtus/attribute/execution_variables'
require 'roar/representer/json'
require 'roar/representer/feature/client'
require 'net/http/post/multipart'
require 'mimemagic'
require 'pathname'

module Hive
  module Messages
    class Base
      include Virtus.model
      include ::ActiveModel::Validations
      include Roar::Representer::JSON
      include Roar::Representer::Feature::Client

    end
  end
end

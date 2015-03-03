require 'virtus/attribute/execution_variables'
require 'roar/json'
require 'roar/client'
require 'net/http/post/multipart'
require 'mimemagic'
require 'pathname'

module Hive
  module Messages
    class Base
      include Virtus.model
      include ::ActiveModel::Validations
      include Roar::JSON
      include Roar::Client

    end
  end
end

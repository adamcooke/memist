require 'memist/class_methods'
require 'memist/instance_methods'

module Memist
  module Memoizable
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end
  end
end

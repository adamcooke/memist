module Memist
  class Railtie < ::Rails::Railtie
    initializer 'memist.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.alias_method_chain :write_attribute, :memoization_flush
      end
    end
  end
end

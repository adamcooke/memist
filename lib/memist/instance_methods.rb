module Memist
  module InstanceMethods
    def flush_memoization(method = nil, arg = nil)
      return if @memoized_values.nil?

      if method && @memoized_values.key?(method.to_sym)
        if arg.nil?
          @memoized_values.delete(method.to_sym)
        else
          @memoized_values[method.to_sym].delete(arg)
        end
      else
        @memoized_values = nil
      end
    end

    def memoized?(method)
      !!(@memoized_values && @memoized_values.include?(method.to_sym))
    end
  end
end

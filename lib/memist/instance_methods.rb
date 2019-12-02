module Memist
  module InstanceMethods
    def flush_memoization(method = nil, arg = nil)
      return if @memoized_values.nil?

      if method && @memoized_values.key?(method.to_sym)
        flush_memoization_dependencies(method, arg)
        if arg.nil?
          @memoized_values.delete(method.to_sym)
        else
          @memoized_values[method.to_sym].delete(arg)
        end
      elsif method.nil?
        @memoized_values = nil
      end
    end

    def flush_memoization_dependencies(method, arg = nil)
      deps = self.class.memoization_dependencies[method.to_sym]
      return false if deps.nil? || deps.empty?

      deps.each do |dep|
        flush_memoization(dep, arg)
      end
    end

    def memoized?(method)
      !!(@memoized_values && @memoized_values.include?(method.to_sym))
    end

    def without_memoization
      Thread.current[:without_memoization] ||= 0
      Thread.current[:without_memoization] += 1
      yield
    ensure
      Thread.current[:without_memoization] -= 1
    end

    def memoize?
      Thread.current[:without_memoization].nil? ||
      Thread.current[:without_memoization] <= 0
    end
  end
end

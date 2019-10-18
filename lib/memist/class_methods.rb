module Memist
  module ClassMethods
    def memoize(method, options = {})
      if instance_method(method).arity > 1
        raise ArgumentError, "Cannot memoize `#{method}` method because it accepts more than one argument."
      end

      if options[:depends_on].is_a?(Array)
        options[:depends_on].each do |other_method|
          memoization_dependencies[method.to_sym] ||= []
          memoization_dependencies[method.to_sym] << other_method.to_sym
        end
      end

      define_method "#{method}_with_memoization" do |arg = nil|
        @memoized_values ||= Hash.new { |hash, key| hash[key] = {} }
        if @memoized_values.key?(method) && @memoized_values[method].key?(arg)
          @memoized_values[method][arg]
        else
          value = send("#{method}_without_memoization", *arg)
          @memoized_values[method][arg] = value
        end
      end

      define_method "#{method}!" do |arg = nil|
        flush_memoization(method, arg)
        send("#{method}_with_memoization", *arg)
      end

      alias_method "#{method}_without_memoization", method
      alias_method method, "#{method}_with_memoization"
    end

    def memoization_dependencies
      @memoization_dependencies ||= {}
    end
  end
end

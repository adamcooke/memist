module Memist
  module ClassMethods
    def memoize(method)
      if instance_method(method).arity > 1
        raise ArgumentError, "Cannot memoize `#{method}` method because it accepts more than one argument."
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

      alias_method "#{method}!", method
      alias_method "#{method}_without_memoization", method
      alias_method method, "#{method}_with_memoization"
    end
  end
end

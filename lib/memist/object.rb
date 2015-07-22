module Memist

  module ClassMethods
    def memoize(method, options = {})
      if self.instance_method(method).arity > 0
        raise "Cannot memoize `#{method}` method because it accepts an argument."
      end

      define_method "#{method}_with_memoization" do
        @memoized_values ||= {}
        if @memoized_values.has_key?(method)
          @memoized_values[method]
        else
          @memoized_values[method] = send("#{method}_without_memoization")
        end
      end

      self.memoized_methods[method] = options

      if options[:uses].is_a?(Array)
        options[:uses].each do |field|
          self.attributes_to_clear_memoization[field] ||= []
          self.attributes_to_clear_memoization[field] << method

          # Automatically create an override setter to flush the memoization cache
          # whenever the value is set.
          if instance_methods.include?("#{field}=".to_sym) && !instance_methods.include?("#{field}_with_memoization_flush=")
            define_method "#{field}_with_memoization_flush=" do |value|
              self.flush_memoization_by_attribute(field)
              send("#{field}_without_memoization_flush=", value)
            end
            alias_method "#{field}_without_memoization_flush=", "#{field}="
            alias_method "#{field}=", "#{field}_with_memoization_flush="
          end
        end

      end

      alias_method "#{method}_without_memoization", method
      alias_method method, "#{method}_with_memoization"
    end

    def attributes_to_clear_memoization
      @attributes_to_clear_memoization ||= {}
    end

    def memoized_methods
      @memoized_methods ||= {}
    end

  end

  module InstanceMethods
    def write_attribute_with_memoization_flush(attr_name, value)
      flush_memoization_by_attribute(attr_name)
      write_attribute_without_memoization_flush(attr_name, value)
    end

    def flush_memoization_by_attribute(attribute)
      if methods = self.class.attributes_to_clear_memoization[attribute.to_sym]
        methods.each do |method|
          self.flush_memoization_cache(method)
          self.flush_memoization_by_attribute(method)
        end
      end
    end

    def flush_memoization_cache(method = nil)
      if method
        if @memoized_values
          @memoized_values.delete(method)
        end
      else
        @memoized_values = nil
      end
    end
  end

  Object.send :include, InstanceMethods
  Object.extend ClassMethods

end

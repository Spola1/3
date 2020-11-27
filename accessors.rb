# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "#{name}".to_sym
        name_history = "#{name}_history".to_sym

        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |value|
          if instance_variable_get(name_history).nil?
            instance_variable_set(name_history, [])
          else
            instance_variable_get(name_history) << instance_variable_get(var_name)
          end
          instance_variable_set(var_name, value)
        end

        define_method("#{name}_history") do
          instance_variable_get("#{name}_history".to_sym)
        end
      end
    end

    def strong_attr_accessor(attr_name, attr_class)
      var_name = "#{attr_name}".to_sym
      define_method(attr_name) { instance_variable_get(var_name) }

      define_method("#{attr_name}=".to_sym) do |value|
        raise "It's not the same type as attr_class" unless value.is_a? attr_class

        instance_variable_set(var_name, value)
      end
    end
  end
end

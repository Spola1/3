# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validates
    
    def validate(arg_name, type, arguments = {})
      @validates ||= []
      @validates << { arg_name: arg_name, type: type, arguments: arguments }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validates.each do |validation|
        arg_name = instance_variable_get("#{validation[:arg_name]}")
        send("valid_#{validation[:type]}", arg_name, *validation[:arguments])
      end
    end

    def valid?
      check!
    rescue RuntimeError
      false
    end

    def valid_presence(arg_name)
      raise "Пустое значение" if arg_name.empty?
    end

    def valid_format(arg_name, format)
      raise "Неыерный формат" if arg_name !~ format
    end

    def valid_type(arg_name, class_type)
      raise "Не совпадают классы" unless arg_name.class.is_a? class_type
    end
  end
end

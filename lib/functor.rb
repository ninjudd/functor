module Functor
  class Object
    include Functor

    def initialize(method_map = {})
      method_map.each do |method_name, proc|
        define_method method_name, proc
      end
    end

    def method_missing(method_name, proc)
      method_name = method_name.to_s
      if method_name =~ /(.*)=$/
        define_method $1, proc
      else
        unknown_method(method_name)
      end
    end
  end
  
  def self.new(*args)
    Functor::Object.new(*args)
  end

  def define_method(*args, &block)
    method_name, proc_or_value = args
    proc_or_value = block if block_given?
    
    (class << self; self; end).class_eval do
      if proc_or_value.kind_of?(Proc)
        define_method method_name, &proc_or_value
      elsif proc_or_value.nil?
        define_method method_name do |*args|
          unknown_method(method_name)
        end
      else
        define_method method_name do |*args|
          proc_or_value
        end
      end
    end
  end
  
  def unknown_method(method_name='unknown_method')
    raise NoMethodError.new("undefined method `#{method_name}' for #{self}")
  end
end

def functor(*args)
  Functor::Object.new(*args)
end
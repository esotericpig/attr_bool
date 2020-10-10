#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020 Jonathan Bradley Whited (@esotericpig)
# 
# AttrBool is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
# 
# You should have received a copy of the MIT License along with AttrBool.
# If not, see <https://choosealicense.com/licenses/mit/>.
#++


module AttrBool
  ###
  # This works for both +class+ & +module+ because +class+ extends +module+.
  # 
  # Benchmarks are kind of meaningless, but after playing around with some,
  # I found the following to be the case on my system:
  # - +define_method+ is faster than +module_eval+ & +class_eval+
  # - +? true : false+ (ternary operator) is faster than +!!+ (surprisingly)
  # 
  # To run benchmark code:
  #   $ bundle exec rake benchmark
  # 
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.0
  ###
  module Able
    def attr_accessor?(*var_ids,default: nil,reader: nil,writer: nil,&block)
      if block
        reader = block if reader.nil?()
        writer = block if writer.nil?()
      end
      
      if default.nil?() && reader.nil?()
        last = var_ids[-1]
        
        if !last.is_a?(String) && !last.is_a?(Symbol)
          default = var_ids.pop()
        end
      end
      
      attr_reader?(*var_ids,default: default,&reader)
      attr_writer?(*var_ids,&writer)
    end
    
    def attr_reader?(*var_ids,default: nil,&block)
      no_default = (default.nil?() && !block)
      
      if no_default
        last = var_ids[-1]
        
        if !last.is_a?(String) && !last.is_a?(Symbol)
          default = var_ids.pop()
          no_default = false
        end
      end
      
      var_ids.each() do |var_id|
        var_id_q = :"#{var_id}?"
        
        if no_default
          define_method(var_id_q) do
            instance_variable_get(:"@#{var_id}")
          end
        else
          if block
            define_method(var_id_q,&block)
          else
            at_var_id = :"@#{var_id}"
            
            define_method(var_id_q) do
              instance_variable_defined?(at_var_id) ? instance_variable_get(at_var_id) : default
            end
          end
        end
      end
    end
    
    # This should only be used when you want to pass in a block/proc.
    def attr_writer?(*var_ids,&block)
      if block
        var_ids.each() do |var_id|
          define_method(:"#{var_id}=",&block)
        end
      else
        last = var_ids[-1]
        
        if !last.is_a?(String) && !last.is_a?(Symbol)
          raise ArgumentError,'default value not allowed for writer'
        end
        
        attr_writer(*var_ids)
      end
    end
    
    def attr_bool(*var_ids,default: nil,reader: nil,writer: nil,&block)
      if block
        reader = block if reader.nil?()
        writer = block if writer.nil?()
      end
      
      if default.nil?() && reader.nil?()
        last = var_ids[-1]
        
        if !last.is_a?(String) && !last.is_a?(Symbol)
          default = var_ids.pop()
        end
      end
      
      attr_bool?(*var_ids,default: default,&reader)
      attr_booler(*var_ids,&writer)
    end
    alias_method :attr_boolor,:attr_bool
    
    def attr_bool?(*var_ids,default: nil,&block)
      no_default = default.nil?()
      
      if no_default
        no_default = !block
        
        if no_default
          last = var_ids[-1]
          
          if !last.is_a?(String) && !last.is_a?(Symbol)
            default = var_ids.pop() ? true : false
            no_default = false
          end
        end
      else
        default = default ? true : false
      end
      
      var_ids.each() do |var_id|
        var_id_q = :"#{var_id}?"
        
        if no_default
          define_method(var_id_q) do
            instance_variable_get(:"@#{var_id}") ? true : false
          end
        else
          if block
            define_method(var_id_q,&block)
          else
            at_var_id = :"@#{var_id}"
            
            define_method(var_id_q) do
              if instance_variable_defined?(at_var_id)
                instance_variable_get(at_var_id) ? true : false
              else
                default
              end
            end
          end
        end
      end
    end
    
    def attr_booler(*var_ids,&block)
      if !block
        last = var_ids[-1]
        
        if !last.is_a?(String) && !last.is_a?(Symbol)
          raise ArgumentError,'default value not allowed for writer'
        end
      end
      
      var_ids.each() do |var_id|
        var_id_eq = :"#{var_id}="
        
        if block
          define_method(var_id_eq,&block)
        else
          define_method(var_id_eq) do |value|
            instance_variable_set(:"@#{var_id}",value ? true : false)
          end
        end
      end
    end
    
    # @!macro attach attr_reader?
    #   @!method $1?
    #   @return [Boolean] whether +$1+ or not
    
    # @!macro attach attr_writer?
    #   @!method $1=(value)
    #   Sets +$1+ to +true+ or +false+.
    #   @param value [Boolean] the new value of +$1+
    
    # @!macro attach attr_accessor?
    #   @!method $1?
    #     @!macro attach attr_reader?
    #   @!method $1=(value)
    #     @!macro attach attr_writer?
    
    # @!macro attach attr_bool?
    #   @!method $1?
    #   @return [true,false] whether +$1+ or not
    
    # @!macro attach attr_booler
    #   @!method $1=(value)
    #   Sets +$1+ to +true+ or +false+.
    #   @param value [true,false] the new value of +$1+
    
    # @!macro attach attr_bool
    #   @!method $1?
    #     @!macro attach attr_bool?
    #   @!method $1=(value)
    #     @!macro attach attr_booler
    
    # @!macro attach attr_boolor
    #   @!macro attach attr_bool
  end
end
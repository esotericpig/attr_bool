# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020 Bradley Whited
#
# SPDX-License-Identifier: MIT
#++

require 'attr_bool/version'

##
# TODO: simple example
module AttrBool
  ##
  # TODO: simple example
  module Ext
    #--
    # NOTE: Not using `self.` for extended/included/prepended() so that including a module that extends
    #       `AttrBool::Ext` works without having to extend `AttrBool::Ext` again.
    #++

    def extended(mod)
      super
      mod.extend(AttrBool::Ext) unless mod.singleton_class.ancestors.include?(AttrBool::Ext)
    end

    def included(mod)
      super
      mod.extend(AttrBool::Ext) unless mod.singleton_class.ancestors.include?(AttrBool::Ext)
    end

    def prepended(mod)
      super
      mod.extend(AttrBool::Ext) unless mod.singleton_class.ancestors.include?(AttrBool::Ext)
    end

    def attr_accessor?(*names,reader: nil,writer: nil)
      return __attr_bool(names,reader: reader,writer: writer)
    end

    def attr_reader?(*names,&reader)
      return __attr_bool(names,reader: reader)
    end

    def attr_writer?(*names,&writer)
      return __attr_bool(names,writer: writer)
    end

    def attr_bool(*names,reader: nil,writer: nil)
      return __attr_bool(names,reader: reader,writer: writer,force_bool: true)
    end

    def attr_bool?(*names,&reader)
      return __attr_bool(names,reader: reader,force_bool: true)
    end

    def attr_bool!(*names,&writer)
      return __attr_bool(names,writer: writer,force_bool: true)
    end

    private

    def __attr_bool(names,reader: false,writer: false,force_bool: false)
      # For DSL chaining, must return the method names created, like core `attr_accessor`/etc. does.
      # Example: protected attr_bool :banana_hammock
      method_names = []

      # noinspection RubySimplifyBooleanInspection
      names.map do |name|
        ivar = :"@#{name}"

        if reader != false # false, nil, or Proc.
          name_q = :"#{name}?"
          method_names << name_q

          if reader # Proc?
            if force_bool
              define_method(name_q) { instance_exec(&reader) ? true : false }
            else
              define_method(name_q,&reader)
            end
          else # nil?
            instance_variable_get(ivar) # Fail fast if `ivar` is invalid.

            if force_bool
              define_method(name_q) { instance_variable_get(ivar) ? true : false }
            else
              define_method(name_q) { instance_variable_get(ivar) }
            end
          end
        end

        if writer != false # false, nil, or Proc.
          name_eq = :"#{name}="
          method_names << name_eq

          if writer # Proc?
            if force_bool
              define_method(name_eq) { |value| instance_exec(value ? true : false,&writer) }
            else
              define_method(name_eq,&writer)
            end
          else # nil?
            instance_variable_get(ivar) # Fail fast if `ivar` is invalid.

            if force_bool
              define_method(name_eq) { |value| instance_variable_set(ivar,value ? true : false) }
            else
              define_method(name_eq) { |value| instance_variable_set(ivar,value) }
            end
          end
        end
      end

      return method_names
    end
  end

  ##
  # TODO: simple example
  module Ref
    refine Module do
      import_methods AttrBool::Ext
    end
  end
end

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
# Example usage:
# ```
# require 'attr_bool'
#
# class TheTodd
#   extend AttrBool::Ext
#   #using AttrBool::Ref  # Can use refinements instead.
#
#   # Can use multiple symbols and/or strings.
#   attr_accessor? :flexing, 'bounce_pecs'
#
#   # Can do DSL chaining.
#   protected attr_accessor? :high_five, 'fist_bump'
#
#   # Can do custom logic.
#   attr_accessor? :headband, 'banana_hammock',
#                  reader: -> { @wearing == :flaming },
#                  writer: ->(value) { @wearing = value }
#
#   attr_reader?(:cat_fights)    { @cat_fights % 69 }
#   attr_writer?(:hot_surgeries) { |count| @hot_surgeries += count }
#
#   # Can force bool values (i.e., only `true` or `false`).
#   attr_bool  :carla_kiss   # Accessor.
#   attr_bool? :elliot_kiss  # Reader.
#   attr_bool! :thumbs_up    # Writer.
# end
# ```
module AttrBool
  ##
  # Example usage:
  # ```
  # class TheTodd
  #   extend AttrBool::Ext
  #
  #   attr_accessor? :headband
  #   attr_reader?   :banana_hammock
  #   attr_writer?   :high_five
  #
  #   attr_bool      :bounce_pecs
  #   attr_bool?     :cat_fight
  #   attr_bool!     :hot_tub
  # end
  # ```
  module Ext
    #--
    # NOTE: Not using `self.` for extended/included/prepended() so that including a module that extends
    #       `AttrBool::Ext` works without having to extend `AttrBool::Ext` again.
    #++

    def extended(mod)
      super
      __attr_bool_extended(mod)
    end

    def included(mod)
      super
      __attr_bool_extended(mod)
    end

    def prepended(mod)
      super
      __attr_bool_extended(mod)
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

    def __attr_bool_extended(mod)
      mod.extend(AttrBool::Ext) unless mod.singleton_class.ancestors.include?(AttrBool::Ext)
    end

    def __attr_bool(names,reader: false,writer: false,force_bool: false)
      # For DSL chaining, must return the method names created, like core `attr_accessor`/etc. does.
      # Example: protected attr_bool :banana_hammock,:bounce_pecs
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
  # Example usage:
  # ```
  # module TheToddMod
  #   using AttrBool::Ref
  #
  #   class TheTodd
  #     attr_accessor? :headband
  #     attr_reader?   :banana_hammock
  #     attr_writer?   :high_five
  #
  #     attr_bool      :bounce_pecs
  #     attr_bool?     :cat_fight
  #     attr_bool!     :hot_tub
  #   end
  # end
  # ```
  module Ref
    # This works for both classes & modules because Class is a child of Module.
    refine Module do
      import_methods AttrBool::Ext

      # NOTE: JRuby (and maybe other implementations?) has a bug with importing methods that internally
      #       call other refined methods, so this is the workaround.
      if RUBY_PLATFORM == 'java'
        def extended(mod)
          super
          __attr_bool_extended(mod)
        end

        def included(mod)
          super
          __attr_bool_extended(mod)
        end

        def prepended(mod)
          super
          __attr_bool_extended(mod)
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
      end
    end
  end
end

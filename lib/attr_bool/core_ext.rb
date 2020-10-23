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


require 'attr_bool'

module AttrBool
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.0
  ###
  module Ext
  end
end

# This works for both +class+ & +module+ because +class+ extends +module+.
Module.prepend AttrBool::Able

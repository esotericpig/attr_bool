#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020-2021 Jonathan Bradley Whited
#
# SPDX-License-Identifier: MIT
#++


require 'attr_bool'

module AttrBool
  ###
  # @author Jonathan Bradley Whited
  # @since  0.2.0
  ###
  module CoreExt
  end
end

# This works for both +class+ & +module+ because +class+ extends +module+.
Module.prepend AttrBool::Ext

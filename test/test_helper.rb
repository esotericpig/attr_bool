# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020 Bradley Whited
#
# SPDX-License-Identifier: MIT
#++

require 'minitest/autorun'
require 'simplecov'

SimpleCov.start do
  enable_coverage :branch
end

require 'attr_bool'

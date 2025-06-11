# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020 Bradley Whited
#
# SPDX-License-Identifier: MIT
#++

require 'test_helper'

require 'attr_bool/core_ext'

class CoreExtTest < TestHelper
  def setup
    @bag = TestBag.new
  end

  def test_core_ext
    @bag.acc    = true
    @bag.write  = true
    @bag.bool   = true
    @bag.booler = true
    @bag.boolor = true

    assert_equal true ,@bag.acc?
    assert_nil   @bag.read?
    assert_equal true ,@bag.bool?
    assert_equal false,@bag.boolq?
    assert_equal true ,@bag.boolor?
  end

  class TestBag
    attr_accessor? :acc
    attr_reader?   :read
    attr_writer?   :write
    attr_bool      :bool
    attr_bool?     :boolq
    attr_booler    :booler
    attr_boolor    :boolor
  end
end

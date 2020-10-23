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


require 'test_helper'

require 'attr_bool/core_ext'

###
# @author Jonathan Bradley Whited (@esotericpig)
# @since  0.2.0
###
class CoreExtTest < TestHelper
  def setup()
    @bag = TestBag.new()
  end
  
  def test_core_ext()
    @bag.acc    = true
    @bag.write  = true
    @bag.bool   = true
    @bag.booler = true
    @bag.boolor = true
    
    assert_equal true ,@bag.acc?()
    assert_nil   @bag.read?()
    assert_equal true ,@bag.bool?()
    assert_equal false,@bag.boolq?()
    assert_equal true ,@bag.boolor?()
  end
  
  ###
  # @author Jonathan Bradley Whited (@esotericpig)
  # @since  0.2.0
  ###
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

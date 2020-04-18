#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of attr_bool.
# Copyright (c) 2020 Jonathan Bradley Whited (@esotericpig)
# 
# attr_bool is free software: you can redistribute it and/or modify it under
# the terms of the MIT License.
# 
# You should have received a copy of the MIT License along with attr_bool.
# If not, see <https://choosealicense.com/licenses/mit/>.
#++


require 'minitest/autorun'

require 'attr_bool'


###
# @author Jonathan Bradley Whited (@esotericpig)
# @since  0.1.0
###
class TestBag
  attr_accessor :hidden
  
  def initialize()
    @hidden = 0
    
    @acc = nil
    @acc5 = nil
    @acc6 = nil
    @acc15 = nil
    @acc16 = nil
    @acc17 = nil
  end
  
  attr_accessor? :doc_acc    # @!macro attach attr_accessor?
  attr_reader?   :doc_read   # @!macro attach attr_reader?
  attr_writer?   :doc_write  # @!macro attach attr_writer?
  attr_bool      :doc_bool   # @!macro attach attr_bool
  attr_bool?     :doc_boolq  # @!macro attach attr_bool?
  attr_booler    :doc_booler # @!macro attach attr_booler
  attr_boolor    :doc_boolor # @!macro attach attr_boolor
  
  attr_accessor? :acc
  attr_accessor? :acc1,1
  attr_accessor? :acc2,default: 2
  attr_accessor?(:acc3,
    reader_block: lambda { @acc3.odd?() },
    writer_block: lambda {|value| @acc3 = value + 1}
  )
  attr_accessor?(:acc4) do |value=nil|
    @acc4 = value + 1 unless value.nil?()
    @acc4.odd?()
  end
  
  attr_accessor? :acc5 ,:acc6
  attr_accessor? :acc7 ,:acc8,78
  attr_accessor? :acc9 ,:acc10,default: 910
  attr_accessor?(:acc11,:acc12,
    reader_block: lambda { @hidden.odd?() },
    writer_block: lambda {|value| @hidden = value + 1}
  )
  attr_accessor?(:acc13,:acc14) do |value=nil|
    @hidden = value + 1 unless value.nil?()
    @hidden.odd?()
  end
  
  attr_accessor? 'acc15'
  attr_accessor? 'acc16','acc17'
  attr_accessor? 'acc18',default: 'str'
  attr_accessor? 'acc19','acc20',default: 'str'
  attr_accessor? 'acc21',default: :sym
  attr_accessor? 'acc22','acc23',default: :sym
  
  attr_bool :boo
  attr_bool :boo1,1
  attr_bool :boo2,default: 2
  attr_bool(:boo3,
    reader_block: lambda { @boo3.odd?() },
    writer_block: lambda {|value| @boo3 = value + 1}
  )
  attr_bool(:boo4) do |value=nil|
    @boo4 = value + 1 unless value.nil?()
    @boo4.odd?()
  end
  
  attr_bool :boo5 ,:boo6
  attr_bool :boo7 ,:boo8,78
  attr_bool :boo9 ,:boo10,default: 910
  attr_bool(:boo11,:boo12,
    reader_block: lambda { @hidden.odd?() },
    writer_block: lambda {|value| @hidden = value + 1}
  )
  attr_bool(:boo13,:boo14) do |value=nil|
    @hidden = value + 1 unless value.nil?()
    @hidden.odd?()
  end
  
  attr_bool 'boo15'
  attr_bool 'boo16','boo17'
  attr_bool 'boo18',default: 'str'
  attr_bool 'boo19','boo20',default: 'str'
  attr_bool 'boo21',default: :sym
  attr_bool 'boo22','boo23',default: :sym
  
  attr_boolor :bor
end

###
# @author Jonathan Bradley Whited (@esotericpig)
# @since  0.1.0
###
class AttrBoolTest < Minitest::Test
  def setup()
    @bag = TestBag.new()
  end
  
  def test_attr_accessor()
    assert_nil @bag.acc?()
    @bag.acc = true
    assert_equal true,@bag.acc?()
    
    assert_equal 1,@bag.acc1?()
    assert_equal 2,@bag.acc2?()
    
    @bag.acc3 = 0
    assert_equal true,@bag.acc3?()
    
    @bag.acc4 = 0
    assert_equal true,@bag.acc4?()
    
    assert_nil @bag.acc5?()
    assert_nil @bag.acc6?()
    @bag.acc5 = @bag.acc6 = true
    assert_equal true,@bag.acc5?()
    assert_equal true,@bag.acc6?()
    
    assert_equal 78,@bag.acc7?()
    assert_equal 78,@bag.acc8?()
    assert_equal 910,@bag.acc9?()
    assert_equal 910,@bag.acc10?()
    
    @bag.acc11 = @bag.acc12 = 0
    assert_equal true,@bag.acc11?()
    assert_equal true,@bag.acc12?()
    
    @bag.acc13 = @bag.acc14 = 0
    assert_equal true,@bag.acc13?()
    assert_equal true,@bag.acc14?()
    
    assert_nil @bag.acc15?()
    assert_nil @bag.acc16?()
    assert_nil @bag.acc17?()
    @bag.acc15 = @bag.acc16 = @bag.acc17 = true
    assert_equal true,@bag.acc15?()
    assert_equal true,@bag.acc16?()
    assert_equal true,@bag.acc17?()
    
    assert_equal 'str',@bag.acc18?()
    assert_equal 'str',@bag.acc19?()
    assert_equal 'str',@bag.acc20?()
    @bag.acc18 = @bag.acc19 = @bag.acc20 = true
    assert_equal true,@bag.acc18?()
    assert_equal true,@bag.acc19?()
    assert_equal true,@bag.acc20?()
    
    assert_equal :sym,@bag.acc21?()
    assert_equal :sym,@bag.acc22?()
    assert_equal :sym,@bag.acc23?()
    @bag.acc21 = @bag.acc22 = @bag.acc23 = true
    assert_equal true,@bag.acc21?()
    assert_equal true,@bag.acc22?()
    assert_equal true,@bag.acc23?()
  end
  
  def test_attr_bool()
    assert_equal false,@bag.boo?()
    @bag.boo = true
    assert_equal true,@bag.boo?()
    
    assert_equal true,@bag.boo1?()
    assert_equal true,@bag.boo2?()
    
    @bag.boo3 = 0
    assert_equal true,@bag.boo3?()
    
    @bag.boo4 = 0
    assert_equal true,@bag.boo4?()
    
    assert_equal false,@bag.boo5?()
    assert_equal false,@bag.boo6?()
    @bag.boo5 = @bag.boo6 = true
    assert_equal true,@bag.boo5?()
    assert_equal true,@bag.boo6?()
    
    assert_equal true,@bag.boo7?()
    assert_equal true,@bag.boo8?()
    assert_equal true,@bag.boo9?()
    assert_equal true,@bag.boo10?()
    
    @bag.boo11 = @bag.boo12 = 0
    assert_equal true,@bag.boo11?()
    assert_equal true,@bag.boo12?()
    
    @bag.boo13 = @bag.boo14 = 0
    assert_equal true,@bag.boo13?()
    assert_equal true,@bag.boo14?()
    
    assert_equal false,@bag.boo15?()
    assert_equal false,@bag.boo16?()
    assert_equal false,@bag.boo17?()
    @bag.boo15 = @bag.boo16 = @bag.boo17 = true
    assert_equal true,@bag.boo15?()
    assert_equal true,@bag.boo16?()
    assert_equal true,@bag.boo17?()
    
    assert_equal true,@bag.boo18?()
    assert_equal true,@bag.boo19?()
    assert_equal true,@bag.boo20?()
    @bag.boo18 = @bag.boo19 = @bag.boo20 = nil
    assert_equal false,@bag.boo18?()
    assert_equal false,@bag.boo19?()
    assert_equal false,@bag.boo20?()
    
    assert_equal true,@bag.boo21?()
    assert_equal true,@bag.boo22?()
    assert_equal true,@bag.boo23?()
    @bag.boo21 = @bag.boo22 = @bag.boo23 = nil
    assert_equal false,@bag.boo21?()
    assert_equal false,@bag.boo22?()
    assert_equal false,@bag.boo23?()
  end
  
  def test_attr_boolor()
    @bag.bor = true
    assert_equal true,@bag.bor?()
  end
end

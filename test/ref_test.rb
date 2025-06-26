# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2025 Bradley Whited
#
# SPDX-License-Identifier: MIT
#++

require 'test_helper'

describe AttrBool::Ref do
  def self.it_has_the_attr_bools
    it 'does not refine the core Class & Module outside of its scope' do
      _(Class.used_modules).wont_include(AttrBool::Ref)
      _(Module.used_modules).wont_include(AttrBool::Ref)

      expect do
        Class.new do
          attr_bool :acc01
        end
      end.must_raise(NoMethodError)
      expect do
        Module.new do
          attr_bool :acc01
        end
      end.must_raise(NoMethodError)
    end

    it 'has the attr accessors' do
      _(@sut).must_respond_to(:acc01=)
      _(@sut).must_respond_to(:acc02=)

      @sut.acc01 = :acc01_value
      @sut.acc02 = :acc02_value

      _(@sut.acc01?).must_equal(:acc01_value)
      _(@sut.acc02?).must_equal(true)
    end

    it 'has the attr readers' do
      _(@sut.read01?).must_equal(:read01_value)
      _(@sut.read02?).must_equal(true)
    end

    it 'has the attr writers' do
      _(@sut).must_respond_to(:write01=)
      _(@sut).must_respond_to(:write02=)

      @sut.write01 = :write01_value
      @sut.write02 = :write02_value

      _(@sut.instance_variable_get(:@write01)).must_equal(:write01_value)
      _(@sut.instance_variable_get(:@write02)).must_equal(true)
    end
  end

  describe 'refined class' do
    before do
      @sut = RefTest::TestBag.new
    end

    it_has_the_attr_bools

    if RUBY_PLATFORM != 'java'
      it 'refines the core Class & Module inside of its scope only once' do
        _(RefTest::TestBag.class_used_modules.count(AttrBool::Ref)).must_equal(1)
        _(RefTest::TestBag.module_used_modules.count(AttrBool::Ref)).must_equal(1)
      end
    end
  end

  describe 'refined module' do
    before do
      @sut = RefTest::TestBagWithMixin.new
    end

    it_has_the_attr_bools

    if RUBY_PLATFORM != 'java'
      it 'refines the core Class & Module inside of its scope only once' do
        _(@sut.class_used_modules.count(AttrBool::Ref)).must_equal(1)
        _(@sut.module_used_modules.count(AttrBool::Ref)).must_equal(1)
      end
    end
  end
end

module RefTest
  using AttrBool::Ref

  class TestBag
    attr_accessor? :acc01
    attr_bool      :acc02
    attr_reader?   :read01
    attr_bool?     :read02
    attr_writer?   :write01
    attr_bool!     :write02

    def initialize
      super

      @read01 = :read01_value
      @read02 = :read02_value
    end

    def self.class_used_modules
      return Class.used_modules
    end

    def self.module_used_modules
      return Module.used_modules
    end
  end

  module TestBagMixin
    attr_accessor? :acc01
    attr_bool      :acc02
    attr_reader?   :read01
    attr_bool?     :read02
    attr_writer?   :write01
    attr_bool!     :write02

    def initialize
      super

      @read01 = :read01_value
      @read02 = :read02_value
    end

    def class_used_modules
      return Class.used_modules
    end

    def module_used_modules
      return Module.used_modules
    end
  end

  class TestBagWithMixin
    include TestBagMixin
  end
end

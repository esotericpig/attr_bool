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

describe 'attr_bool/core_ext' do
  it 'monkey-patches the core Class & Module only once' do
    _(Class.ancestors.count(AttrBool::Ext)).must_equal(1)
    _(Module.ancestors.count(AttrBool::Ext)).must_equal(1)
  end

  def self.it_has_the_attr_bools
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

  describe 'core class' do
    before do
      @sut = CoreExtTest::TestBag.new
    end

    it_has_the_attr_bools
  end

  describe 'core module' do
    before do
      @sut = CoreExtTest::TestBagWithMixin.new
    end

    it_has_the_attr_bools
  end
end

module CoreExtTest
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
  end

  class TestBagWithMixin
    include TestBagMixin
  end
end

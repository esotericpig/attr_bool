# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020 Bradley Whited
#
# SPDX-License-Identifier: MIT
#++

require 'test_helper'

describe AttrBool::Ext do
  it 'does not monkey-patch the core Class & Module by default' do
    _(Class.ancestors).wont_include(AttrBool::Ext)
    _(Module.ancestors).wont_include(AttrBool::Ext)

    # rubocop:disable Lint/ConstantDefinitionInBlock
    expect do
      class BadTestBag
        attr_bool :acc01
      end
    end.must_raise(NoMethodError)
    expect do
      module BadTestBagMixin
        attr_bool :acc01
      end
    end.must_raise(NoMethodError)
    # rubocop:enable all

    %i[BadTestBag BadTestBagMixin].each do |name|
      Object.send(:remove_const,name) if Object.const_defined?(name)
    end
  end

  def self.it_has_the_attr_bools
    it 'has the attr accessors' do
      @sut.acc01 = :acc01_value
      @sut.acc02 = :acc02_value
      @sut.acc03 = :acc0304_value
      @sut.acc04 = :acc0304_value

      _(@sut.acc01?).must_equal(:acc01_value)
      _(@sut.acc02?).must_equal(:acc02_value)
      _(@sut.acc03?).must_equal(:acc0304_value)
      _(@sut.acc04?).must_equal(:acc0304_value)

      @sut.acc07 = :acc07_value
      @sut.acc08 = :acc08_value
      @sut.acc09 = :acc0910_value
      @sut.acc10 = :acc0910_value

      _(@sut.acc07?).must_equal(true)
      _(@sut.acc08?).must_equal(true)
      _(@sut.acc09?).must_equal(true)
      _(@sut.acc10?).must_equal(true)
    end

    it 'has the private attr accessors' do
      pub_methods = @sut.public_methods
      priv_methods = @sut.private_methods

      [
        ['acc05',:acc05_value],
        ['acc06',:acc06_value],
        ['acc11',true],
        ['acc12',true],
      ].each do |name,exp_value|
        name_q = :"#{name}?"
        name_eq = :"#{name}="

        _(pub_methods).wont_include(name_q)
        _(pub_methods).wont_include(name_eq)

        _(priv_methods).must_include(name_q)
        _(priv_methods).must_include(name_eq)

        @sut.send(name_eq,:"#{name}_value")

        _(@sut.send(name_q)).must_equal(exp_value)
      end
    end

    it 'has the attr readers' do
      _(@sut.read01?).must_equal(:read01_value)
      _(@sut.read02?).must_equal(:read02_value)
      _(@sut.read03?).must_equal(:read0304_value)
      _(@sut.read04?).must_equal(:read0304_value)

      _(@sut.read07?).must_equal(true)
      _(@sut.read08?).must_equal(true)
      _(@sut.read09?).must_equal(true)
      _(@sut.read10?).must_equal(true)
    end

    it 'has the private attr readers' do
      pub_methods = @sut.public_methods
      priv_methods = @sut.private_methods

      [
        ['read05',:read05_value],
        ['read06',:read06_value],
        ['read11',true],
        ['read12',true],
      ].each do |name,exp_value|
        name_q = :"#{name}?"

        _(pub_methods).wont_include(name_q)
        _(priv_methods).must_include(name_q)

        @sut.instance_variable_set(:"@#{name}",:"#{name}_value")

        _(@sut.send(name_q)).must_equal(exp_value)
      end
    end

    it 'has the attr writers' do
      @sut.write01 = :write01_value
      @sut.write02 = :write02_value
      @sut.write03 = :write0304_value
      @sut.write04 = :write0304_value

      _(@sut.instance_variable_get(:@write01)).must_equal(:write01_value)
      _(@sut.instance_variable_get(:@write02)).must_equal(:write02_value)
      _(@sut.instance_variable_get(:@write0304)).must_equal(:write0304_value)

      @sut.write07 = :write07_value
      @sut.write08 = :write08_value
      @sut.write09 = :write0910_value
      @sut.write10 = :write0910_value

      _(@sut.instance_variable_get(:@write07)).must_equal(true)
      _(@sut.instance_variable_get(:@write08)).must_equal(true)
      _(@sut.instance_variable_get(:@write0910)).must_equal(true)
    end

    it 'has the private attr writers' do
      pub_methods = @sut.public_methods
      priv_methods = @sut.private_methods

      [
        ['write05',:write05_value],
        ['write06',:write06_value],
        ['write11',true],
        ['write12',true],
      ].each do |name,exp_value|
        name_eq = :"#{name}="

        _(pub_methods).wont_include(name_eq)
        _(priv_methods).must_include(name_eq)

        @sut.send(name_eq,:"#{name}_value")

        _(@sut.instance_variable_get(:"@#{name}")).must_equal(exp_value)
      end
    end
  end

  describe 'extended class' do
    before do
      @sut = ExtTest::TestBag.new
    end

    it_has_the_attr_bools
  end

  describe 'extended class child' do
    before do
      @sut = ExtTest::TestBagChild.new
    end

    it_has_the_attr_bools

    it 'has the child attr bools' do
      _(@sut.read13?).must_equal(true)
    end
  end

  describe 'extended module' do
    before do
      @sut = ExtTest::TestBagWithMixin.new
    end

    it_has_the_attr_bools
  end

  describe 'extended module child' do
    before do
      @sut = ExtTest::TestBagWithMixinChild.new
    end

    it_has_the_attr_bools

    it 'has the child attr bools' do
      _(@sut.read13?).must_equal(true)
      _(@sut.read14?).must_equal(true)
    end
  end

  describe 'extended module that was prepended' do
    before do
      @sut = ExtTest::TestBagWithMixinPrepended.new
    end

    it_has_the_attr_bools

    it 'has the child attr bools' do
      _(@sut.read13?).must_equal(true)
    end
  end

  describe 'invalid attr names' do
    it 'fails fast for attr_accessor?' do
      expect do
        Class.new do
          extend AttrBool::Ext

          attr_accessor? 'bad name'
        end
      end.must_raise(NameError)
    end

    it 'fails fast for attr_reader?' do
      expect do
        Class.new do
          extend AttrBool::Ext

          attr_reader? 'bad name'
        end
      end.must_raise(NameError)
    end

    it 'fails fast for attr_writer?' do
      expect do
        Class.new do
          extend AttrBool::Ext

          attr_writer? 'bad name'
        end
      end.must_raise(NameError)
    end

    it 'fails fast for attr_bool' do
      expect do
        Class.new do
          extend AttrBool::Ext

          attr_bool 'bad name'
        end
      end.must_raise(NameError)
    end

    it 'fails fast for attr_bool?' do
      expect do
        Class.new do
          extend AttrBool::Ext

          attr_bool? 'bad name'
        end
      end.must_raise(NameError)
    end

    it 'fails fast for attr_bool!' do
      expect do
        Class.new do
          extend AttrBool::Ext

          attr_bool! 'bad name'
        end
      end.must_raise(NameError)
    end
  end
end

# rubocop:disable Style/AccessModifierDeclarations
# noinspection RubyArgCount, RubyMismatchedArgumentType
module ExtTest
  class TestBag
    extend AttrBool::Ext

    attr_accessor? :acc01,'acc02'
    attr_accessor? :acc03,'acc04',
                   reader: -> { @acc0304 },
                   writer: ->(value) { @acc0304 = value }
    private attr_accessor? :acc05,'acc06'

    attr_bool :acc07,'acc08'
    attr_bool :acc09,'acc10',
              reader: -> { @acc0910 },
              writer: ->(value) { @acc0910 = value }
    private attr_bool :acc11,'acc12'

    attr_reader? :read01,'read02'
    attr_reader?(:read03,'read04') { @read0304 }
    private attr_reader? :read05,'read06'

    attr_bool? :read07,'read08'
    attr_bool?(:read09,'read10') { @read0910 }
    private attr_bool? :read11,'read12'

    attr_writer? :write01,'write02'
    attr_writer?(:write03,'write04') { |value| @write0304 = value }
    private attr_writer? :write05,'write06'

    attr_bool! :write07,'write08'
    attr_bool!(:write09,'write10') { |value| @write0910 = value }
    private attr_bool! :write11,'write12'

    def initialize
      super

      @read01 = :read01_value
      @read02 = :read02_value
      @read0304 = :read0304_value
      @read05 = :read05_value
      @read06 = :read06_value

      @read07 = :read07_value
      @read08 = :read08_value
      @read0910 = :read0910_value
      @read11 = :read11_value
      @read12 = :read12_value
    end
  end

  class TestBagChild < TestBag
    attr_bool? :read13

    def initialize
      super

      @read13 = :read13_value
    end
  end

  module TestBagMixin
    extend AttrBool::Ext

    attr_accessor? :acc01,'acc02'
    attr_accessor? :acc03,'acc04',
                   reader: -> { @acc0304 },
                   writer: ->(value) { @acc0304 = value }
    private attr_accessor? :acc05,'acc06'

    attr_bool :acc07,'acc08'
    attr_bool :acc09,'acc10',
              reader: -> { @acc0910 },
              writer: ->(value) { @acc0910 = value }
    private attr_bool :acc11,'acc12'

    attr_reader? :read01,'read02'
    attr_reader?(:read03,'read04') { @read0304 }
    private attr_reader? :read05,'read06'

    attr_bool? :read07,'read08'
    attr_bool?(:read09,'read10') { @read0910 }
    private attr_bool? :read11,'read12'

    attr_writer? :write01,'write02'
    attr_writer?(:write03,'write04') { |value| @write0304 = value }
    private attr_writer? :write05,'write06'

    attr_bool! :write07,'write08'
    attr_bool!(:write09,'write10') { |value| @write0910 = value }
    private attr_bool! :write11,'write12'

    def initialize
      super

      @read01 = :read01_value
      @read02 = :read02_value
      @read0304 = :read0304_value
      @read05 = :read05_value
      @read06 = :read06_value

      @read07 = :read07_value
      @read08 = :read08_value
      @read0910 = :read0910_value
      @read11 = :read11_value
      @read12 = :read12_value
    end
  end

  class TestBagWithMixin
    include TestBagMixin

    attr_bool? :read13

    def initialize
      super

      @read13 = :read13_value
    end
  end

  module TestBagMixinChild
    include TestBagMixin

    attr_bool? :read13

    def initialize
      super

      @read13 = :read13_value
    end
  end

  class TestBagWithMixinChild
    include TestBagMixinChild

    attr_bool? :read14

    def initialize
      super

      @read14 = :read14_value
    end
  end

  class TestBagWithMixinPrepended
    prepend TestBagMixin

    attr_bool? :read13

    def initialize
      super

      @read13 = :read13_value
    end
  end
end
# rubocop:enable all

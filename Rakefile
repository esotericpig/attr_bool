# encoding: UTF-8
# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'attr_bool/version'
require 'benchmark'
require 'rake/clean'
require 'rake/testtask'
require 'rdoc/task'

CLEAN.exclude('{.git,.github,.idea,stock}/**/*')
CLOBBER.include('doc/')

task default: %i[test]

desc 'Run all tests'
task test: %i[test:base test:core_ext]

TEST_DIR = 'test/**'
CORE_EXT_TEST = 'core_ext_test.rb'

namespace :test do
  {
    base: FileList["#{TEST_DIR}/*_test.rb"].exclude("**/#{CORE_EXT_TEST}"),
    core_ext: FileList["#{TEST_DIR}/#{CORE_EXT_TEST}"],
  }.each do |name,test_files|
    Rake::TestTask.new(name) do |t|
      t.libs = ['lib','test']
      t.test_files = test_files
      t.warning = true
      t.verbose = false
    end
  end
end

RDoc::Task.new(:doc) do |t|
  t.rdoc_dir = 'doc'
  t.title = "AttrBool v#{AttrBool::VERSION}"
end

# Benchmarks are kind of meaningless, but after playing around with some,
# I found the following to be true on my system:
# - define_method() is faster than class/module_eval().
# - `? true : false` (ternary operator) is faster than `!!` (surprisingly).
desc 'Benchmark code related to AttrBool'
task :bench do
  bench_def_methods
  bench_force_bools
  puts
end

def bench_def_methods
  # rubocop:disable Style/DocumentDynamicEvalDefinition,Style/EvalWithLocation

  n = 200_000

  puts
  Benchmark.bmbm do |bm|
    bm.report('class_eval   ') do
      Class.new do
        n.times do |i|
          name = "bool_#{i}"
          class_eval("def #{name}?; @#{name}; end")
        end
      end
    end

    bm.report('define_method') do
      Class.new do
        n.times do |i|
          name = "bool_#{i}"
          define_method(:"#{name}?") { instance_variable_get(:"@#{name}") }
        end
      end
    end

    bm.report('module_eval  ') do
      Class.new do
        n.times do |i|
          name = "bool_#{i}"
          module_eval("def #{name}?; @#{name}; end")
        end
      end
    end
  end

  # rubocop:enable all
end

def bench_force_bools
  # rubocop:disable Style/DoubleNegation

  n = 5_000_000
  values = ['str',1,0,1.0,0.0,nil,true,false]

  puts
  Benchmark.bmbm do |bm|
    bm.report('?:') do
      n.times do
        x = nil
        values.each do |value|
          x = value ? true : false
        end
        x
      end
    end

    bm.report('!!') do
      n.times do
        x = nil
        values.each do |value|
          x = !!value
        end
        x
      end
    end
  end

  puts
  Benchmark.bmbm do |bm|
    bm.report('!!') do
      n.times do
        x = nil
        values.each do |value|
          x = !!value
        end
        x
      end
    end

    bm.report('?:') do
      n.times do
        x = nil
        values.each do |value|
          x = value ? true : false
        end
        x
      end
    end
  end

  # rubocop:enable all
end

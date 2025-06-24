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
# - +define_method+ is faster than +module_eval+/+class_eval+.
# - <tt>? true : false</tt> (ternary operator) is faster than <tt>!!</tt> (surprisingly).
desc 'Benchmark define_method vs module_eval and ?: vs bangbang'
task :benchmark do
  # rubocop:disable all

  N0 = 100_000
  N1 = 20_000_000

  module ModuleExt
    def do_class_eval(name)
      0.upto(N0) do |i|
        n = "#{name}#{i}"

        class_eval("def #{n}?(); @#{n}; end")
      end
    end

    def do_define_method(name)
      0.upto(N0) do |i|
        n = "#{name}#{i}"

        define_method(:"#{n}?") do
          instance_variable_get(:"@#{n}")
        end
      end
    end

    def do_module_eval(name)
      0.upto(N0) do |i|
        n = "#{name}#{i}"

        module_eval("def #{n}?(); @#{n}; end")
      end
    end
  end

  Module.prepend ModuleExt

  puts
  Benchmark.bmbm do |bm|
    bm.report('class_eval   ') do
      class ClassEvalTest
        do_class_eval :ce
      end
    end

    bm.report('define_method') do
      class DefineMethodTest
        do_define_method :dm
      end
    end

    bm.report('module_eval  ') do
      class ModuleEvalTest
        do_module_eval :me
      end
    end
  end

  str = 'str' # Warning workaround

  puts
  Benchmark.bmbm do |bm|
    bm.report('?:') do
      0.upto(N1) do |i|
        x = str   ? true : false
        x = nil   ? true : false
        x = true  ? true : false
        x = false ? true : false
        x = x     ? true : false
      end
    end

    bm.report('!!') do
      0.upto(N1) do |i|
        y = !!str
        y = !!nil
        y = !!true
        y = !!false
        y = !!y
      end
    end
  end

  puts

  # rubocop:enable all
end

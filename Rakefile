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

task default: [:test]

Rake::TestTask.new do |task|
  task.libs = ['lib','test']
  task.pattern = 'test/**/*_test.rb'
  task.warning = true
  task.verbose = false
end

RDoc::Task.new(:doc) do |task|
  task.rdoc_dir = 'doc'
  task.title = "AttrBool v#{AttrBool::VERSION}"
end

desc 'Benchmark define_method vs module_eval and ?: vs bangbang'
task :benchmark do |_task|
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

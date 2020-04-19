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


require 'bundler/gem_tasks'

require 'benchmark'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

require 'attr_bool/version'


CLEAN.exclude('.git/','stock/')
CLOBBER.include('doc/')


task default: [:test]

desc 'Generate doc (YARDoc)'
task :doc => [:yard] do |task|
end

desc 'Generate doc for tests too (for checking macros)'
task :doc_test do |task|
  ENV['doctest'] = 'y'
  
  doc_task = Rake::Task[:doc]
  
  doc_task.reenable()
  doc_task.invoke()
end

Rake::TestTask.new() do |task|
  task.libs = ['lib','test']
  task.pattern = File.join('test','**','*_test.rb')
  task.description += ": '#{task.pattern}'"
  task.verbose = false
  task.warning = true
end

YARD::Rake::YardocTask.new() do |task|
  task.files = [File.join('lib','**','*.{rb}')]
  
  task.options += ['--files','CHANGELOG.md,LICENSE.txt']
  task.options += ['--readme','README.md']
  
  task.options << '--protected' # Show protected methods
  #task.options += ['--template-path',File.join('yard','templates')]
  task.options += ['--title',"attr_bool v#{AttrBool::VERSION} doc"]
  
  task.before = Proc.new() do
    task.files << File.join('test','**','*.{rb}') if ENV['doctest'].to_s().casecmp?('y')
  end
end


desc 'Benchmark define_method vs module_eval & ?: vs bangbang'
task :benchmark do |task|
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
  Benchmark.bmbm() do |bm|
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
  Benchmark.bmbm() do |bm|
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
end

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


lib = File.expand_path(File.join('..','lib'),__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'attr_bool/version'

Gem::Specification.new() do |spec|
  spec.name        = 'attr_bool'
  spec.version     = AttrBool::VERSION
  spec.authors     = ['Jonathan Bradley Whited (@esotericpig)']
  spec.email       = ['bradley@esotericpig.com']
  spec.licenses    = ['MIT']
  spec.homepage    = 'https://github.com/esotericpig/attr_bool'
  spec.summary     = 'Finally attr_accessor & attr_reader with question marks for booleans!?'
  spec.description = spec.summary +
    ' Simply use one the following: attr_accessor?, attr_reader?, attr_bool, attr_bool?.' \
    ' Default values can also be passed in.'
  
  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/esotericpig/attr_bool/issues',
    'changelog_uri'   => 'https://github.com/esotericpig/attr_bool/blob/master/CHANGELOG.md',
    'homepage_uri'    => 'https://github.com/esotericpig/attr_bool',
    'source_code_uri' => 'https://github.com/esotericpig/attr_bool',
  }
  
  spec.require_paths = ['lib']
  
  spec.files = Dir.glob(File.join("{#{spec.require_paths.join(',')}}",'**','*.{rb}')) +
               %W( Gemfile #{spec.name}.gemspec Rakefile ) +
               %w( LICENSE.txt )
  
  spec.required_ruby_version = '>= 2.4'
  
  spec.add_development_dependency 'bundler' ,'~> 2.1'
  spec.add_development_dependency 'minitest','~> 5.14'
  spec.add_development_dependency 'rake'    ,'~> 13.0'
  spec.add_development_dependency 'yard'    ,'~> 0.9'  # For doc
end

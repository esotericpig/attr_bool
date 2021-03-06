# encoding: UTF-8
# frozen_string_literal: true


require_relative 'lib/attr_bool/version'

Gem::Specification.new do |spec|
  spec.name        = 'attr_bool'
  spec.version     = AttrBool::VERSION
  spec.authors     = ['Jonathan Bradley Whited']
  spec.email       = ['code@esotericpig.com']
  spec.licenses    = ['MIT']
  spec.homepage    = 'https://github.com/esotericpig/attr_bool'
  spec.summary     = 'Finally attr_accessor & attr_reader with question marks for booleans!?'
  spec.description = <<-DESC.gsub(/\s+/,' ').strip
    #{spec.summary}
    Simply use: attr_accessor?, attr_reader?, attr_bool, attr_bool?.
    Default values can also be passed in as the last argument
      or with the 'default: ' keyword argument.
    In a Module/Class, extend 'AttrBool::Ext',
      or in the file, require 'attr_bool/core_ext'.
  DESC

  spec.metadata = {
    'homepage_uri'    => 'https://github.com/esotericpig/attr_bool',
    'source_code_uri' => 'https://github.com/esotericpig/attr_bool',
    'bug_tracker_uri' => 'https://github.com/esotericpig/attr_bool/issues',
    'changelog_uri'   => 'https://github.com/esotericpig/attr_bool/blob/master/CHANGELOG.md',
  }

  spec.required_ruby_version = '>= 2.4'
  spec.require_paths         = ['lib']

  spec.files = [
    Dir.glob(File.join("{#{spec.require_paths.join(',')}}",'**','*.{erb,rb}')),
    %W[ Gemfile #{spec.name}.gemspec Rakefile ],
    %w[ LICENSE.txt ],
  ].flatten

  spec.add_development_dependency 'bundler'   ,'~> 2.2'
  spec.add_development_dependency 'minitest'  ,'~> 5.14'
  spec.add_development_dependency 'rake'      ,'~> 13.0'
  spec.add_development_dependency 'rdoc'      ,'~> 6.3'   # YARDoc RDoc (*.rb)
  spec.add_development_dependency 'redcarpet' ,'~> 3.5'   # YARDoc Markdown (*.md)
  spec.add_development_dependency 'yard'      ,'~> 0.9'   # Doc

  spec.extra_rdoc_files = %w[ LICENSE.txt ]

  spec.rdoc_options = [
    '--hyperlink-all','--show-hash',
    '--title',"AttrBool v#{AttrBool::VERSION} Doc",
  ]
end

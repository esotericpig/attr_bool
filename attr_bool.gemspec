# encoding: UTF-8
# frozen_string_literal: true

require_relative 'lib/attr_bool/version'

Gem::Specification.new do |spec|
  spec.name        = 'attr_bool'
  spec.version     = AttrBool::VERSION
  spec.authors     = ['Bradley Whited']
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
    'rubygems_mfa_required' => 'true',
    'homepage_uri'          => spec.homepage,
    'source_code_uri'       => 'https://github.com/esotericpig/attr_bool',
    'bug_tracker_uri'       => 'https://github.com/esotericpig/attr_bool/issues',
    'changelog_uri'         => 'https://github.com/esotericpig/attr_bool/blob/main/CHANGELOG.md',
  }

  spec.required_ruby_version = '>= 3.1'
  spec.require_paths         = ['lib']
  spec.bindir                = 'bin'
  spec.executables           = []

  spec.extra_rdoc_files = %w[LICENSE.txt README.md]
  spec.rdoc_options     = [
    %w[--embed-mixins --hyperlink-all --line-numbers --show-hash],
    '--title',"AttrBool v#{AttrBool::VERSION}",
    '--main','README.md',
  ].flatten

  spec.files = [
    Dir.glob("{#{spec.require_paths.join(',')}}/**/*.{erb,rb}"),
    Dir.glob("#{spec.bindir}/*"),
    Dir.glob('{spec,test}/**/*.{erb,rb}'),
    %W[Gemfile #{spec.name}.gemspec Rakefile .rdoc_options],
    spec.extra_rdoc_files,
  ].flatten
end

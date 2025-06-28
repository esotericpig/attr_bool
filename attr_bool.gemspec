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
  spec.summary     = 'Finally attr_accessor? & attr_reader? with question marks for booleans/predicates!?'
  spec.description = <<~DESC
    #{spec.summary}

    Pick one:
      (1) in your top module, add `using AttrBool::Ref`,
      or (2) in your class/module, add `extend AttrBool::Ext`,
      or (3) in your app/script (not library), include `require 'attr_bool/core_ext'`.

    Now simply use any:
      [ attr_accessor?, attr_reader?, attr_writer?, attr_bool, attr_bool?, attr_bool! ].

    Keywords: attr, attribute, attributes, bool, boolean, booleans, predicate, predicates
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
    '--encoding','UTF-8',
    '--markup','markdown',
    '--title',"AttrBool v#{AttrBool::VERSION}",
    '--main','README.md',
  ].flatten

  spec.files = [
    Dir.glob("{#{spec.require_paths.join(',')}}/**/*.{erb,rb}"),
    Dir.glob("#{spec.bindir}/*"),
    Dir.glob('{spec,test}/**/*.{erb,rb}'),
    %W[.rdoc_options Gemfile #{spec.name}.gemspec Rakefile],
    spec.extra_rdoc_files,
  ].flatten
end

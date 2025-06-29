# Changelog | AttrBool

- [Keep a Changelog](https://keepachangelog.com/en/1.1.0)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## [[Unreleased]](https://github.com/esotericpig/attr_bool/compare/v0.3.1...HEAD)
- ...

## [0.3.1](https://github.com/esotericpig/attr_bool/compare/v0.3.0...v0.3.1) - 2025-06-28
### Changed
- Minor change to fix README/Gemspec about wording around refinements.

## [0.3.0](https://github.com/esotericpig/attr_bool/compare/v0.2.2...v0.3.0) - 2025-06-27
Major change to simplify usage.

### Changed
- Renamed `attr_booler` to `attr_bool!`.
- Added `AttrBool::Ref` so can use as refinements, which means you don't have to extend every class/module!
- Now returns an array of the new method names, just like the core `attr` methods, to allow DSL chaining.
- Changed unit tests to spec tests.
- Dropped YARDoc for RDoc.
- Applied new RuboCops.

### Removed
- No default values.
- No aliases (no `attr_boolor`).

## [0.2.2](https://github.com/esotericpig/attr_bool/compare/v0.2.1...v0.2.2) - 2021-06-17
### Changed
- Formatted code with RuboCop.

## [0.2.1](https://github.com/esotericpig/attr_bool/compare/v0.2.0...v0.2.1) - 2020-11-07
### Changed
- Minor changes to *README* and *Gemspec* description.

## [0.2.0](https://github.com/esotericpig/attr_bool/compare/v0.1.0...v0.2.0) - 2020-10-23
A major departure from the previous version by not extending the core (monkey-patching) `Module` by default.

```ruby
require 'attr_bool'

class BananaHammock
  extend AttrBool::Ext
end
```

To imitate the previous version:

```ruby
require 'attr_bool/core_ext'
```

### Added
- AttrBool::Ext
    - Was previously inside of *AttrBool*.
- lib/attr_bool/core_ext.rb
    - Was previously inside of *lib/attr_bool.rb*.
- test/TestHelper
- test/CoreExtTest
- .yardopts

### Changed
- attr_bool.gemspec
    - Added *rdoc* & *redcarpet* dev deps for YARDoc.
    - Added *rdoc* files & opts.
    - Formatted for new Gemspec style.
- README.md
    - Updated to use new code.
    - Added more Similar Projects from [The Ruby Toolbox](https://www.ruby-toolbox.com/search?q=attr+bool).
    - Formatted for new README style.
- test/AttrBoolTest
    - Updated to use new code.

## [0.1.0](https://github.com/esotericpig/attr_bool/tree/v0.1.0) - 2020-04-20
Initial release.

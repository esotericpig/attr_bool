# Changelog | AttrBool

All notable changes to this project will be documented in this file.

Format is based on [Keep a Changelog v1.0.0](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning v2.0.0](https://semver.org/spec/v2.0.0.html).

## [[Unreleased]](https://github.com/esotericpig/attr_bool/compare/v0.2.1...HEAD)

-

## [v0.2.1] - [2020-11-07](https://github.com/esotericpig/attr_bool/compare/v0.2.0...v0.2.1)

### Changed
- Minor changes to *README* and *Gemspec* description

## [v0.2.0] - [2020-10-23](https://github.com/esotericpig/attr_bool/compare/v0.1.0...v0.2.0)

A major departure from the previous version by not extending the core (monkey-patching) `Module` by default.

```Ruby
require 'attr_bool'

class BananaHammock
  extend AttrBool::Ext
end
```

To imitate the previous version:

```Ruby
require 'attr_bool/core_ext'
```

### Added
- AttrBool::Ext
    - Was previously inside of *AttrBool*
- lib/attr_bool/core_ext.rb
    - Was previously inside of *lib/attr_bool.rb*
- test/TestHelper
- test/CoreExtTest
- .yardopts

### Changed
- attr_bool.gemspec
    - Added *rdoc* & *redcarpet* dev deps for YARDoc
    - Added *rdoc* files & opts
    - Formatted for new Gemspec style
- README.md
    - Updated to use new code
    - Added more Similar Projects from [The Ruby Toolbox](https://www.ruby-toolbox.com/search?q=attr+bool)
    - Formatted for new README style
- test/AttrBoolTest
    - Updated to use new code

## [v0.1.0] - [2020-04-20](https://github.com/esotericpig/attr_bool/tree/v0.1.0)

Initial working version.

### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

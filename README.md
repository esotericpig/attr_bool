# AttrBool

[![Gem Version](https://badge.fury.io/rb/attr_bool.svg)](https://badge.fury.io/rb/attr_bool)
[![Tests Status](https://github.com/esotericpig/attr_bool/actions/workflows/ruby.yml/badge.svg)](https://github.com/esotericpig/attr_bool/actions/workflows/ruby.yml)
[![Source Code](https://img.shields.io/badge/source-github-%23211F1F.svg)](https://github.com/esotericpig/attr_bool)
[![Changelog](https://img.shields.io/badge/changelog-md-%23A0522D.svg)](CHANGELOG.md)
[![License](https://img.shields.io/github/license/esotericpig/attr_bool.svg)](LICENSE.txt)

Easily create `attr` (attribute) methods that end with question marks (`?`) for booleans/predicates.

```ruby
require 'attr_bool'

class TheTodd
  extend AttrBool::Ext
  #using AttrBool::Ref  # Can use refinements instead.

  attr_accessor? :headband
  attr_reader?   :banana_hammock
  attr_writer?   :high_five

  # Can do DSL chaining.
  protected attr_accessor? :carla_kiss, :elliot_kiss

  # Can force bool values (i.e., only `true` or `false`).
  attr_bool      :bounce_pecs  # Accessor.
  attr_bool?     :cat_fight    # Reader.
  attr_bool!     :hot_tub      # Writer.
end

todd = TheTodd.new

puts todd.headband?
puts todd.banana_hammock?
puts todd.bounce_pecs?
puts todd.cat_fight?
```

Features:
- Can use multiple symbols and/or strings.
- Can force bool values.
- Can define custom logic with a block/proc.
- Can do DSL chaining, just like the core `attr` methods that return an array of the new method names.
- Can use refinements (`using AttrBool::Ref`) instead of `extend`.
- Fails fast if an instance variable name is invalid (if you don't use a block/proc).

Anti-features:
- No default values.
  - Initialize your instance variables in `def initialize` like normal.
  - Using default values has performance/memory issues and other drawbacks, so better to just match the core `attr` methods.
- Uses inner `AttrBool::Ext` & `AttrBool::Ref` instead of `AttrBool`.
  - Some gems use the `extend AttrBool` (top module) pattern, but this includes `VERSION` in all of your classes/modules.
- Doesn't monkey-patch the core class/module by default.
  - If desired for apps/scripts, you still can with `require 'attr_bool/core_ext'`, but not recommended for libraries.

## // Contents

- [Similar Projects](#-similar-projects)
- [Setup](#-setup)
- [Usage](#-usage)
    - [RuboCop](#-rubocop)
    - [YARDoc](#-yardoc)
- [Hacking](#-hacking)
    - [Benchmarks](#-benchmarks)
- [License](#-license)

## [//](#-contents) Similar Projects

Create a [discussion](https://github.com/esotericpig/attr_bool/discussions) or an [issue](https://github.com/esotericpig/attr_bool/issues) to let me know to add your project.

| Gem Name                                                                 | Code                                                          | Example                                                   |
|--------------------------------------------------------------------------|---------------------------------------------------------------|-----------------------------------------------------------|
| [attr_asker](https://rubygems.org/gems/attr_asker)                       | [GitHub](https://github.com/kitlangton/attr_asker)            | `attr_asker :winning`                                     |
| [attr_boolean](https://rubygems.org/gems/attr_boolean)                   | [GitHub](https://github.com/talentnest/attr_boolean)          | `attr_boolean :winning, default: true`                    |
| [attr_setting](https://rubygems.org/gems/attr_setting)                   | [GitHub](https://github.com/merhard/attr_setting)             | `attr_setting :winning, true`                             |
| [attribool](https://rubygems.org/gems/attribool)                         | [GitHub](https://github.com/evanthegrayt/attribool)           | `bool_reader :winning`                                    |
| [attribute_boolean](https://rubygems.org/gems/attribute_boolean)         | [GitHub](https://github.com/alexmchale/attribute_boolean)     | `attr_boolean :winning`                                   |
| [attribute_predicates](https://rubygems.org/gems/attribute_predicates)   | [GitHub](https://github.com/pluginaweek/attribute_predicates) | `attr :winning, true`                                     |
| [boolean_accessor](https://rubygems.org/gems/boolean_accessor)           | [GitHub](https://github.com/hiroki23/boolean_accessor)        | `battr_accessor :winning`                                 |
| [named_accessors](https://rubygems.org/gems/named_accessors)             | [GitHub](https://github.com/zlw/named_accessors)              | `named_reader :winning, as: :winning?`                    |
| [predicateable](https://rubygems.org/gems/predicateable)                 | [GitHub](https://github.com/nsgc/predicateable)               | `predicate :wins, [:losing, :winning]`                    |
| [predicates](https://rubygems.org/gems/predicates)                       | [GitHub](https://github.com/Erol/predicates)                  | `predicate :winning?`                                     |
| [property-accessor](https://rubygems.org/gems/property-accessor)         | [GitHub](https://github.com/estepnv/property-accessor)        | `property(:winning) { get(:winning?); default { true } }` |
| [question_mark_methods](https://rubygems.org/gems/question_mark_methods) | [GitHub](https://github.com/poiyzy/questionmarkmethods)       | `add_question_mark_methods winning?: :winning`            |
| [wannabe_bool](https://rubygems.org/gems/wannabe_bool)                   | [GitHub](https://github.com/prodis/wannabe_bool)              | `attr_wannabe_bool :winning`                              |
| [wardrobe](https://rubygems.org/gems/wardrobe)                           | [GitHub](https://github.com/agensdev/wardrobe)                | `attribute :winning, Wardrobe::Boolean, default: true`    |

Searches:

| Site             | Searches                                                                                                                 |
|------------------|--------------------------------------------------------------------------------------------------------------------------|
| The Ruby Toolbox | [1](https://www.ruby-toolbox.com/search?q=attr+bool), [2](https://www.ruby-toolbox.com/search?q=predicate)               |
| RubyGems.org     | [1](https://rubygems.org/search?query=attr+OR+attribute), [2](https://rubygems.org/search?query=predicates+OR+predicate) |

## [//](#-contents) Setup

Pick your poison...

With the *RubyGems* package manager:

```bash
gem install attr_bool
```

Or in your *Gemspec*:

```ruby
spec.add_dependency 'attr_bool', '~> X.X'
```

Or in your *Gemfile*:

```ruby
# Pick your poison...
gem 'attr_bool', '~> X.X'
gem 'attr_bool', git: 'https://github.com/esotericpig/attr_bool.git'
```

Or from source:

```bash
git clone --depth 1 'https://github.com/esotericpig/attr_bool.git'
cd attr_bool
bundle install
bundle exec rake install:local
```

## [//](#-contents) Usage

You can either add `extend AttrBool::Ext` in your class/module, add `using AttrBool::Ref` in your class/module, or include `require 'attr_bool/core_ext'`.

```ruby
require 'attr_bool'

class TheTodd
  extend AttrBool::Ext
  #using AttrBool::Ref  # Can use refinements instead.

  # Can use multiple symbols and/or strings.
  attr_accessor? :flexing, 'bounce_pecs'

  # Can do DSL chaining.
  protected attr_accessor? :high_five, 'fist_bump'

  # Can do custom logic.
  attr_accessor? :headband, 'banana_hammock',
                 reader: -> { @wearing == :flaming },
                 writer: ->(value) { @wearing = value }

  attr_reader?(:cat_fights)    { @cat_fights % 69 }
  attr_writer?(:hot_surgeries) { |count| @hot_surgeries += count }

  # Can force bool values (i.e., only `true` or `false`).
  attr_bool  :carla_kiss   # Accessor.
  attr_bool? :elliot_kiss  # Reader.
  attr_bool! :thumbs_up    # Writer.
end
```

If you don't want to have to add `extend AttrBool::Ext` to every inner class/module (within the same file), then you can simply refine the outer module or the file:

```ruby
require 'attr_bool'

#using AttrBool::Ref  # Can refine the entire file instead (doesn't affect other files).

module TheToddMod
  using AttrBool::Ref

  class TheTodd
    attr_bool :banana_hammock
  end

  class TheToddBod
    attr_bool :bounce_pecs
  end
end
```

If you only have an app/script (**not** a library), then you can simply include `require 'attr_bool/core_ext'` to monkey-patch the core class & module:

```ruby
require 'attr_bool/core_ext'

class TheTodd
  attr_bool :banana_hammock
end
```

### [///](#-contents) RuboCop

RuboCop might complain about `Layout/EmptyLinesAroundAttributeAccessor`:

```ruby
class TheTodd
  attr_accessor? :banana_hammock
  attr_accessor  :headband
  attr_accessor? :bounce_pecs
end
```

You can either disable this Cop or adjust it accordingly:

```yaml
Layout/EmptyLinesAroundAttributeAccessor:
  #Enabled: false
  AllowedMethods:
    - attr_accessor?
    - attr_reader?
    - attr_writer?
    - attr_bool
    - attr_bool?
    - attr_bool!
```

### [///](#-contents) YARDoc

Here are some examples of how to document the methods in YARDoc:

```ruby
attr_accessor? :winning # @!attribute [rw] winning=(value),winning?
attr_reader?   :running # @!attribute [r]  running?

# @!attribute [r] can_swim?
#   @return [true,false] can you swim in it?
# @!attribute [r] can_wink?
#   @return [true,false] can you wink at pretty people?
attr_reader? :can_swim,:can_wink

# @!attribute [rw] princess=(value),princess?
#   @param value [true,false] this is Ms. Consuela or not!
#   @return [true,false] is this Ms. Consuela?
# @!attribute [rw] crap_bag=(value),crap_bag?
#   @param value [true,false] this is Mr. Crap Bag or not!
#   @return [true,false] is this Mr. Crap Bag?
attr_accessor? :princess,:crap_bag

# @overload in_fashion?
#   @return [true,false] whether it's fashionable right now
# @overload in_fashion=(value)
#   Make it in or out of fashion!
attr_accessor? :in_fashion

# @!group My Attrs
# @!attribute [r] in_season?
attr_reader? :in_season
# @!attribute [r] can_wash?
attr_reader? :can_wash
# @!endgroup
```

Further reading:

- [Documenting Attributes](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#documenting-attributes)
  - [Documenting Custom DSL Methods](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#documenting-custom-dsl-methods)
  - [Tags#Attribute](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#attribute)
- [Macros](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#macros)
  - [Tags#Macro](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#macro)
- [Writing Handlers](https://yardoc.org/guides/extending-yard/writing-handlers.html)
  - [YARD::Handlers::Ruby::AttributeHandler](https://github.com/lsegal/yard/blob/main/lib/yard/handlers/ruby/attribute_handler.rb)

## [//](#-contents) Hacking

```bash
git clone 'https://github.com/esotericpig/attr_bool.git'
cd attr_bool
bundle install
bundle exec rake -T
```

Run tests:

```bash
bundle exec rake test
```

Generate doc:

```bash
bundle exec rake doc
```

Install locally:

```bash
bundle exec rake install:local
```

### [///](#-contents) Benchmarks

Benchmarks are kind of meaningless, but after playing around with some, I found the following to be true on my system:
- `define_method()` is faster than `class/module_eval()`.
- `? true : false` (ternary operator) is faster than `!!` (surprisingly).

Therefore, AttrBool uses the "faster" ones found.

To run these on your system:

```bash
bundle exec rake bench
```

## [//](#-contents) License

AttrBool (https://github.com/esotericpig/attr_bool)  
Copyright (c) 2020-2025 Bradley Whited  
[MIT License](LICENSE.txt)  

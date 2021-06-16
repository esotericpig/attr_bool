# AttrBool

[![Gem Version](https://badge.fury.io/rb/attr_bool.svg)](https://badge.fury.io/rb/attr_bool)
[![Build Status](https://travis-ci.org/esotericpig/attr_bool.svg?branch=master)](https://travis-ci.org/esotericpig/attr_bool)

[![Source Code](https://img.shields.io/badge/source-github-%23211F1F.svg)](https://github.com/esotericpig/attr_bool)
[![Changelog](https://img.shields.io/badge/changelog-md-%23A0522D.svg)](CHANGELOG.md)
[![License](https://img.shields.io/github/license/esotericpig/attr_bool.svg)](LICENSE.txt)

Easily create `attr` (attribute) methods that end with question marks (`?`).

```Ruby
require 'attr_bool'

module Wearable
  extend AttrBool::Ext

  attr_accessor? :in_fashion
  attr_reader?   :can_wash
end

class BananaHammock
  extend AttrBool::Ext
  include Wearable

  # Enforce boolean (true or false) values.
  attr_bool  :princess
  attr_bool? :crap_bag
end

banham = BananaHammock.new()

banham.in_fashion = true
banham.princess   = true

p banham.in_fashion?  #=> true
p banham.can_wash?    #=> nil
p banham.princess?    #=> true
p banham.crap_bag?    #=> false
```

Require `attr_bool/core_ext` to extend the core (monkey-patch) `Module` & `Class` (not recommended for libraries):

```Ruby
require 'attr_bool/core_ext'

class BananaHammock
  attr_bool  :princess
  attr_bool? :crap_bag
end
```

## Contents

- [Similar Projects](#-similar-projects)
- [Setup](#-setup)
- [Usage](#-usage)
    - [Complete Example](#-complete-example)
    - [Default Values](#-default-values)
    - [Block/Proc/Lambda](#-blockproclambda)
    - [YARDoc](#-yardoc)
- [Hacking](#-hacking)
    - [Benchmarks](#-benchmarks)
- [License](#-license)

## [//](#contents) Similar Projects

Create an [issue](https://github.com/esotericpig/attr_bool/issues) to add your project.

| Gem Name | Code | Example |
| --- | --- | --- |
| [attr_asker](https://rubygems.org/gems/attr_asker) | [[GitHub]](https://github.com/kitlangton/attr_asker) | `attr_asker :running` |
| [attr_boolean](https://rubygems.org/gems/attr_boolean) | [[GitHub]](https://github.com/talentnest/attr_boolean) | `attr_boolean :running, default: true` |
| [attr_setting](https://rubygems.org/gems/attr_setting) | [[GitHub]](https://github.com/merhard/attr_setting) | `attr_setting :running, true` |
| [attribool](https://rubygems.org/gems/attribool) | [[GitHub]](https://github.com/evanthegrayt/attribool) | `bool_reader :name` |
| [attribute_boolean](https://rubygems.org/gems/attribute_boolean) | [[GitHub]](https://github.com/alexmchale/attribute_boolean) | `attr_boolean :running` |
| [boolean_accessor](https://rubygems.org/gems/boolean_accessor) | [[GitHub]](https://github.com/hiroki23/boolean_accessor) | `battr_accessor :running` |
| [named_accessors](https://rubygems.org/gems/named_accessors) | [[GitHub]](https://github.com/zlw/named_accessors) | `named_reader :running, as: :running?` |
| [property-accessor](https://rubygems.org/gems/property-accessor) | [[GitHub]](https://github.com/estepnv/property-accessor) | `property(:running) { get(:running?); default { true } }` |
| [question_mark_methods](https://rubygems.org/gems/question_mark_methods) | [[GitHub]](https://github.com/poiyzy/questionmarkmethods) | `add_question_mark_methods running?: :running` |
| [wannabe_bool](https://rubygems.org/gems/wannabe_bool) | [[GitHub]](https://github.com/prodis/wannabe_bool) | `attr_wannabe_bool :running` |
| [wardrobe](https://rubygems.org/gems/wardrobe) | [[GitHub]](https://github.com/agensdev/wardrobe) | `attribute :running, Wardrobe::Boolean, default: true` |

Searches:

- [The Ruby Toolbox](https://www.ruby-toolbox.com/search?q=attr+bool)
- [RubyGems.org](https://rubygems.org/search?query=attr+OR+attribute)

## [//](#contents) Setup

Add `attr_bool` to your *Gemspec* or *Gemfile*.

Or, use the *RubyGems* package manager:

```
$ gem install attr_bool
```

Or, manually:

```
$ git clone 'https://github.com/esotericpig/attr_bool.git'
$ cd attr_bool
$ bundle install
$ bundle exec rake install:local
```

## [//](#contents) Usage

Either require `attr_bool` or `attr_bool/core_ext`.

The first one requires extending `AttrBool::Ext` manually.

```Ruby
require 'attr_bool'

class Game
  extend AttrBool::Ext

  attr_accessor? :running
  attr_reader?   :winning
end
```

The second one automatically extends `Module` & `Class`, which is not recommended for sharing libraries.

```Ruby
require 'attr_bool/core_ext'

class Game
  attr_accessor? :running
  attr_reader?   :winning
end
```

Now, simply use `attr_accessor?` and/or `attr_reader?` with one or more Symbols and/or Strings.

These do **not** force the values to be booleans (true or false).

For most purposes, this is adequate.

```Ruby
require 'attr_bool'

class Game
  extend AttrBool::Ext

  attr_accessor? :running,'looper'
  attr_reader?   :fps,'music'

  def initialize()
    @running = false
    @looper  = nil
    @fps     = 60
    @music   = 'Beatles'
  end
end

game = Game.new()

puts game.running?  #=> false
puts game.looper?   #=> nil
puts game.fps?      #=> 60
puts game.music?    #=> 'Beatles'

game.running = true
game.looper  = :main

puts game.running?  #=> true
puts game.looper?   #=> :main
```

There is also `attr_writer?`, but it simply calls the standard `attr_writer` unless you pass in a [block](#-blockproclambda).

To enforce boolean (true or false) values, use...

| Name | Access |
| --- | --- |
| `attr_bool` or `attr_boolor` | accessor |
| `attr_bool?` | reader |
| `attr_booler` | writer |

These are slightly slower due to always checking the values.

```Ruby
require 'attr_bool'

class Game
  extend AttrBool::Ext

  attr_bool   :running,'looper'
  attr_bool?  :fps,'music'
  attr_booler :sound

  def initialize()
    @fps   = 60
    @music = 'Beatles'
    @sound = false
  end

  def loud?()
    music? && @sound == true
  end
end

game = Game.new()

puts game.running?  #=> false
puts game.looper?   #=> false
puts game.fps?      #=> true
puts game.music?    #=> true
puts game.loud?     #=> false

game.running = true
game.looper  = :main
game.sound   = 'loud!'

puts game.running?  #=> true
puts game.looper?   #=> true
puts game.loud?     #=> true
```

### [///](#contents) Default Values

A default value can be passed in, but I don't recommend using it because it's slightly slower due to always checking the value and not setting the instance variable directly.

It's best to just set the default values the standard way in `initialize()`. However, many Gems do this, so I also added this functionality anyway.

If the last argument is not a `Symbol` or a `String`, then it will be used as the default value.

**Note:** `attr_writer?` &amp; `attr_booler` can **not** take in a default value.

```Ruby
require 'attr_bool'

class Game
  extend AttrBool::Ext

  attr_accessor? :running,:looper,false
  attr_reader?   :min_fps,:max_fps,60

  attr_bool  :gravity,:wind,true
  attr_bool? :min_force,:max_force,110
end

game = Game.new()

puts game.running?    #=> false
puts game.looper?     #=> false
puts game.min_fps?    #=> 60
puts game.max_fps?    #=> 60
puts game.gravity?    #=> true
puts game.wind?       #=> true
puts game.min_force?  #=> true (not 110)
puts game.max_force?  #=> true (not 110)
```

Instead of the last argument, you can use the `default:` keyword argument. In addition to being more clear, this allows you to pass in a `String` or a `Symbol`.

```Ruby
require 'attr_bool'

class Game
  extend AttrBool::Ext

  attr_accessor? :running,:looper,default: :main
  attr_reader?   :music,:sound,default: 'quiet!'
end

game = Game.new()

puts game.running?  #=> :main
puts game.looper?   #=> :main
puts game.music?    #=> 'quiet!'
puts game.sound?    #=> 'quiet!'
```

### [///](#contents) Block/Proc/Lambda

A block can be passed in for dynamic values, but I don't recommend using it. However, many Gems do this, so I also added this functionality anyway.

With blocks, you can quickly write a dynamic attribute that depends on other variable(s) or tests variable(s) in some other special way.

**Note:** blocks do **not** update the instance variables; you must do this manually within the block. `attr_accessor?/reader?/writer?` &amp; `attr_bool*` with blocks are exactly the same code (i.e., boolean values are not enforced).

```Ruby
require 'attr_bool'

class Game
  extend AttrBool::Ext

  attr_reader?(:lag)  { print @ping,','; @ping > 300 }
  attr_writer?(:ping) {|value| @ping = value.to_i() }

  # Define 1 block for both reader & writer together.
  attr_accessor?(:sound) do |value=nil|
    if value.nil? # Assume reader
      print @sound,','
      @sound > 0
    else # Assume writer
      @sound = value.to_i() % 100
    end
  end

  attr_bool?(:slow) { print @fps,','; @fps < 30 }
  attr_booler(:fps) {|value| @fps = value.to_i() }

  # Define separate blocks.
  attr_bool(:music,
    reader: -> { print @music,','; !@music.nil? },
    writer: ->(value) { @music = value.to_sym() }
  )

  # Define only 1 block.
  attr_accessor?(:frames,
    reader: -> { @frames.odd? }
  )
end

game = Game.new()

game.ping   = 310.99
game.sound  = 199.99
game.fps    = 29.99
game.music  = 'Beatles'
game.frames = 1

puts game.lag?     #=> 310,true
puts game.sound?   #=> 99,true
puts game.slow?    #=> 29,true
puts game.music?   #=> :Beatles,true
puts game.frames?  #=> true
```

### [///](#contents) Complete Example

```Ruby
require 'attr_bool/core_ext'

module Wearable
  # +attr_accessor?/reader?+ do not enforce boolean (true or false) values.
  attr_accessor? :in_fashion,:in_season
  attr_reader?   :can_wash,:can_wear,default: 'yes!'
end

class BananaHammock
  include Wearable

  # +attr_bool*+ enforce boolean (true or false) values.
  attr_bool   :princess,:prince,default: 'Consuela'
  attr_bool?  :can_swim,:can_wink,true
  attr_bool? (:crap_bag) { princess? && can_swim? }
  attr_booler :friends

  def for_friends()
    @friends
  end
end

banham = BananaHammock.new()

puts banham.in_fashion?  #=> nil
puts banham.in_season?   #=> nil
puts banham.can_wash?    #=> 'yes!'
puts banham.can_wear?    #=> 'yes!'
puts '---'

puts banham.princess?  #=> true (not 'Consuela')
puts banham.prince?    #=> true (not 'Consuela')
puts banham.can_swim?  #=> true
puts banham.can_wink?  #=> true
puts banham.crap_bag?  #=> true
puts '---'

banham.in_fashion = true
banham.in_season  = 'always'
banham.princess   = nil
banham.prince     = 'Charming'
banham.friends    = 'Valerie'

puts banham.in_fashion?  #=> true
puts banham.in_season?   #=> 'always'
puts banham.princess?    #=> false (not nil)
puts banham.prince?      #=> true  (not 'Charming')
puts banham.crap_bag?    #=> false (dynamic; because +princess?+ is now false)
puts banham.for_friends  #=> true  (not 'Valerie')
```

### [///](#contents) YARDoc

A custom `AttributeHandler` plugin is planned for the next version:

- [Writing Handlers](https://yardoc.org/guides/extending-yard/writing-handlers.html)
- [YARD::Handlers::Ruby::AttributeHandler](https://github.com/lsegal/yard/blob/main/lib/yard/handlers/ruby/attribute_handler.rb)

For now, please use one of YARDoc's built-in ways:

```Ruby
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

# @!method can_wear?
# @return [true,false] whether it's wearable (default: +true+)
attr_reader? :can_wear,true

# @!group My Attrs
# @!attribute [r] in_season?
attr_reader? :in_season
# @!attribute [r] can_wash?
attr_reader? :can_wash
# @!endgroup
```

Further reading:

- [Documenting Attributes](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#Documenting_Attributes)
- [Documenting Custom DSL Methods](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#Documenting_Custom_DSL_Methods)
- [Macros](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#Macros)
- [Tags#Macro](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#macro)
- [Tags#Attribute](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#attribute)

## [//](#contents) Hacking

```
$ git clone 'https://github.com/esotericpig/attr_bool.git'
$ cd attr_bool
$ bundle install
$ bundle exec rake -T
```

### Test

```
$ bundle exec rake test
```

### Generate Doc

```
$ bundle exec rake doc
```

### Install Locally

```
$ bundle exec rake install:local
```

### Release

```
$ bundle exec rake release
```

### [///](#contents) Benchmarks

There are some benchmarks that test `define_method` vs `module_eval` and `? true : false` vs `!!`.

To run these on your system:

```
$ bundle exec rake benchmark
```

## [//](#contents) License

[MIT](LICENSE.txt)

> AttrBool (https://github.com/esotericpig/attr_bool)  
> Copyright (c) 2020-2021 Jonathan Bradley Whited  
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy  
> of this software and associated documentation files (the "Software"), to deal  
> in the Software without restriction, including without limitation the rights  
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
> copies of the Software, and to permit persons to whom the Software is  
> furnished to do so, subject to the following conditions:  
> 
> The above copyright notice and this permission notice shall be included in all  
> copies or substantial portions of the Software.  
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  
> SOFTWARE.  

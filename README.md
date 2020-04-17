# attr_bool

[![Gem Version](https://badge.fury.io/rb/attr_bool.svg)](https://badge.fury.io/rb/attr_bool)
[![Build Status](https://travis-ci.org/esotericpig/attr_bool.svg?branch=master)](https://travis-ci.org/esotericpig/attr_bool)

[![Source Code](https://img.shields.io/badge/source-github-%23211F1F.svg)](https://github.com/esotericpig/attr_bool)
[![Changelog](https://img.shields.io/badge/changelog-md-%23A0522D.svg)](CHANGELOG.md)
[![License](https://img.shields.io/github/license/esotericpig/attr_bool.svg)](LICENSE.txt)

Easily create `attr` (attribute) methods that end with a question mark (`?`).

```Ruby
require 'attr_bool'

module Wearable
  # These do not force a boolean (true or false) value.
  attr_accessor? :in_fashion,:heavy
  attr_reader?   :can_wear,true
  attr_reader?   :button,:zip,false
end

class BananaHammock
  include Wearable
  
  # `attr_bool*` force a boolean (true or false) value.
  attr_bool  :princess,default: 'Consuela'
  attr_bool? :can_swim,true
  attr_bool?(:crap_bag) { can_swim? && princess? }
end

bh = BananaHammock.new()

puts bh.in_fashion?.inspect  # => nil
puts bh.heavy?.inspect       # => nil
puts '---'

puts bh.can_wear?  # => true
puts bh.button?    # => false
puts bh.zip?       # => false
puts bh.princess?  # => true  (not 'Consuela')
puts bh.can_swim?  # => true
puts bh.crap_bag?  # => true
puts '---'

bh.in_fashion = true
bh.heavy      = false
bh.princess   = nil

puts bh.in_fashion?  # => true
puts bh.heavy?       # => false
puts bh.princess?    # => false (not nil)
puts bh.crap_bag?    # => false
```

## Contents

- [Similar Projects](#similar-projects-)
- [Setup](#setup-)
- [Using](#using-)
    - [Using with Default](#using-with-default-)
    - [Using with Block/Proc/Lambda](#using-with-blockproclambda-)
    - [Using with YARDoc](#using-with-yardoc-)
- [Hacking](#hacking-)
    - [Benchmarks](#benchmarks-)
- [License](#license-)

## Similar Projects [^](#contents)

Create an [issue](https://github.com/esotericpig/attr_bool/issues) to add your project.

| Name | Links | Example |
| --- | --- | --- |
| attr_asker | [[GitHub]](https://github.com/kitlangton/attr_asker) [[RubyGems]](https://rubygems.org/gems/attr_asker) | `attr_asker :running` |
| attr_boolean | [[GitHub]](https://github.com/talentnest/attr_boolean) [[RubyGems]](https://rubygems.org/gems/attr_boolean) | `attr_boolean :running, default: true` |
| named_accessors | [[GitHub]](https://github.com/zlw/named_accessors) [[RubyGems]](https://rubygems.org/gems/named_accessors) | `named_reader :running, as: :running?` |
| attr_setting | [[GitHub]](https://github.com/merhard/attr_setting) [[RubyGems]](https://rubygems.org/gems/attr_setting) | `attr_setting :running, true` |
| property-accessor | [[GitHub]](https://github.com/estepnv/property-accessor) [[RubyGems]](https://rubygems.org/gems/property-accessor) | `property(:running) { get(:running?); default { true } }` |
| wannabe_bool | [[GitHub]](https://github.com/prodis/wannabe_bool) [[RubyGems]](https://rubygems.org/gems/wannabe_bool) | `attr_wannabe_bool :running` |
| wardrobe | [[GitHub]](https://github.com/agensdev/wardrobe) [[RubyGems]](https://rubygems.org/gems/wardrobe) | `attribute :running, Wardrobe::Boolean, default: true` |

## Setup [^](#contents)

Pick your poison...

In your *Gemspec* (*&lt;project&gt;.gemspec*):

```Ruby
# Pick one...
spec.add_runtime_dependency 'attr_bool', '~> X.X'
spec.add_development_dependency 'attr_bool', '~> X.X'
```

In your *Gemfile*:

```Ruby
# Pick one...
gem 'attr_bool', '~> X.X'
gem 'attr_bool', '~> X.X', :group => :development
gem 'attr_bool', :git => 'https://github.com/esotericpig/attr_bool.git', :tag => 'vX.X.X'
```

With the RubyGems package manager:

`$ gem install attr_bool`

Manually:

```
$ git clone 'https://github.com/esotericpig/attr_bool.git'
$ cd attr_bool
$ bundle install
$ bundle exec rake install:local
```

## Using [^](#contents)

Simply use `attr_accessor?` and/or `attr_reader?` with 1 or more Symbols and/or Strings.

These do **not** force the values to be booleans (true or false).

For most purposes, this will be adequate.

```Ruby
require 'attr_bool'

class Game
  attr_accessor? :running
  attr_reader?   :fps,'loop'
  attr_accessor? :music,:pause,:sound
  
  def initialize()
    @music = true
    @sound = true
  end
  
  def run()
    @fps     = 60
    @loop    = :main
    @pause   = false
    @running = true
  end
  
  def pause()
    @loop    = :pause_menu
    @pause   = true
    @running = false
  end
end

game = Game.new()

puts game.running?.inspect # => nil

game.running = 'Waiting...'

puts game.running?  # => Waiting...

game.run()

puts game.running?  # => true
puts game.fps?      # => 60
puts game.loop?     # => main
puts game.pause?    # => false
puts game.music?    # => true
puts game.sound?    # => true

game.music = false
game.sound = false
game.pause()

puts game.running?  # => false
puts game.loop?     # => pause_menu
puts game.pause?    # => true
puts game.music?    # => false
puts game.sound?    # => false
```

There is also an `attr_writer?`, but it simply calls the standard `attr_writer` unless you pass in a [block](#using-with-blockproclambda-).

To force the values to be booleans (true or false), use `attr_bool` (accessor), `attr_bool?` (reader), and/or `attr_booler` (writer).

These always check the values, which makes them slightly slower.

```Ruby
require 'attr_bool'

class Game
  attr_bool   :running
  attr_bool?  :fps,'loop'
  attr_bool   :music,:pause,:sound
  attr_booler :name
  
  def initialize()
    @music = true
    @sound = true
  end
  
  def run()
    @fps     = 60
    @loop    = :main
    @pause   = false
    @running = true
  end
  
  def pause()
    @loop    = :pause_menu
    @pause   = true
    @running = false
  end
  
  def show_name()
    puts @name
  end
end

game = Game.new()

puts game.running?.inspect # => false

game.name    = 'Starlord'
game.running = 'Waiting...'

game.show_name()    # => true
puts game.running?  # => true

game.run()

puts game.running?  # => true
puts game.fps?      # => true
puts game.loop?     # => true
puts game.pause?    # => false
puts game.music?    # => true
puts game.sound?    # => true

game.music = false
game.sound = false
game.pause()

puts game.running?  # => false
puts game.loop?     # => true
puts game.pause?    # => true
puts game.music?    # => false
puts game.sound?    # => false
```

`attr_boolor` (accessor) is also an alias to `attr_bool`.

### Using with Default [^](#contents)

A default value can be passed in, but I don't recommend using it because it's slightly slower due to always checking the value and may result in warning messages (i.e., instance variable not initialized) due to not setting the instance variable directly. It's best to just set the default values the standard way in `initialize()`.

However, many Gems do this, so I also added this functionality.

If the last argument is not a `String` or a `Symbol`, then it will be used as the default value.

**Note:** `attr_writer?` &amp; `attr_booler` cannot take a default value.

```Ruby
require 'attr_bool'

class Game
  attr_accessor? :running,false
  attr_reader?   :min_fps,:max_fps,60
  attr_accessor? :music,:sound,:vibrate,true
  
  attr_bool  :gravity,true
  attr_bool? :min_force,:max_force,110
  attr_bool  :dodge,:duck,:dip,false
  
  def show_state()
    puts "running?   #{running?}"
    puts "fps:       #{min_fps?}, #{max_fps?}"
    puts "music?     #{@music}"
    puts "sound?     #{@sound}"
    puts "vibrate?   #{@vibrate}"
    
    puts "gravity?   #{gravity?}"
    puts "min_force? #{min_force?}, #{max_force?}"
    puts "dodge?     #{@dodge}"
    puts "duck?      #{@duck}"
    puts "dip?       #{@dip}"
  end
end

game = Game.new()

game.show_state()

game.music   = 'Beatles'
game.vibrate = false
game.duck    = 'quack'

puts '---'
game.show_state()

# running?   false
# fps:       60, 60
# music?     
# sound?     
# vibrate?   
# gravity?   true
# min_force? true, true
# dodge?     
# duck?      
# dip?       
# ---
# running?   false
# fps:       60, 60
# music?     Beatles
# sound?     
# vibrate?   false
# gravity?   true
# min_force? true, true
# dodge?     
# duck?      true
# dip?
```

Instead of the last argument, you can use the `default:` keyword argument. In addition to being more clear, this allows you to pass in a `String` or a `Symbol`.

```Ruby
require 'attr_bool'

class Game
  attr_accessor? :music,default: 'Beatles'
  attr_reader?   :loop,:state,default: :main
end

game = Game.new()

puts game.music?          # => Beatles
puts game.loop?.inspect   # => :main
puts game.state?.inspect  # => :main
```

### Using with Block/Proc/Lambda [^](#contents)

A block can be passed in for dynamic values, but I don't recommend using it.

However, many Gems do this, so I also added this functionality.

```Ruby
require 'attr_bool'
```

### Using with YARDoc [^](#contents)

`attr_bool` defines some macros to help with documenting your code:

```Ruby
attr_accessor? :doc_acc    # @!macro attach attr_accessor?
attr_reader?   :doc_read   # @!macro attach attr_reader?
attr_writer?   :doc_write  # @!macro attach attr_writer?
attr_bool      :doc_bool   # @!macro attach attr_bool
attr_bool?     :doc_boolq  # @!macro attach attr_bool?
attr_booler    :doc_booler # @!macro attach attr_booler
attr_boolor    :doc_boolor # @!macro attach attr_boolor
```

**Note:** These do **not** currently work with multiple attributes. Instead, you should use `@!attribute` as in the example below.

If you don't like the way these look, need more control, or they don't work, please use YARDoc's built-in ways:

```Ruby
# @!attribute [r] heavy?
#   @return [true,false] heavy or light?
# @!attribute [r] can_swim?
#   @return [true,false] can you swim in it?
attr_reader? :heavy,:can_swim

# @!attribute [rw] princess=(value),princess?
#   @param value [true,false] it is Consuela or not!
#   @return [true,false] is this Consuela?
# @!attribute [rw] crap_bag=(value),crap_bag?
#   @param value [true,false] it is a Crap Bag or not!
#   @return [true,false] is this Crap Bag?
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
# @!attribute [r] button?
attr_reader? :button
# @!attribute [r] zip?
attr_reader? :zip
# @!endgroup
```

Further reading:

- [Documenting Attributes](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#Documenting_Attributes)
- [Documenting Custom DSL Methods](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#Documenting_Custom_DSL_Methods)
- [Macros](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md#Macros)
- [Tags#Macro](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#macro)
- [Tags#Attribute](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#attribute)

## Hacking [^](#contents)

```
$ git clone 'https://github.com/esotericpig/attr_bool.git'
$ cd attr_bool
$ bundle install
$ bundle exec rake -T
```

### Testing

`$ bundle exec rake test`

To test YARDoc macros, run this:

`$ bundle exec rake doc_test`

Then open up [doc/TestBag.html](doc/TestBag.html) &amp; check the `doc_` methods.

### Generating Doc

`$ bundle exec rake doc`

### Installing Locally

`$ bundle exec rake install:local`

### Releasing/Publishing

`$ bundle exec rake release`

## License [^](#contents)

[MIT](LICENSE.txt)

> Copyright (c) 2020 Jonathan Bradley Whited (@esotericpig)  
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

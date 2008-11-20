= functor

A functor is an object with easily assignable methods. We use them in testing when a stub
isn't flexible enough.

== INSTALL:

  sudo gem install functor

== USAGE:

You can assign to any function like it is an attribute.

  f = Functor.new
  f.foo = lambda {|i| i ** 2}

  g = Functor.new
  g.foo = lambda {'BAP!'}

  f.foo(3)
  # => 9

  g.foo
  # => 'BAP!'

Also, the lambda is a closure:

  count = 0
  f = Functor.new
  f.foo = lambda {|i| count = count + i}
  10.times do 
    f.foo(1)
  end

  count
  # => 10

You can also mix Functor in to an existing object. To avoid confusion though, you must use
define_method rather than the magic accessor method to create new methods:

  o = Object.new
  o.extend Functor
  power = 2
  o.define_method(:foo) {|i| i ** power}

  o.foo(4)
  # => 16

This is different from the Ruby def techinique, because that isn't a closure. This doesn't
work:

  def o.foo(i)
    i ** power
  end
  
  o.foo(4)
  # NoMethodError: undefined method `name' for #<Object:0x86c2c>
  
There is also a shortcut method for creating functors similar to mock and stub:

  foo = functor(:bar => lambda {|i| 2 * i}, :baz => 200, :bap => lambda { Time.now })

  foo.bar(5)
  # => 10

  foo.baz
  # => 200

  foo.bap
  # => Fri Dec 7 11:40:59 -0800 2007

Notice that non-lambdas are permitted and just return that value every time the function
is called.

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

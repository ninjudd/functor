require File.dirname(__FILE__) + '/test_helper'

class FunctorTest < Test::Unit::TestCase
  test "new functor with methods" do
    f = Functor.new( :foo => lambda {:crazy}, :bar => lambda {|i| i + 3} )
    
    assert_equal :crazy, f.foo
    assert_equal 5, f.bar(2)
    assert_equal :crazy, f.foo
    assert_equal 23, f.bar(20)
  end

  test "new functor with shortcut method" do
    f = functor( :foo => lambda {:crazy}, :bar => lambda {|i| i + 3} )

    assert_equal :crazy, f.foo
    assert_equal 5, f.bar(2)
    assert_equal :crazy, f.foo
    assert_equal 23, f.bar(20)
  end

  test "functor function assignment" do
    f = Functor.new
    g = Functor.new
    
    f.foo = lambda {|i| i ** 2}
    f.bar = lambda {:scheme_is_bad_ass}
    g.foo = lambda {|i| i * 10}
    g.bar = lambda {:lisp_4ever}
    
    assert_equal 9, f.foo(3)
    assert_equal :scheme_is_bad_ass, f.bar
    assert_equal 16, f.foo(4)
    assert_equal :scheme_is_bad_ass, f.bar
    assert_equal 81, f.foo(9)
  
    assert_equal 100, g.foo(10)
    assert_equal :lisp_4ever, g.bar
    assert_equal 40, g.foo(4)
    assert_equal :lisp_4ever, g.bar
  end
  
  test "functor lambda continuation" do
    f = Functor.new
    bar = 0
    f.foo = lambda {|i| bar = bar + i}
    10.times do
      f.foo(5)
    end
    
    assert_equal bar, 50
  end
  
  test "mixin functor to an instance" do
    o = Object.new
    o.extend Functor
    
    o.define_method(:foo) {:bar}
    assert_equal :bar, o.foo
  end
  
  test "define_method on a functor" do
    f = Functor.new
    
    f.define_method(:foo) {:baz}
    assert_equal :baz, f.foo
  end
  
  test "remove a method from a functor" do
    f = Functor.new
    
    f.foo = lambda {:baz}
    assert_equal :baz, f.foo
    f.foo = nil
    assert_raises NoMethodError do
      f.foo
    end
  end
  
  test "define a static method" do
    f = Functor.new
    
    f.foo = :baz
    assert_equal :baz, f.foo
  end
end

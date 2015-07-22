# Memist

Memist is a tiny library to help with memoizing values in Ruby classes. There
are many other memoization libraries around but Memist provides more invalidation
than others. Let's jump right into a demonstration.

```ruby
class Person

  attr_accessor :first_name, :last_name, :date_of_birth

  def age
    Age.from_date_of_birth(date_of_birth)
  end
  memoize :age, :uses => [:date_of_birth]

end
```

Here you can see we have a method called `age` which generates a person's age
based on on their `date_of_birth`. It returns an integer. Each time we run this
method, we don't want to go to the extra power of calcuating the age, so we
want to cache the value for this instance. To do this, we just add the `memoize`
method to our object.

```ruby
person = Person.new
person.date_of_birth = Date.new(1986, 6, 10)
person.age      #=> 29 (retreived by calculation)
person.age      #=> 29 (retreived from the cache based)
```

Unlike other libraries, Memist can also ensure that the cached value is cleared
whenever dependent fields are changed. In this example, when the date of birth
is changed, the age should also be re-calculated.

```ruby
person = Person.new
person.date_of_birth = Date.new(1986,6, 10)
person.age  #=> 29
person.age  #=> 29 (from cache)
person.date_of_birth = Date.new(1985, 6, 10)
person.age  #=> 30
person.age  #=> 30 (from cache)
```

## Installation

Simple. Just add the gem to your Gemfile and we'll handle the rest. Memist works
with any Ruby Object and has special support to handle Active Record classes too.

```ruby
gem 'memist', '~> 1.0'
```

## Usage

You need to specify which fields you want to be memoized in your objects. You
do this by calling `memoize` as shown above.

You can optionally provide an array of attributes as a `:uses` option. This will
ensure that the cached value is cleared when any of these attributes are cleared.
You can also specify other memozied methods in this array and their attributes
will be cleared too.

#### Other handy methods

```ruby
person = Person.new
person.date_of_birth = Date.new(1986, 6, 10)

# Access the raw underlying without any memoization
person.age_without_memoization    #=> 29

# Clear the cache for all methods on the model
person.flush_memoization_cache

# Clear the cache for a single method on the model
person.flush_memoization_cache(:age)

# Find out of a vale is memoized or not? When the value has been returned from
# memoized cache, it will be true otherwise it will be false.
person.age.memoized?    #=> false
person.age.memoized?    #=> true
```

# Memist

Memist is a tiny library to help with memoizing values in Ruby classes. There
are many other memoization libraries around but Memist provides more invalidation
than others. Let's jump right into a demonstration.

```ruby
class Person

  include Memist::Memoizable

  attr_accessor :first_name, :last_name, :date_of_birth

  def age
    Age.from_date_of_birth(date_of_birth)
  end
  memoize :age

  # Memist can also cache the results from methods that accept a single
  # argument. The cache will be based on the argument provided.
  def tweets(username)
    Twitter.tweets_for_username(username)
  end
  memoize :tweets

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
person.age      #=> 29 (retrieved by calculation)
person.age      #=> 29 (retrieved from the cache based)
```

## Installation

Simple. Just add the gem to your Gemfile.

```ruby
gem 'memist', '~> 2.0'
```

## Usage

Firstly, include `Memist::Memozation` in any class you wish to add memoization to. Then, you need to specify which fields you want to be memoized in your objects. You
do this by calling `memoize` as shown above.

#### Other handy methods

```ruby
person = Person.new
person.date_of_birth = Date.new(1986, 6, 10)

# Access the raw underlying without any memoization
person.age_without_memoization    #=> 29

# Clear the cache for all methods on the model
person.flush_memoization

# Clear the cache for a single method on the model
person.flush_memoization(:age)

# Find out of a vale is memoized or not? When the value has been returned from
# memoized cache, it will be true otherwise it will be false.
person.age.memoized?    #=> false
person.age.memoized?    #=> true
```

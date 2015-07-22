class ObjectTest < Minitest::Test

  class Person

    attr_accessor :first_name, :last_name
    def full_name
      "#{first_name} #{last_name}"
    end
    memoize :full_name, :uses => [:first_name, :last_name]

    attr_accessor :date_of_birth
    def age
      Date.today.year - date_of_birth.year
    end
    memoize :age, :uses => [:date_of_birth]

    def name_with_age
      "#{full_name} (#{age})"
    end
    memoize :name_with_age, :uses => [:name, :age]

    def is_called_adam?
      first_name == "Adam"
    end
    memoize :is_called_adam?

  end

  def test_memoization
    person = Person.new
    person.first_name = 'Joe'
    person.last_name = 'Bloggs'

    name = person.full_name
    assert_equal "Joe Bloggs", name
    assert_equal name.object_id, person.full_name.object_id
  end

  def test_invalidation_on_attribute_set
    person = Person.new
    person.first_name = 'Joe'
    person.last_name = 'Bloggs'
    assert_equal "Joe Bloggs", person.full_name
    person.first_name = "Michael"
    assert_equal "Michael Bloggs", person.full_name
  end

  def test_invalidation_of_falsey_values
    person = Person.new
    person.first_name = 'David'
    assert_equal false, person.is_called_adam?
    person.first_name = 'Adam'
    assert_equal false, person.is_called_adam?
  end

end

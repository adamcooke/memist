require 'spec_helper'

describe Memist::Memoizable do
  class SomeObject
    include Memist::Memoizable
    def initialize
      @count = 0
    end

    def times
      @count += 1
    end
    memoize :times

    def say_hello(full_name)
      @count += 1
      "Hello #{full_name}! #{@count}"
    end
    memoize :say_hello

    def name(first, last)
      "#{first} #{last}"
    end
  end

  it 'should cache the value after the first call' do
    object = SomeObject.new
    expect(object.times).to eq 1
    expect(object.times).to eq 1
    expect(object.times).to be_a Integer
  end

  it 'should not be marked as memoized until it has been calld' do
    object = SomeObject.new
    expect(object.memoized?(:times)).to be false
    object.times
    expect(object.memoized?(:times)).to be true
  end

  it 'should be able to skip memoization' do
    object = SomeObject.new
    expect(object.times).to eq 1
    expect(object.times_without_memoization).to eq 2
    expect(object.times).to eq 1
  end

  it 'should be able to skip memoization using the "bang" method' do
    object = SomeObject.new
    expect(object.times).to eq 1
    expect(object.times!).to eq 2
    expect(object.times).to eq 1
  end

  it 'should be able to clear the cache' do
    object = SomeObject.new
    expect(object.times).to eq 1
    object.flush_memoization
    expect(object.times).to eq 2
    object.flush_memoization(:times)
    expect(object.times).to eq 3
  end

  it 'should be able to cache based on the first arg' do
    object = SomeObject.new
    expect(object.say_hello('Adam')).to eq 'Hello Adam! 1'
    expect(object.say_hello('Charlie')).to eq 'Hello Charlie! 2'
    expect(object.say_hello('Adam')).to eq 'Hello Adam! 1'
    expect(object.say_hello('Charlie')).to eq 'Hello Charlie! 2'
    object.flush_memoization(:say_hello, 'Adam')
    expect(object.say_hello('Adam')).to eq 'Hello Adam! 3'
    expect(object.say_hello('Charlie')).to eq 'Hello Charlie! 2'
    object.flush_memoization(:say_hello)
    expect(object.say_hello('Adam')).to eq 'Hello Adam! 4'
    expect(object.say_hello('Charlie')).to eq 'Hello Charlie! 5'
  end

  it 'should raise an error if you try to memoize something with more than one arg' do
    expect do
      SomeObject.memoize :name
    end.to raise_error ArgumentError, /because it accepts more than one arg/
  end
end

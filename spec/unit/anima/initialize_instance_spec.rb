require 'spec_helper'

describe Anima, '#initialize_instance' do
  let(:object) { Anima.new(:foo, :bar) }

  let(:target) { Object.new }

  let(:foo) { mock('Foo') }
  let(:bar) { mock('Bar') }

  subject { object.initialize_instance(target, attribute_hash) }

  context 'when all keys are present in attribute hash' do
    let(:attribute_hash) { { :foo => foo, :bar => bar } }

    it 'should initialize target instance variables' do
      subject
      target.instance_variables.should eql([:@foo, :@bar])
      target.instance_variable_get(:@foo).should be(foo)
      target.instance_variable_get(:@bar).should be(bar)
    end
  end

  context 'when extra key is missing in attribute hash' do
    let(:attribute_hash) { { :foo => foo, :bar => bar, :baz => mock('Baz') } }

    it 'should raise error' do
      expect { subject }.to raise_error(Anima::Error::Unknown, Anima::Error::Unknown.new(target.class, [:baz]).message)
    end
  end

  context 'when a key is missing in attribute hash' do
    let(:attribute_hash) { { :bar => bar } }

    it 'should raise error' do
      expect { subject }.to raise_error(Anima::Error::Missing, Anima::Error::Missing.new(target.class, :foo).message)
    end
  end
end
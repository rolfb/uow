require 'spec_helper'

class Mapper
  extend DescendantsTracker

  def initialize
    @index = 0
  end

  def prepare_for_insert(object)
  end

  def insert(object)
    object.key = "#{object.class.name}_#{(@index += 1)}"
  end

  def parent_relationships
    []
  end

  def child_relationships
    []
  end
end

class Relationship
  extend DescendantsTracker

  def get(object)
  end

  def set(object)
  end
end

class Model < OpenStruct
  extend DescendantsTracker
end

RSpec.configure do |config|
  config.after(:all) do
    Mapper.descendants.each do |klass|
      Object.send(:remove_const, klass.name.to_sym)
    end

    Relationship.descendants.each do |klass|
      Object.send(:remove_const, klass.name.to_sym)
    end

    Model.descendants.each do |klass|
      Object.send(:remove_const, klass.name.to_sym)
    end

    Mapper.instance_variable_set(:"@descendants", [])
    Relationship.instance_variable_set(:"@descendants", [])
    Model.instance_variable_set(:"@descendants", [])
  end
end

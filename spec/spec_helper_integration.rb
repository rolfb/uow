require 'spec_helper'
require 'descendants_tracker'

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

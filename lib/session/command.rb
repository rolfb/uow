module Session
  module Command

    def parent?(other)
      parent_objects.include?(other.object)
    end

    def child?(other)
      other.child_objects.include?(other)
    end

    def parent_objects
      mapper.parent_relationships.map do |relationship|
        object.public_send(relationship.name)
      end
    end

    def child_relationships
      mapper.child_relationships.map do |relationship|
        object.public_send(relationship.name)
      end
    end
  end
end

class Uow
  class Command
    attr_reader :object
    attr_reader :mapper

    def initialize(object, mapper)
      @object, @mapper = object, mapper
    end

    def execute
      raise NotImplementedError, "#{self.class}#execute must be implemented"
    end

    def depends_on?(other)
      false
    end
  end
end

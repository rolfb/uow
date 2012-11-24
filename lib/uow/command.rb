class Uow
  class Command
    def initialize(object, mapper)
      @object, @mapper = object, mapper
    end

    def execute
      raise NotImplementedError, "#{self.class}#execute must be implemented"
    end

    def depends_on?(other)
      raise NotImplementedError, "#{self.class}#depends_on? must be implemented"
    end
  end
end

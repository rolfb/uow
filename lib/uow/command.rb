class Uow
  class Command
    include AbstractType, Adamantium::Flat

    attr_reader :object
    attr_reader :mapper

    def initialize(object, mapper)
      @object, @mapper = object, mapper
    end

    abstract_method :prepare

    abstract_method :execute

    def depends_on?(other)
      false
    end
  end
end

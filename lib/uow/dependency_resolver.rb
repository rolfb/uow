class Uow
  class DependencyResolver
    include Enumerable

    attr_reader :command

    def initialize(command)
      @command = command
    end

    def each(commands, &block)
      dependencies(commands).each(&block)
    end

    def dependencies(commands)
      commands.select { |other| command.depends_on?(other) }
    end
  end
end

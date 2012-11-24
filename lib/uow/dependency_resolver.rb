class Uow
  class DependencyResolver
    include Enumerable

    attr_reader :command

    def initialize(command)
      @command = command
    end

    def each(commands, &block)
      commands.select { |other| command.depends_on?(other) }.each(&block)
    end
  end
end

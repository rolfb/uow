require "uow/command"
require "uow/command/insert"
require "uow/command/update"
require "uow/command/delete"
require "uow/dependency_resolver"
require "session"

class Uow
  include TSort

  attr_reader :index

  def initialize(dependency_resolver = DependencyResolver)
    @dependency_resolver = dependency_resolver
    initialize_index
  end

  def insert_command
    Command::Insert
  end

  def delete_command
    Command::Insert
  end

  def register_insert(object, mapper)
    command = insert_command.new(object, mapper)
    register(command, dependency_resolver(command))
    self
  end

  def register_update(object, mapper)
    command = Command::Update.new(object, mapper)
    register(command, dependency_resolver(command))
    self
  end

  def register_delete(object, mapper)
    command = delete_command.new(object, mapper)
    register(command, dependency_resolver(command))
    self
  end

  def register(command, dependencies = [])
    index[command] = dependencies
    self
  end

  def flush
    tsort.each { |command| command.execute }
    initialize_index
  end

  private

  def initialize_index
    @index = Hash.new { |hash, key| hash[key] = [] }
  end

  def commands
    @index.keys
  end

  def dependency_resolver(command)
    @dependency_resolver.new(command)
  end

  def tsort_each_node(&block)
    index.each_key(&block)
  end

  def tsort_each_child(command, &block)
    index[command].each(commands, &block) if index.key?(command)
  end
end

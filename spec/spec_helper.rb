require 'spec'
RSpec = Spec::Runner

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

require 'uow'

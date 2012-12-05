require 'spec_helper'

describe Session::Uow do
  let(:uow) { Session::Uow.new }

  let(:grandparent_relationship)  { mock('grandparent_rel', :name => :parent) }
  let(:grandparent_relationships) { [ grandparent_relationship ] }

  let(:parent_relationship)       { mock('parent_rel', :name => :parent) }
  let(:parent_relationships)      { [ parent_relationship ] }

  let(:grandparent_child_relationship)  { mock('grandparent_child_rel', :name => :child) }
  let(:grandparent_child_relationships) { [ grandparent_child_relationship ] }

  let(:parent_child_relationship)  { mock('parent_child_rel', :name => :child) }
  let(:parent_child_relationships) { [ parent_child_relationship ] }

  let(:grandparent)        { mock('grandparent') }
  let(:grandparent_mapper) { mock('grandparent_mapper', :parent_relationships => [], :child_relationships => grandparent_child_relationships) }

  let(:parent)             { mock('parent') }
  let(:parent_mapper)      { mock('parent_mapper', :parent_relationships => grandparent_relationships, :child_relationships => parent_child_relationships) }

  let(:child)              { mock('child') }
  let(:child_mapper)       { mock('child_mapper', :parent_relationships => parent_relationships, :child_relationships => []) }

  describe "#dependency_resolver" do
    it "builds dependency resolver for a given command" do
      command             = mock('command')
      dependency_resolver = uow.dependency_resolver(command)

      dependency_resolver.should be_instance_of(described_class.dependency_resolver)
    end
  end

  describe "#flush" do
    it "executes inserts in correct order" do
      grandparent_relationship.should_receive(:get).exactly(3).times.with(parent).and_return(grandparent)
      parent_relationship.should_receive(:get).exactly(3).times.with(child).and_return(parent)

      uow.register_insert(child, child_mapper)
      uow.register_insert(parent, parent_mapper)
      uow.register_insert(grandparent, grandparent_mapper)

      grandparent_mapper.should_receive(:insert).with(grandparent).ordered
      parent_mapper.should_receive(:insert).with(parent).ordered
      child_mapper.should_receive(:insert).with(child).ordered

      uow.flush
    end

    it "executes deletes in correct order" do
      grandparent_child_relationship.should_receive(:get).exactly(3).times.with(grandparent).and_return(child)
      parent_child_relationship.should_receive(:get).exactly(3).times.with(parent).and_return(child)

      uow.register_delete(child, child_mapper)
      uow.register_delete(parent, parent_mapper)
      uow.register_delete(grandparent, grandparent_mapper)

      child_mapper.should_receive(:delete).with(child).ordered
      parent_mapper.should_receive(:delete).with(parent).ordered
      grandparent_mapper.should_receive(:delete).with(grandparent).ordered

      uow.flush
    end
  end
end

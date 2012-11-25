require 'spec_helper'

describe Session::Uow do
  let(:uow) { Session::Uow.new }

  let(:grandparent_relationship)  { mock('grandparent_rel', :name => :parent) }
  let(:grandparent_relationships) { [ grandparent_relationship ] }

  let(:parent_relationship)       { mock('parent_rel', :name => :parent) }
  let(:parent_relationships)      { [ parent_relationship ] }

  let(:child_relationship)        { mock('child_rel', :name => :child) }
  let(:child_relationships)       { [ child_relationship ] }

  let(:grandparent)        { mock('grandparent') }
  let(:grandparent_mapper) { mock('grandparent_mapper', :parent_relationships => [], :child_relationships => child_relationships) }

  let(:parent)             { mock('parent') }
  let(:parent_mapper)      { mock('parent_mapper', :parent_relationships => grandparent_relationships, :child_relationships => child_relationships) }

  let(:child)              { mock('child') }
  let(:child_mapper)       { mock('child_mapper', :parent_relationships => parent_relationships, :child_relationships => []) }


  describe "#flush" do
    it "executes inserts in correct order" do
      grandparent.stub!(:child).and_return(parent)
      parent.stub!(:parent).and_return(grandparent)
      parent.stub!(:child).and_return(child)
      child.stub!(:parent).and_return(parent)

      uow.register_insert(child, child_mapper)
      uow.register_insert(parent, parent_mapper)
      uow.register_insert(grandparent, grandparent_mapper)

      grandparent_mapper.should_receive(:insert).with(grandparent).ordered
      parent_mapper.should_receive(:insert).with(parent).ordered
      child_mapper.should_receive(:insert).with(child).ordered

      uow.flush
    end
  end
end

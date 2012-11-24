require 'spec_helper'

describe Uow do
  let(:uow) { Uow.new }

  let(:object_1) { mock('object_1') }
  let(:mapper_1) { mock('mapper_1') }

  let(:object_2) { mock('object_2') }
  let(:mapper_2) { mock('mapper_2') }

  let(:object_3) { mock('object_3') }
  let(:mapper_3) { mock('mapper_3') }

  describe "#flush" do
    it "executes commands in correct order" do
      uow.register_insert(object_1, mapper_1)
      uow.register_update(object_2, mapper_2)
      uow.register_delete(object_3, mapper_3)

      mapper_3.should_receive(:delete).with(object_3).ordered
      mapper_2.should_receive(:update).with(object_2).ordered
      mapper_1.should_receive(:insert).with(object_1).ordered

      uow.flush
    end
  end
end

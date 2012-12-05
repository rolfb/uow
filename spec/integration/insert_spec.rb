require 'spec_helper'

describe "Executing insert commands" do
  before(:all) do
    Address = Class.new(OpenStruct)
    User    = Class.new(OpenStruct)

    UserAddressRelationship = Class.new {
      def get(address)
        address.user
      end

      def set(address)
        user            = get(address)
        user.address    = address
        address.user_key = user.key
      end
    }

    AddressMapper = Class.new {
      def prepare_for_insert(object)
        parent_relationships.each do |relationship|
          relationship.set(object)
        end
      end

      def insert(object)
        object.key = 2
        2
      end

      def parent_relationships
        [ UserAddressRelationship.new ]
      end
    }

    UserMapper = Class.new {
      def prepare_for_insert(object)
        # noop
      end

      def insert(object)
        object.key = 1
        1
      end

      def parent_relationships
        []
      end
    }
  end

  let(:address) {
    Address.new(:key => nil, :city => "Krakow", :user_key => nil, :user => nil)
  }

  let(:user) {
    User.new(:key => nil, :name => "John", :address => nil)
  }

  let(:address_mapper) {
    AddressMapper.new
  }

  let(:user_mapper) {
    UserMapper.new
  }

  after(:all) do
    Object.send(:remove_const, :User)
    Object.send(:remove_const, :Address)
    Object.send(:remove_const, :UserMapper)
    Object.send(:remove_const, :AddressMapper)
    Object.send(:remove_const, :UserAddressRelationship)
  end

  context "when all required commands are registered" do
    it "prepares objects and executes commands in correct order" do
      uow = Session::Uow.new

      address.user = user

      uow.register_insert(address, address_mapper)
      uow.register_insert(user, user_mapper)

      uow.flush

      user.key.should be(1)
      address.key.should be(2)
      user.address.should be(address)
      address.user.should be(user)
      address.user_key.should be(1)
    end
  end

  context "when a required command is missing" do
    it "adds missing command, prepares objects and executes commands in correct order" do
      pending

      uow = Session::Uow.new

      address.user = user

      uow.register_insert(address, address_mapper)

      uow.flush

      user.key.should be(1)
      address.key.should be(2)
      user.address.should be(address)
      address.user.should be(user)
      address.user_key.should be(1)
    end
  end
end

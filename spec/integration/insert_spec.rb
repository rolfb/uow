require 'spec_helper_integration'

describe "Executing insert commands" do
  before(:all) do
    City    = Class.new(Model)
    Address = Class.new(Model)
    User    = Class.new(Model)

    class UserAddressRelationship < Relationship
      def get(address)
        address.user
      end

      def set(address)
        user            = get(address)
        user.address    = address
        address.user_key = user.key
      end
    end

    class AddressCityRelationship < Relationship
      def get(address)
        address.city
      end

      def set(address)
        city             = get(address)
        city.addresses   << address
        address.city_key = city.key
      end
    end

    class AddressMapper < Mapper
      def prepare_for_insert(object)
        parent_relationships.each do |relationship|
          relationship.set(object)
        end
      end

      def parent_relationships
        [ UserAddressRelationship.new, AddressCityRelationship.new ]
      end
    end

    class CityMapper < Mapper
    end

    class UserMapper < Mapper
    end
  end

  let(:address) {
    Address.new(:key => nil, :city_key => nil, :city => nil, :user_key => nil, :user => nil)
  }

  let(:city) {
    User.new(:key => nil, :name => "Krakow", :addresses => [])
  }

  let(:user) {
    User.new(:key => nil, :name => "John", :address => nil)
  }

  let(:address_mapper) {
    AddressMapper.new
  }

  let(:city_mapper) {
    CityMapper.new
  }

  let(:user_mapper) {
    UserMapper.new
  }

  context "when all required commands are registered" do
    it "prepares objects and executes commands in correct order" do
      uow = Session::Uow.new

      address.city = city
      address.user = user

      uow.register_insert(address, address_mapper)
      uow.register_insert(user,    user_mapper)
      uow.register_insert(city,    city_mapper)

      uow.flush

      user.key.should eql('User_1')
      address.key.should eql('Address_1')
      user.address.should be(address)
      address.user.should be(user)
      address.user_key.should eql('User_1')
    end
  end

  context "when a required command is missing" do
    it "adds missing command, prepares objects and executes commands in correct order" do
      pending

      uow = Session::Uow.new

      address.user = user

      uow.register_insert(address, address_mapper)

      uow.flush

      user.key.should eql('User_1')
      city.key.should be('City_1')
      address.key.should be('Address_1')
      user.address.should be(address)
      address.city.should be(city)
      address.city_key.should be(city.key)
      address.user.should be(user)
      address.user_key.should be('User_1')
      city.addresses.should include(address)
    end
  end
end

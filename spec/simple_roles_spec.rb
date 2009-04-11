require File.dirname(__FILE__)+'/spec_helper'

class Abstract
  include SimpleRoles
  attr_reader :role
  
  def initialize(role_name)
    @role = role_name
  end
end

class BasicRole < Abstract
  role :basic do
    can :do_basic_stuff
  end
end

class BlockRole < Abstract
  
end

describe "SimpleRoles" do
  describe 'including' do
    it 'should include class methods' do
      BasicRole.respond_to?(:role).should be_true
    end
  end
  
  describe 'with roles' do
    it "should have role objects" do
      BasicRole.roles[:basic].should be_kind_of(SimpleRoles::Role)
    end
  end
  
  describe 'as an instance with simple roles' do
    before do
      @instance = BasicRole.new(:basic)
      @role = BasicRole.roles[:basic]
    end
    
    it "should look up permissions in it's role" do
      @role.should_receive(:can?).with(@instance, :do_basic_stuff)
      @instance.can?(:do_basic_stuff)
    end
  end
  
  describe 'as an instance with block roles' do
    before do
      BlockRole.role :block do
        can :use_blocks
      end
      @instance = BlockRole.new(:block)
      @role = BlockRole.roles[:block]
      @blk = lambda{true}
    end
    
    it "should pass block to Role" do
      @role.should_receive(:can).with(:foo, &@blk)
      BlockRole.role :block do
        can :foo, &@blk
      end
    end
    
    it "should pass arguments to the role" do
      @role.should_receive(:can?).with(@instance, :use_blocks, 1)
      @instance.can?(:use_blocks, 1)
    end
  end
end

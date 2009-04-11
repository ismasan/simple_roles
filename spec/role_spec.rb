require File.dirname(__FILE__)+'/spec_helper'

describe SimpleRoles::Role do
  
  before do
    @parent = mock('Role container')
    @role = SimpleRoles::Role.new
  end
  
  it "should respond to :can" do
    @role.should respond_to(:can)
  end
  
  describe 'with simple actions' do
    before do
      @role.can :do_stuff
      @role.can :do_more_stuff
    end
    
    it "should store actions" do
      @role.actions.size.should == 2
      @role.actions.each do |key, action|
        action.should be_kind_of(SimpleRoles::Action)
      end
    end
    
    it "should check it can do an action" do
      @role.can?(@parent, :do_stuff).should be_true
    end
    
    it "should check that it can't do an action" do
      @role.can?(@parent, :fake_action).should_not be_true
    end
    
  end
  
  describe "with block actions" do
    before do
      @role.can :use_blocks do |thing|
        hello_world(thing)
      end
    end
    
    it "should call block in the context of parent object" do
      @parent.should_receive(:hello_world).with('hello')
      @role.can?(@parent, :use_blocks, 'hello')
    end
  end
  
end
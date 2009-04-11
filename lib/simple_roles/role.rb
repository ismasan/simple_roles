module SimpleRoles
  # A role holds actions
  #
  class Role
    
    attr_reader :actions
    
    def initialize
      @actions = {}
    end
    
    def can(action_name, &blk)
      @actions[action_name.to_sym] = Action.new(action_name, &blk)
    end
    
    def can?(*args)
      parent_object = args.shift
      action_name = args.shift
      
      action = @actions[action_name]
      return false unless action
      action.run(parent_object, args)
    end
    
  end
  
  # An action has a name an optional conditions
  #
  class Action
    attr_reader :name
    
    def initialize(action_name, &blk)
      @name = action_name
      @block = block_given? ? blk : Proc.new{true}
    end
    
    def run(parent_object, args = [])
      parent_object.instance_exec *args, &@block
    end
    
  end
end
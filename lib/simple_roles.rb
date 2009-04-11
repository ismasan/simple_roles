require 'simple_roles/object'  unless respond_to?(:instance_exec)

module SimpleRoles
  def self.included(base)
    class << base
      attr_reader :roles
    end
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def role(name, &blk)
      @roles ||= {}
      @roles[name] ||= Role.new
      @roles[name].instance_eval(&blk)
    end
  end
  
  # pass itself and arguments to Role object
  #
  def can?(*args)
    args.unshift self
    current_role.can?(*args)
  end
  
  protected
  
  # Classes including this module are expected to implement the :role instance method
  # def role
  #   :basic
  # end
  #
  def current_role
    self.class.roles[role]
  end
  
  autoload :Role, 'simple_roles/role'
end
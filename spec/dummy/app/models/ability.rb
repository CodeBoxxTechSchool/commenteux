class Ability
  include CanCan::Ability

  def initialize(user)
    if user and user.name == "Admin"
      can :manage, Comment
    end
  end
end
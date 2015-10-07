Given /^je prétends être connecté comme utilisateur normal$/ do
  @user = User.new(name: 'User', email: 'test@test.ca')
  @ability = Ability.new(@user)
  #@user = Fabricate(:user_normal)
  #@ability = Ability.new(@user)
  #@user = setup_authorized_user
end
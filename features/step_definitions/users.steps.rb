Given /^je prétends être connecté comme utilisateur normal$/ do
  @current_user = setup_authorized_user
end

Given /^je prétends être connecté comme utilisateur admin/ do
  @current_user = setup_authorized_admin
end

def setup_authorized_user
  ApplicationController.class_eval do
    def current_user
      @current_user ||= Fabricate(:user_normal)
    end
  end
end

def setup_authorized_admin
  ApplicationController.class_eval do
    def current_user
      @current_user ||= Fabricate(:user_admin)
    end
  end
end
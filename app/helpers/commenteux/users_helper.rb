module Commenteux
  module UsersHelper

    def user_lookup(user_id)
      if user_id
        User.find(user_id).email
      end
    end

  end
end
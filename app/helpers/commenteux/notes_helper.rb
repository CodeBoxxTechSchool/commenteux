module Commenteux
  module NotesHelper

    def display_role?(roles)
      if roles and roles.length > 0
        true
      else
        false
      end
    end

  end
end

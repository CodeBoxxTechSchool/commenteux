require "spec_helper"

module Commenteux
  describe NotesHelper do
    describe "Comportement de la méthode user_lookup" do
      it "doit charger le user en paramètre" do

        user = mock_model(User, {:name => 'blah'})
        ::User.should_receive(:find).with(1).and_return(user)
        user_lookup(1)

      end
    end
  end
end
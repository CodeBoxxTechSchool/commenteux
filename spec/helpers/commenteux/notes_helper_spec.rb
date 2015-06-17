require "spec_helper"

module Commenteux
  describe NotesHelper do

    describe "display_role?" do
      it "la variable rôles contient un type de rôle, alors elle est affichée" do
        result = display_role?(["delivery_man"])
        expect(result).to eq true
      end

      it "la variable rôles ne contient aucune type de rôle, alors elle n'est pas affichée, variable à nil" do
        result = display_role?(nil)
        expect(result).to eq false
      end

      it "la variable rôles ne contient aucune type de rôle, alors elle n'est pas affichée, variable à tableau vide" do
        result = display_role?([])
        expect(result).to eq false
      end
    end
  end
end
require 'spec_helper'

module Commenteux
  describe NotesController do
    routes { Commenteux::Engine.routes }

    before(:each) do
      @dummy_model = mock_model(DummyModel)
      @comments = double(Object)
    end

    describe "GET 'index'" do

      it "doit fetché la ressource passé en paramètre, le layout de l'application hôte sera utilisé" do

        DummyModel.should_receive(:find).with('1').and_return(@dummy_model)
        @dummy_model.stub(:comments) { @comments }
        @comments.stub(:all) { [] }
        get 'index', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: 'application'

      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do

        DummyModel.should_receive(:find).with('1').and_return(@dummy_model)
        @dummy_model.stub(:comments) { @comments }
        @comments.stub(:all) { [] }
        xhr :get, 'index', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: false

      end

    end

    describe "GET 'new'" do

      it "doit fetché la ressource en paramètre et préparé le nouveau commentaire a saisir, le layout de l'application hôte sera utilisé" do

        subject.should_receive(:fetch_resource).and_return(@dummy_model)
        @dummy_model.stub(:comments) { @comments }
        @comments.should_receive(:new)

        get 'new', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: 'application'

      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do

        subject.should_receive(:fetch_resource).and_return(@dummy_model)
        @dummy_model.stub(:comments) { @comments }
        @comments.should_receive(:new)

        xhr :get, 'new', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: false

      end

    end

    describe "POST 'create'" do

      it "Doit créer le commentaire saisi sur la ressource en paramètre" do

        DummyModel.should_receive(:find).with('1').and_return(@dummy_model)
        @dummy_model.stub(:comments) { @comments }
        @comments.should_receive(:create).with( { 'title' => 'Titre', 'comment' => 'Commentaire'} )

        post 'create', 'resource' => 'dummy_model', 'resource_id' => '1', 'parent_div' => 'parent_div', :comments => { :title => 'Titre', :comment => 'Commentaire'}

      end

    end

    describe "Comportement de la méthode 'classify_namespace'" do

      it "s'il n'y a pas de namespace, on fait un simple classify" do
        subject.classify_namespace('dummy_model').should eq 'DummyModel'
        subject.classify_namespace('customer').should eq 'Customer'
      end

      it "s'il y a un namespace, on fait un classify sur tous les éléments" do
        subject.classify_namespace('client::customers').should eq 'Client::Customer'
        subject.classify_namespace('namespace::dummy_model').should eq 'Namespace::DummyModel'
      end

    end

  end
end

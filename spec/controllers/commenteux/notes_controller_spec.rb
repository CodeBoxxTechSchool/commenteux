require 'spec_helper'


module Commenteux
  describe Commenteux::NotesController do
    routes { Commenteux::Engine.routes }

    before(:each) do
      @dummy_model = mock_model(DummyModel)
      @comments = double(Object)
    end

    describe "GET 'index'" do

      it "doit fetché la ressource passé en paramètre, le layout de l'application hôte sera utilisé, avec le paramètre rôle" do
        comment_comments = double("comment_comments")
        delivery_man_comments = double("delivery_man_comments")
        list_roles = [comment_comments, delivery_man_comments]

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}

        expect(subject).to receive(:manage_roles_parameter).with('comments,delivery_man') {list_roles}
        expect(subject).to receive(:get_comments).with(@dummy_model, list_roles) {[comment_comments, delivery_man_comments]}

        get 'index', resource: 'dummy_model', resource_id: '1', roles: 'comments,delivery_man'

        assert_template layout: 'application'
      end

      it "doit fetché la ressource passé en paramètre, le layout de l'application hôte sera utilisé, sans le paramètre rôle" do
        comment_comments = double("comment_comments")
        delivery_man_comments = double("delivery_man_comments")

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}

        expect(subject).to receive(:manage_roles_parameter).with(nil) {[]}
        expect(subject).to receive(:get_comments).with(@dummy_model, []) {[comment_comments, delivery_man_comments]}

        get 'index', resource: 'dummy_model', resource_id: '1'

        assert_template layout: 'application'
      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:comments) {@comments}
        expect(@comments).to receive(:all) {[]}
        xhr :get, 'index', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: false

      end

    end

    describe "GET 'new'" do

      it "doit fetché la ressource en paramètre et préparé le nouveau commentaire a saisir, le layout de l'application hôte sera utilisé, sans le paramètre rôle" do

        expect(subject).to receive(:fetch_resource) {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:new)

        get 'new', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: 'application'

      end

      it "doit fetché la ressource en paramètre et préparé le nouveau commentaire a saisir, le layout de l'application hôte sera utilisé, avec le paramètre rôle" do

        expect(subject).to receive(:fetch_resource) {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments_comments') {@comments}
        expect(@comments).to receive(:new)

        get 'new', 'resource' => 'dummy_model', 'resource_id' => '1', 'roles' => 'comments,delivery_man'

        assert_template layout: 'application'

      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do

        expect(subject).to receive(:fetch_resource) {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:new)

        xhr :get, 'new', 'resource' => 'dummy_model', 'resource_id' => '1'

        assert_template layout: false

      end

    end

    describe "POST 'create'" do

      it "Doit créer le commentaire saisi sur la ressource en paramètre, rôle spécifié en paramètre" do

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:send).with('delivery_man_comments') {@comments}
        expect(@comments).to receive(:create).with({ 'title' => 'Titre', 'comment' => 'Commentaire', 'role' => 'delivery_man'})

        post 'create', 'resource' => 'dummy_model', 'resource_id' => '1', 'parent_div' => 'parent_div', 'comments' => { 'title' => 'Titre', 'comment' => 'Commentaire', 'role' => 'delivery_man'}, 'roles' => 'comments,delivery_man'

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&roles=comments,delivery_man")

      end

      it "Doit créer le commentaire saisi sur la ressource en paramètre, rôle non spécifié en paramètre" do

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:create).with({ 'title' => 'Titre', 'comment' => 'Commentaire'})

        post 'create', 'resource' => 'dummy_model', 'resource_id' => '1', 'parent_div' => 'parent_div', 'comments' => { 'title' => 'Titre', 'comment' => 'Commentaire'}

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div")
      end
    end

    describe "Comportement de la méthode 'classify_namespace'" do

      it "s'il n'y a pas de namespace, on fait un simple classify" do
        dummyModel = controller.send(:classify_namespace, 'dummy_model')
        expect(dummyModel).to eq 'DummyModel'

        customer = controller.send(:classify_namespace, 'customer')
        expect(customer).to eq 'Customer'
      end

      it "s'il y a un namespace, on fait un classify sur tous les éléments" do
        customer = controller.send(:classify_namespace, 'client::customers')
        expect(customer).to eq 'Client::Customer'

        dummyModel = controller.send(:classify_namespace, 'namespace::dummy_model')
        expect(dummyModel).to eq 'Namespace::DummyModel'
      end

    end

    describe "Comportement de la méthode 'get_comments'" do

      it "s'il y a plusieurs roles de spécifiés" do
        comments1 = double("comments1")
        comments2 = double("comments2")

        expect(@dummy_model).to receive(:send).with('comments_comments') {comments1}
        expect(comments1).to receive(:all) {[comments1]}

        expect(@dummy_model).to receive(:send).with('delivery_man_comments') {comments2}
        expect(comments2).to receive(:all) {[comments2]}

        comments = controller.send(:get_comments, @dummy_model, [['comments','Admin'],['delivery_man','Livreur']])

        expect(comments[0]).to eq comments1
        expect(comments[1]).to eq comments2
      end

      it "s'il y a aucun role de spécifié" do
        comments1 = double("comments1")

        expect(@dummy_model).to receive(:comments) {comments1}
        expect(comments1).to receive(:all) {[comments1]}

        comments = controller.send(:get_comments, @dummy_model, nil)

        expect(comments[0]).to eq comments1
      end

    end

    describe "Comportement de la méthode 'get_comment_method'" do

      it "s'il y a un rôle spécifié" do
        expect(@dummy_model).to receive(:send).with("delivery_man_comments") {@comments}
        controller.send(:get_comment_model_method, @dummy_model, "delivery_man")
      end

      it "s'il n'y a pas de rôle spécifié" do
        expect(@dummy_model).to receive(:send).with("comments") {@comments}
        controller.send(:get_comment_model_method, @dummy_model, nil)
      end

    end

    describe "Comportement de la méthode 'manage_roles_parameter'" do
     it "avec paramètres" do
       list_roles = controller.send(:manage_roles_parameter, 'comments,delivery_man')

       expect(list_roles).to eq [['comments','Administrateur'],['delivery_man','Livreur']]
      end
    end

    describe "Comportement de la méthode 'manage_roles_parameter'" do
      it "sans paramètre" do
        list_roles = controller.send(:manage_roles_parameter, nil)

        expect(list_roles).to eq []
      end
    end

  end
end

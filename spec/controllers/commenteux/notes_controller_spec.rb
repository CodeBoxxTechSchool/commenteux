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
        comment_comment = double("comment_comments")
        delivery_man_comment = double("delivery_man_comments")
        list_roles = [comment_comment, delivery_man_comment]

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}

        expect(subject).to receive(:manage_roles_parameter).with('comments,delivery_man') {list_roles}
        expect(subject).to receive(:get_comments).with(@dummy_model, list_roles) {[comment_comment, delivery_man_comment]}

        get :index, resource: 'dummy_model', resource_id: '1', roles: 'comments,delivery_man'

        assert_template layout: 'application'
      end

      it "doit fetché la ressource passé en paramètre, le layout de l'application hôte sera utilisé, sans le paramètre rôle" do
        comment_comment = double("comment_comments")
        delivery_man_comment = double("delivery_man_comments")

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}

        expect(subject).to receive(:manage_roles_parameter).with(nil) {[]}
        expect(subject).to receive(:get_comments).with(@dummy_model, []) {[comment_comment, delivery_man_comment]}

        get :index, resource: 'dummy_model', resource_id: '1'

        assert_template layout: 'application'
      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do
        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:comments) {@comments}
        expect(@comments).to receive(:to_a) {[]}
        xhr :get, :index, resource: 'dummy_model', resource_id: '1'

        assert_template layout: false

      end

      it "le paramètre display_list_notes est à false alors les notes ne sont pas recherchées" do
        comment_comment = double("comment_comments")
        delivery_man_comment = double("delivery_man_comments")
        list_roles = [comment_comment, delivery_man_comment]

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}

        expect(subject).to receive(:manage_roles_parameter).with('comments,delivery_man') {list_roles}

        get :index, resource: 'dummy_model', resource_id: '1', roles: 'comments,delivery_man', display_list_notes: 'false'

        assert_template layout: 'application'
      end

    end

    describe "GET 'new'" do

      it "doit fetché la ressource en paramètre et préparé le nouveau commentaire a saisir, le layout de l'application hôte sera utilisé, sans le paramètre rôle" do

        expect(subject).to receive(:fetch_resource) {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:new)

        get :new, resource: 'dummy_model', resource_id: '1'

        assert_template layout: 'application'

      end

      it "doit fetché la ressource en paramètre et préparé le nouveau commentaire a saisir, le layout de l'application hôte sera utilisé, avec le paramètre rôle" do

        expect(subject).to receive(:fetch_resource) {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments_comments') {@comments}
        expect(@comments).to receive(:new)

        get :new, resource: 'dummy_model', resource_id: '1', roles: 'comments,delivery_man'

        assert_template layout: 'application'

      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do

        expect(subject).to receive(:fetch_resource) {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:new)

        xhr :get, :new, resource: 'dummy_model', resource_id: '1'

        assert_template layout: false

      end

    end

    describe "POST 'create'" do

      it "Doit créer le commentaire saisi sur la ressource en paramètre, rôle spécifié en paramètre" do

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:send).with('delivery_man_comments') {@comments}
        expect(@comments).to receive(:create).with({ 'title' => 'Titre', 'comment' => 'Commentaire', 'role' => 'delivery_man'})

        post :create, resource: 'dummy_model', resource_id: '1', parent_div: 'parent_div', comments: {title: 'Titre', comment: 'Commentaire', role: 'delivery_man'}, roles: 'comments,delivery_man'

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&roles=comments,delivery_man&display_list_notes=true")

      end

      it "Doit créer le commentaire saisi sur la ressource en paramètre, rôle non spécifié en paramètre" do

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:create).with({ 'title' => 'Titre', 'comment' => 'Commentaire', "role"=>"comments"})

        post :create, resource: 'dummy_model', resource_id: '1', parent_div: 'parent_div', comments: { title: 'Titre', comment: 'Commentaire', role: 'comments'}

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&display_list_notes=true")
      end

      it "Doit créer le commentaire saisi sur la ressource en paramètre, rôle non spécifié et display list notes spécifié a false en paramètre" do

        expect(DummyModel).to receive(:find).with('1') {@dummy_model}
        expect(@dummy_model).to receive(:send).with('comments') {@comments}
        expect(@comments).to receive(:create).with({ 'title' => 'Titre', 'comment' => 'Commentaire', "role"=>"comments"})

        expect(subject).to receive(:get_comments) {@comments}

        post :create, resource: 'dummy_model', resource_id: '1', parent_div: 'parent_div', comments: { title: 'Titre', comment: 'Commentaire', role: 'comments'}, display_list_notes: 'false'

        expect(subject).to_not redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&display_list_notes=true")

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
        comment1 = double
        comment2 = double

        expect(@dummy_model).to receive(:send).with('comments_comments') {comment1}
        expect(comment1).to receive(:to_a) {[comment1]}

        expect(@dummy_model).to receive(:send).with('delivery_man_comments') {comment2}
        expect(comment2).to receive(:to_a) {[comment2]}

        comments = controller.send(:get_comments, @dummy_model, [['comments','Admin'],['delivery_man','Livreur']])

        expect(comments[0]).to eq comment1
        expect(comments[1]).to eq comment2
      end

      it "s'il y a aucun role de spécifié" do
        comment1 = double

        expect(@dummy_model).to receive(:comments) {comment1}
        expect(comment1).to receive(:to_a) {[comment1]}

        comments = controller.send(:get_comments, @dummy_model, nil)

        expect(comments[0]).to eq comment1
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

      it "s'il y a un rôle spécifié vide" do
        expect(@dummy_model).to receive(:send).with("comments") {@comments}
        controller.send(:get_comment_model_method, @dummy_model, '')
      end
    end

    describe "Comportement de la méthode 'manage_roles_parameter'" do
      it "avec des paramètres" do
        list_roles = controller.send(:manage_roles_parameter, 'comments,delivery_man')

        expect(list_roles).to eq [['comments','Administrateur'],['delivery_man','Livreur']]
      end

      it "avec un paramètre" do
        list_roles = controller.send(:manage_roles_parameter, 'delivery_man')

        expect(list_roles).to eq [['delivery_man','Livreur']]
      end

      it "sans paramètre" do
        list_roles = controller.send(:manage_roles_parameter, nil)

        expect(list_roles).to eq []
      end
    end

    describe "destroy" do
      it "Détruire le commentaire" do
        dummy_model = double
        comment_model = double

        expect(subject).to receive(:fetch_resource) {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, nil) {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}
        expect(comment_model).to receive(:destroy!) {true}

        delete :destroy, resource: 'dummy_model', resource: 'test', resource_id: '1', id: '2', format: :js

        #expect(flash[:success]).to eq "Commentaire supprimé avec succès"
      end

      it "Détruire le commentaire avec un paramètre rôle " do
        dummy_model = double
        comment_model = double

        expect(subject).to receive(:fetch_resource) {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, 'delivery_man') {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}
        expect(comment_model).to receive(:destroy!) {true}

        delete :destroy, resource: 'dummy_model', resource: 'test', resource_id: '1', id: '2', comment_role: 'delivery_man', format: :js

        #expect(flash[:success]).to eq "Commentaire supprimé avec succès"
      end

      it "Commentaire n'existe pas dans le base de données" do
        dummy_model = double
        comment_model = double

        expect(subject).to receive(:fetch_resource) {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, nil) {comment_model}
        expect(comment_model).to receive(:find).with('2').and_raise(ActiveRecord::RecordNotFound)

        delete :destroy, resource: 'dummy_model', resource: 'test', resource_id: '1', id: '2', format: :js

        #expect(flash[:error]).to eq "Ce commentaire n'existe plus."
      end
    end

    describe "edit" do
      specify "Doit fetcher la ressource en paramètre et retourner le commentaire, avec les paramètres comment_role, parent_div et rôle" do
        dummy_model = double
        comment_model = double

        expect(subject).to receive(:fetch_resource) {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, 'delivery_man') {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}

        get :edit, resource: 'dummy_model', resource_id: '1', id: '2', comment_role: 'delivery_man', parent_div: 'parent_div', roles: 'comments,delivery_man'

        assert_template layout: 'application'
      end

      specify "Doit fetcher la ressource en paramètre et retourner le commentaire, sans les paramètres comment_role, parent_div et rôle" do
        dummy_model = double
        comment_model = double

        expect(subject).to receive(:fetch_resource) {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, nil) {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}

        get :edit, resource: 'dummy_model', resource_id: '1', id: '2'

        assert_template layout: 'application'

      end

      it "si l'appel provient d'un call Ajax, on n'affiche pas de layout" do

        dummy_model = double
        comment_model = double

        expect(subject).to receive(:fetch_resource) {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, nil) {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}

        xhr :get, :edit, resource: 'dummy_model', resource_id: '1', id: '2'

        assert_template layout: false

      end
    end

    describe "update" do
      specify "Doit modifier le commentaire sur la ressource en paramètre, rôle spécifié en paramètre" do
        dummy_model = double
        comment_model = double

        expect(DummyModel).to receive(:find).with('1') {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, 'delivery_man') {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}
        expect(comment_model).to receive(:update).with({"title"=>"Titre", "comment"=>"Commentaire", "role"=>"delivery_man", "id"=>"2"}) {true}

        patch :update, resource: 'dummy_model', resource_id: '1', id: '2', comments: {id: '2', title: 'Titre', comment: 'Commentaire', role: 'delivery_man'}, parent_div: 'parent_div', roles: 'comments,delivery_man'

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&roles=comments,delivery_man&display_list_notes=true")

        #expect(flash[:success]).to eq "Commentaire modifié avec succès"
      end

      specify "Doit modifier le commentaire sur la ressource en paramètre, rôle non spécifié en paramètre" do
        dummy_model = double
        comment_model = double

        expect(DummyModel).to receive(:find).with('1') {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, nil) {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}
        expect(comment_model).to receive(:update).with({"title"=>"Titre", "comment"=>"Commentaire", "role"=>"delivery_man", "id"=>"2"}) {true}

        patch :update, resource: 'dummy_model', resource_id: '1', id: '2', comments: {id: '2', title: 'Titre', comment: 'Commentaire', role: 'delivery_man'}, parent_div: 'parent_div'

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&display_list_notes=true")

        #expect(flash[:success]).to eq "Commentaire modifié avec succès"
      end

      specify "Sauvegarde du commentaire n'a pas fonctionné" do
        dummy_model = double
        comment_model = double

        expect(DummyModel).to receive(:find).with('1') {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, 'delivery_man') {comment_model}
        expect(comment_model).to receive(:find).with('2') {comment_model}
        expect(comment_model).to receive(:update).with({"title"=>"Titre", "comment"=>"Commentaire", "role"=>"delivery_man", "id"=>"2"}) {false}

        patch :update, resource: 'dummy_model', resource_id: '1', id: '2', comments: {id: '2', title: 'Titre', comment: 'Commentaire', role: 'delivery_man'}, parent_div: 'parent_div', roles: 'comments,delivery_man'

        expect(response).to render_template("commenteux/notes/edit")

        #expect(flash[:danger]).to eq "Impossible de sauvegarder le commentaire"
      end

      specify "Sauvegarde du commentaire n'a pas fonctionné" do
        dummy_model = double
        comment_model = double

        expect(DummyModel).to receive(:find).with('1') {dummy_model}
        expect(subject).to receive(:get_comment_model_method).with(dummy_model, 'delivery_man') {comment_model}
        expect(comment_model).to receive(:find).with('2').and_raise(ActiveRecord::RecordNotFound)

        patch :update, resource: 'dummy_model', resource_id: '1', id: '2', comments: {id: '2', title: 'Titre', comment: 'Commentaire', role: 'delivery_man'}, parent_div: 'parent_div', roles: 'comments,delivery_man'

        expect(subject).to redirect_to("/commenteux/dummy_model/1?parent_div=parent_div&roles=comments,delivery_man&display_list_notes=true")

        #expect(flash[:danger]).to eq "Ce commentaire n'existe plus."
      end
    end
  end
end

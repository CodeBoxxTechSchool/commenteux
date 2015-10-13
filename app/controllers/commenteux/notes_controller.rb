require_dependency "commenteux/application_controller"

module Commenteux
  class NotesController < ApplicationController
    helper UsersHelper

    def index
      resource = fetch_resource
      fetch_params
      list_roles = manage_roles_parameter(params[:roles])
      @comments = get_comments(resource, list_roles) if @display_list_notes == "true"

      render :layout => false if request.xhr?
    end

    def new
      resource = fetch_resource
      fetch_params
      @list_roles = manage_roles_parameter(params[:roles])
      role = @list_roles[0][0] if @list_roles and @list_roles.length > 0
      @comment = get_comment_model_method(resource, role).new

      render :layout => false if request.xhr?
    end

    def create
      resource = fetch_resource
      fetch_params
      comment_params
      roles = ''
      if @roles
        roles = '&roles=' + @roles
        comment_role = params[:comments][:role]
      end
      get_comment_model_method(resource, comment_role).create(comment_params)

      redirect_to "/commenteux/#{@resource.downcase}/#{@resource_id}?parent_div=" + @parent_div + roles + "&display_list_notes=#{@display_list_notes}"
    end

    def edit
      resource = fetch_resource
      fetch_params
      @list_roles = manage_roles_parameter(params[:roles])
      @comment = get_comment_model_method(resource, params[:comment_role]).find(params[:id])

      render :layout => false if request.xhr?
    end

    def update
      begin
        resource = fetch_resource
        fetch_params
        comment_params
        roles = ''
        unless @roles.blank?
          roles = '&roles=' + @roles
          comment_role = params[:comments][:role]
        end
        @comment = get_comment_model_method(resource, comment_role).find(params[:id])

        if @comment.update(comment_params)
         #flash[:success] = "Commentaire modifié avec succès"
         redirect_to "/commenteux/#{@resource.downcase}/#{@resource_id}?parent_div=" + @parent_div + roles + "&display_list_notes=#{@display_list_notes}"
        else
          #flash[:danger] = "Impossible de sauvegarder le commentaire"
          render action: 'edit', :layout => false
        end
      rescue ActiveRecord::RecordNotFound
        #flash[:danger] = "Ce commentaire n'existe plus."
        redirect_to "/commenteux/#{@resource.downcase}/#{@resource_id}?parent_div=" + @parent_div + roles + "&display_list_notes=#{@display_list_notes}"
      end
    end

    def destroy
      begin
        resource = fetch_resource
        @comment = get_comment_model_method(resource, params[:comment_role]).find(params[:id])
        @comment.destroy!
        #flash[:success] = "Commentaire supprimé avec succès"
      rescue ActiveRecord::RecordNotFound
        #flash[:error] = "Ce commentaire n'existe plus."
      end
      respond_to do |format|
        format.js
      end
    end

    protected
    def comment_params
      comment_permit_fields = [:title, :comment, :user_id, :role, :id]
      params.require(:comments).permit(comment_permit_fields)
    end

    def fetch_resource
      @resource = params[:resource]
      @class_name = classify_namespace(params[:resource])
      @resourceKlass = eval(@class_name)
      @resource_id = params[:resource_id]
      @resourceKlass.find(@resource_id)
    end

    def fetch_params
      @roles = params[:roles]
      @parent_div = params[:parent_div]
      @display_list_notes = params[:display_list_notes] || "true"
    end

    def classify_namespace(const)
      const = const.classify
      if const.include?('::')
        new_const = ''
        splitted = const.split('::')
        for str in splitted do
          new_const = new_const + str.classify + '::'
        end
        const = new_const[0..(new_const.length - 3)]
      end
      const
    end

    def get_comments(resource, roles)
      comments = []
      if roles and roles.length > 0
        roles.each do |role|
          comments += get_comment_model_method(resource, role[0]).to_a
        end
      else
        comments = get_comment_model_method(resource, nil).to_a
      end
      comments
    end

    def get_comment_model_method(resource, role)
      if role.blank?
        role_comment = "comments"
      else
        role_comment = role + "_comments"
      end
      resource.send(role_comment)
    end

    def manage_roles_parameter(roles_parameter)
      roles = []
      unless roles_parameter.blank?
        if roles_parameter.include?(',')
          splitted = roles_parameter.split(',')
          for str in splitted do
            roles << [str, I18n.t(str)]
          end
        else
          roles << [roles_parameter, I18n.t(roles_parameter)]
        end
      end
      roles
    end

  end
end

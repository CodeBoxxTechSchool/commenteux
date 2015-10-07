require_dependency "commenteux/application_controller"

module Commenteux
  class NotesController < ApplicationController
    helper UsersHelper

    def index
      resource = fetch_resource
      @roles = params[:roles]
      list_roles = manage_roles_parameter(params[:roles])
      @display_list_notes = params[:display_list_notes] || "true"
      @comments = get_comments(resource, list_roles) if @display_list_notes == "true"
      @parent_div = params[:parent_div]

      render :layout => false if request.xhr?
    end

    def new
      resource = fetch_resource
      @roles = params[:roles]
      @list_roles = manage_roles_parameter(params[:roles])
      role = @list_roles[0][0] if @list_roles and @list_roles.length > 0
      @comments = get_comment_model_method(resource, role).new
      @parent_div = params[:parent_div]
      @display_list_notes = params[:display_list_notes] || "true"

      render :layout => false if request.xhr?
    end

    def create
      resource = fetch_resource
      comments_params
      get_comment_model_method(resource, params[:comments][:role]).create(comments_params)
      @parent_div = params[:parent_div]
      roles = ''
      roles = '&roles=' + params[:roles] if params[:roles]
      display_list_notes = params[:display_list_notes] || "true"

      redirect_to "/commenteux/#{@resource.downcase}/#{@resource_id}?parent_div=" + @parent_div + roles + "&display_list_notes=#{display_list_notes}"
    end

    # def destroy
    #   begin
    #     @comment = fetch_resource
    #     #comments_params
    #     #@comment = resource.find(params[:comments][:id])
    #     #@comment = get_comment_model_method(resource, params[:comments][:role]).find(params[:comments][:id])
    #     @comment.destroy!
    #     flash.now[:success] = "Commentaire supprimé avec succès"
    #   rescue ActiveRecord::RecordNotFound
    #     flash.now[:error] = "Ce commentaire n'existe plus."
    #   # rescue ActiveRecord::RecordNotDestroyed
    #   #   flash.now[:error] = "Cette adresse ne peut être supprimée car elle est attachée à un contrat."
    #   end
    # end

    protected
    def comments_params
      comments_permit_fields = [:title, :comment, :user_id, :role, :roles]
      params.require(:comments).permit(
          comments_permit_fields)
    end

    def fetch_resource
      @resource = params[:resource]
      @class_name = classify_namespace(params[:resource])
      @resourceKlass = eval(@class_name)
      @resource_id = params[:resource_id]
      @resourceKlass.find(@resource_id)
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
      if role
        role_comments = role + "_comments"
      else
        role_comments = "comments"
      end
      resource.send(role_comments)
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

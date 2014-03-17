require_dependency "commenteux/application_controller"

module Commenteux
  class NotesController < ApplicationController

    def comments_params
      comments_permit_fields = [:title, :comment, :user_id]
      params.require(:comments).permit(
          comments_permit_fields)
    end

    def index
      resource = fetch_resource
      @comments = resource.comments.all
      @parent_div = params[:parent_div]

      if request.xhr?
        render :layout => false
      end

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

    def new
      resource = fetch_resource
      @comments = resource.comments.new
      @parent_div = params[:parent_div]

      if request.xhr?
        render :layout => false
      end

    end

    def create
      resource = fetch_resource
      resource.comments.create(comments_params)
      @parent_div = params[:parent_div]
      redirect_to "/commenteux/#{@resource.downcase}/#{@resource_id}?parent_div=" + @parent_div
    end

  end
end

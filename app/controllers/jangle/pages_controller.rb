module Jangle
  class PagesController < Jangle::BaseController

    before_filter :check_for_layouts, :only => [:new, :edit]

    create! do |success, failure|
      success.html do
        flash[:notice] = 'Page created'
        redirect_to :action => :edit, :id => @page
      end
      failure.html do
        flash.now[:error] = 'Failed to create page'
        render :action => :new
      end
    end

    update! do |success, failure|
      success.html do
        flash[:notice] = 'Page updated'
        redirect_to :action => :edit, :id => @page
      end
      failure.html do
        flash.now[:error] = 'Failed to update page'
        render :action => :edit
      end
    end

    destroy! do |success, failure|
      success.html do
        flash[:notice] = 'Page deleted'
        redirect_to :action => :index
      end
    end

  protected
    def check_for_layouts
      if Jangle::Layout.count == 0
        flash[:error] = 'No Layouts found. Please create one.'
        redirect_to new_jangle_layout_path
      end
    end

    def begin_of_association_chain
      current_site
    end
  end
end
module Jangle
  class LayoutsController < Jangle::BaseController

    create! do |success, failure|
      success.html do
        flash[:notice] = 'Layout created'
        redirect_to :action => :edit, :id => @layout
      end
      failure.html do
        flash.now[:error] = 'Failed to create layout'
        render :action => :new
      end
    end

    update! do |success, failure|
      success.html do
        flash[:notice] = 'Layout updated'
        redirect_to :action => :edit, :id => @layout
      end
      failure.html do
        flash.now[:error] = 'Failed to update layout'
        render :action => :edit
      end
    end

    destroy! do |success, failure|
      success.html do
        flash[:notice] = 'Layout deleted'
        redirect_to :action => :index
      end
    end

  protected

    def begin_of_association_chain
      current_site
    end

  end
end
module Jangle
  class SitesController < Jangle::BaseController
    before_filter :require_site, :except => [ :new, :create ]

    create! do |success, failure|
      success.html do
        flash[:notice] = 'Site created'
        redirect_to :action => :edit, :id => @site
      end
      failure.html do
        flash.now[:error] = 'Failed to create site'
        render :action => :new
      end
    end

    update! do |success, failure|
      success.html do
        flash[:notice] = 'Site updated'
        redirect_to :action => :edit, :id => @site
      end
      failure.html do
        flash.now[:error] = 'Failed to update site'
        render :action => :edit
      end
    end

    destroy! do |success, failure|
      success.html do
        flash[:notice] = 'Site deleted'
        redirect_to :action => :index
      end
    end
  end
end
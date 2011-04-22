module Jangle
  class RenderingController < ActionController::Base

    include Jangle::Routing::SiteDispatcher

    include Jangle::Render

    before_filter :require_site
    before_filter :load_layout, :only => [ :css, :js ]

    def show
      render_jangle_page
    end

    def css
      render :text => @layout.css, :content_type => 'text/css'
    end

    def js
      render :text => @layout.js, :content_type => 'text/javascript'
    end

  protected

    def load_layout
      @layout = current_site.layouts.find_by_slug(params[:slug])
    end

  end
end
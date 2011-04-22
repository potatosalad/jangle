module Jangle
  class RenderingController < ActionController::Base

    include Jangle::Routing::SiteDispatcher

    include Jangle::Render

    before_filter :require_site

    def show
      render_jangle_page
    end

  end
end
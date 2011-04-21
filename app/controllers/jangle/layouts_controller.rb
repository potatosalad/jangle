module Jangle
  class LayoutsController < Jangle::BaseController
    def create
      @layout = current_site.layouts.build(params[:jangle_layout])
      create!
    end
  end
end
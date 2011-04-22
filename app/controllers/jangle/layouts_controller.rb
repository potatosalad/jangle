module Jangle
  class LayoutsController < Jangle::BaseController

  protected

    def begin_of_association_chain
      current_site
    end

  end
end
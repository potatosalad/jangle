module Jangle
  class WidgetsController < Jangle::BaseController

    before_filter :check_for_layouts, :only => [:new, :edit]

  protected
    def check_for_layouts
      if Jangle::Layout.count == 0
        flash[:error] = 'No Layouts found. Please create one.'
        redirect_to new_jangle_layout_path
      end
    end
  end
end
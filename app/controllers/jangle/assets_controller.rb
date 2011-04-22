module Jangle
  class AssetsController < Jangle::BaseController

    respond_to :html, :js

    def create
      @asset = end_of_association_chain.build(:source => params[:file])
      @asset.name = @asset.source.filename
      create! do
        return render :partial => 'file.html.erb', :object => @asset
      end
    end

  protected

    def begin_of_association_chain
      current_site
    end
  end
end
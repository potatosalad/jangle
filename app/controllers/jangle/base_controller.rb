module Jangle
  class BaseController < InheritedResources::Base

    include InheritedResources::DSL
    include Jangle::Routing::SiteDispatcher

    layout 'jangle/application'

    #before_filter :authenticate_admin!

    before_filter :require_site

    actions :all, :except => [:show]

    respond_to :html

  end
end
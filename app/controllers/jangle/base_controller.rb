module Jangle
  class BaseController < ApplicationController < InheritedResources::Base

    include Jangle::Routing::SiteDispatcher

    before_filter :authenticate_admin!

    before_filter :require_site

    respond_to :html

  end
end
# From: https://github.com/locomotivecms/engine
module Jangle
  module Routing
    module SiteDispatcher

      extend ActiveSupport::Concern

      included do
        if self.respond_to?(:before_filter)
          before_filter :fetch_site

          helper_method :current_site
        end
      end

      module InstanceMethods

        protected

        def fetch_site
          Jangle.logger "[fetch site] host = #{request.host} / #{request.env['HTTP_HOST']}"
          hostname = Jangle.config.override_host || request.host.downcase
          @current_site ||= Jangle::Site.where(hostname: hostname).first
        end

        def current_site
          @current_site || fetch_site
        end

        def require_site
          return true if current_site

          hostname = Jangle.config.override_host || request.host.downcase

          if Jangle.config.auto_manage_sites
            @current_site = Jangle::Site.find_or_create_by(hostname: hostname)
            @current_site.valid? and return true
          end

          render_no_site_error and return false
        end

        def render_no_site_error
          flash[:error] = 'No Site defined for this hostname. Create it now.'
          return redirect_to(new_jangle_site_path)
        end

      end

    end
  end
end

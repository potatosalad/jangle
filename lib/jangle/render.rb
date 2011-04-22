module Jangle
  module Render

    extend ActiveSupport::Concern

    module InstanceMethods

    protected

      def render_jangle_page
        if request.fullpath =~ /^\/#{Jangle.config.admin_route_prefix}\//
          render_not_found
        else
          @page = jangle_page

          redirect_to(@page.redirect_url) and return if @page.present? && @page.redirect?

          render_not_found and return if @page.nil?

          output = @page.render(jangle_context)

          self.prepare_and_set_response(output)
        end
      end

      def jangle_page
        path = (params[:path] || request.fullpath).clone # TODO: params[:path] is more consistent
        path.gsub!(/\.[a-zA-Z][a-zA-Z0-9]{2,}$/, '')
        path.gsub!(/^\//, '')
        path = 'index' if path.blank?

        #if path != 'index'
        #  dirname = File.dirname(path).gsub(/^\.$/, '') # also look for templatized page path
        #  path = [path, File.join(dirname, 'content_type_template').gsub(/^\//, '')]
        #end

        if page = current_site.pages.any_in(:fullpath => [*path]).first
          page = nil if not page.published? # and current_admin.nil?
        end

        page || not_found_page
      end

      def jangle_context
        assigns = {
          'site'              => current_site,
          'page'              => @page,
          'current_page'      => self.params[:page]
        }.merge(flash.stringify_keys) # data from api

        registers = {
          :controller     => self,
          :site           => current_site,
          :page           => @page
        }

        ::Liquid::Context.new({}, assigns, registers)
      end

      def prepare_and_set_response(output, content_type = 'text/html; charset=utf-8')
        flash.discard

        layout = @page.layout.app_layout.present? ? @page.layout.app_layout : false

        render :text => output, :layout => layout, :content_type => content_type, :status => page_status
      end

      def not_found_page
        current_site.pages.not_found.published.first
      end

      def page_status
        @page.not_found? ? :not_found : :ok
      end

    end
  end
end
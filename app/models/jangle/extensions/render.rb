module Models
  module Jangle
    module Extensions
      module Render
        extend ActiveSupport::Concern

        module InstanceMethods
          def render(context)
            if self.respond_to?(:layout)
              layout.render('content_for_layout' => self.template.render(context))
            else
              self.template.render(context)
            end
          end
        end
      end
    end
  end
end
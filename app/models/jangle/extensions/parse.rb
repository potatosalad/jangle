module Models
  module Jangle
    module Extensions
      module Parse
        extend ActiveSupport::Concern

        module InstanceMethods
          def template(reload = false)
            @template = nil if reload
            @template ||= ::Liquid::Template.parse(self.content)
          end
        end
      end
    end
  end
end
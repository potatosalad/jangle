module Jangle
  module Liquid
    module Tags

      class Widget < ::Liquid::Include

        attr_accessor :slug
        attr_accessor :partial

        def initialize(tag_name, markup, tokens)
          super

          @slug = @template_name.gsub('\'', '')

          @partial = Jangle::Widget.find_by_slug(@slug)

        end

        def render(context)
          return '' if @partial.nil?

          variable = context[@variable_name || @template_name[1..-2]]

          context.stack do
            @attributes.each do |key, value|
              context[key] = context[value]
            end

            output = (if variable.is_a?(Array)
              variable.collect do |variable|
                context[@template_name[1..-2]] = variable
                @partial.render(context)
              end
            else
              context[@template_name[1..-2]] = variable
              @partial.render(context)
            end)

            output
          end
        end

      end

      ::Liquid::Template.register_tag('widget', Widget)
    end
  end
end
require 'formtastic'

module Jangle
  class FormBuilder < ::Formtastic::SemanticFormBuilder
    def commit_button(*args)
      options = args.extract_options!
      wrapper_html = options.delete(:wrapper_html) || {}
      wrapper_html[:class] = (%w(form_element submit_element) << wrapper_html[:class]).flatten.compact.join(' ')

      super(*(args << options.merge(:wrapper_html => wrapper_html)))
    end

    def submit(*args)
      template.content_tag(:div, nil, :class => 'label') <<
        template.content_tag(:div, super(*args), :class => 'value')
    end

    def input(method, options = {})
      options = options.dup
      wrapper_html = options.delete(:wrapper_html) || {}
      wrapper_html[:class] = (%w(form_element) << wrapper_html[:class]).flatten.compact.join(' ')

      super(method, options.merge(:wrapper_html => wrapper_html))
    end

    def label(*args)
      template.content_tag(:div, super(*args), :class => 'label')
    end

    def select(*args)
      template.content_tag(:div, super(*args), :class => 'value')
    end

    def basic_input_helper(form_helper_method, type, method, options) #:nodoc:
      html_options = options.delete(:input_html) || {}
      html_options = default_string_options(method, type).merge(html_options) if [:numeric, :string, :password, :text, :phone, :search, :url, :email].include?(type)
      field_id = generate_html_id(method, "")
      html_options[:id] ||= field_id
      label_options = options_for_label(options)
      label_options[:for] ||= html_options[:id]
      label(method, label_options) <<
        template.content_tag(
          :div,
          send(respond_to?(form_helper_method) ? form_helper_method : :text_field, method, html_options),
          :class => 'value'
        )
    end

    # Ouputs a label and standard Rails code area inside the wrapper.
    def code_input(method, options)
      options = options.dup
      code_class = options.delete(:class) || ''
      input_html = options.delete(:input_html) || {}
      input_html[:class] = (%w(code) << input_html[:class] << code_class).flatten.compact.join(' ')

      basic_input_helper(:text_area, :text, method, options.merge(:input_html => input_html))
    end
  end
end
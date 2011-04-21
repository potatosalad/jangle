module ApplicationHelper
  # Wrapper around CmsFormBuilder
  def cms_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    form_for(record_or_name_or_array, *(args << options.merge(:builder => Jangle::CmsFormBuilder)), &proc)
  end

  def jangle_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    semantic_form_for(record_or_name_or_array, *(args << options.merge(:builder => Jangle::FormBuilder)), &proc)
  end
end

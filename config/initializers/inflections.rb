# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

ActiveSupport::Inflector.class_eval do
  # Converts string to something suitable to be used as an element id
  def self.idify(word)
    word.strip.gsub(/\W/, '_').gsub(/\s|^_*|_*$/, '').squeeze('_')
  end
end

class String
  def idify
    ActiveSupport::Inflector.pluralize(self)
  end
end
class Jangle::Widget
  include Jangle::Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  include Models::Jangle::Extensions::Parse
  include Models::Jangle::Extensions::Render

  # -- Fields ---------------------------------------------------------------
  field :label,    :type => String
  slug  :label
  field :content,  :type => String
  field :position, :type => Integer, :default => 0

  # -- Relationships --------------------------------------------------------
  referenced_in :site,
    :class_name => 'Jangle::Site',
    :inverse_of => :widgets
  referenced_in :layout,
    :class_name => 'Jangle::Layout',
    :inverse_of => :widgets
  embeds_many :blocks,
    :class_name => 'Jangle::Block',
    :as         => :container
  accepts_nested_attributes_for :blocks

  # -- Validations ----------------------------------------------------------
  validates :site_id, 
    :presence => true
  validates :label,
    :presence => true
  validates :layout,
    :presence => true

  # -- Class Methods --------------------------------------------------------
  # Tree-like structure for pages
  def self.options_for_select(jangle_site, jangle_widget = nil, current_widget = nil, depth = 0, exclude_self = true, spacer = '. . ')
    out = []
    [current_widget || jangle_site.widgets.roots].flatten.each do |widget|
      next if jangle_widget == widget
      out << [ "#{spacer*depth}#{widget.label}", widget.id ]
      widget.children.each do |child|
        out += options_for_select(jangle_site, jangle_widget, child, depth + 1, spacer)
      end
    end
    return out.compact
  end
end
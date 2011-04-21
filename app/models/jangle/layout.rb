class Jangle::Layout
  include Jangle::Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  # -- Fields ---------------------------------------------------------------
  field :label,      :type => String
  slug  :label
  field :app_layout, :type => String
  field :content,    :type => String
  field :css,        :type => String
  field :js,         :type => String
  field :position,   :type => Integer, :default => 0

  # -- Relationships --------------------------------------------------------
  referenced_in :site,
    :class_name => 'Jangle::Site',
    :inverse_of => :layouts
  references_many :pages,
    :class_name => 'Jangle::Page',
    :inverse_of => :layout,
    :dependent => :nullify

  # -- Validations ----------------------------------------------------------
  validates :site_id,
    :presence   => true
  validates :label,
    :presence   => true
  validates :content,
    :presence   => true

  # -- Class Methods --------------------------------------------------------
  # Tree-like structure for layouts
  def self.options_for_select(jangle_site, jangle_layout = nil, current_layout = nil, depth = 0, spacer = '. . ')
    out = []
    [current_layout || jangle_site.layouts.roots].flatten.each do |layout|
      next if jangle_layout == layout
      out << [ "#{spacer*depth}#{layout.label}", layout.id ]
      layout.children.each do |child|
        out += options_for_select(jangle_site, jangle_layout, child, depth + 1, spacer)
      end
    end
    return out.compact
  end

  # List of available application layouts
  def self.app_layouts_for_select(default = nil)
    Dir.glob(File.expand_path('app/views/layouts/*.html.*', Rails.root)).collect do |filename|
      match = filename.match(/\w*.html.\w*$/)
      app_layout = match && match[0]
      app_layout.to_s[0...1] == '_' ? nil : app_layout
    end.compact.unshift([default, nil])
  end

  # -- Instance Methods -----------------------------------------------------
  # override the slug changes
  def to_param; self._id.to_s; end
end
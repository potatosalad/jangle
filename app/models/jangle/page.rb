class Jangle::Page
  include Jangle::Mongoid::Document
  include Mongoid::Tree

  include Models::Jangle::Extensions::Parse
  include Models::Jangle::Extensions::Render
  include Models::Jangle::Extensions::Redirect

  # -- Fields ---------------------------------------------------------------
  field :label,     :type => String
  field :slug,      :type => String
  field :fullpath,  :type => String
  field :content,   :type => String
  field :position,  :type => Integer, :default => 0
  field :published, :type => Boolean, :default => false

  # -- Relationships --------------------------------------------------------
  referenced_in :site,
    :class_name => 'Jangle::Site',
    :inverse_of => :pages
  referenced_in :layout,
    :class_name => 'Jangle::Layout',
    :inverse_of => :pages
  embeds_many :blocks,
    :class_name => 'Jangle::Block',
    :as         => :container
  accepts_nested_attributes_for :blocks

  # -- Callbacks ------------------------------------------------------------
  before_save { |p| p.fullpath = p.fullpath(true) }

  # -- Named Scopes ---------------------------------------------------------
  scope :root_index, :where => { :slug => 'index' }
  scope :not_found,  :where => { :slug => '404' }
  scope :published,  :where => { :published => true }

  # -- Validations ----------------------------------------------------------
  validates :site_id, 
    :presence => true
  validates :label,
    :presence => true
  validates :layout,
    :presence => true

  # -- Class Methods --------------------------------------------------------
  # Tree-like structure for pages
  def self.options_for_select(jangle_site, jangle_page = nil, current_page = nil, depth = 0, spacer = '. . ')
    return [] if self.count == 0
    out = []
    [current_page || jangle_site.pages.roots].flatten.each do |page|
      next if jangle_page == page
      out << [ "#{spacer*depth}#{page.slug} (#{page.label})", page.id ]
      page.children.each do |child|
        out += options_for_select(jangle_site, jangle_page, child, depth + 1, spacer)
      end
    end
    return out.compact
  end

  # -- Instance Methods -----------------------------------------------------
  def index?
    self.slug == 'index'
  end

  def not_found?
    self.slug == '404'
  end

  def index_or_not_found?
    self.index? || self.not_found?
  end

  def fullpath(force = false)
    if read_attribute(:fullpath).present? && !force
      return read_attribute(:fullpath)
    end

    if self.index_or_not_found?
      self.slug
    else
      slugs = self.ancestors_and_self.map(&:slug)
      File.join slugs
    end
  end

  # Full url for a page
  def url(force = false)
    "http://#{self.site.hostname}/#{self.fullpath(force)}"
  end
end
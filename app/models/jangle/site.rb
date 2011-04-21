class Jangle::Site
  include Jangle::Mongoid::Document

  # -- Fields ---------------------------------------------------------------
  field :label,    :type => String, :default => 'Default Site'
  field :hostname, :type => String

  # -- Relationships --------------------------------------------------------
  references_many :layouts,
    :class_name => 'Jangle::Layout',
    :inverse_of => :site,
    :dependent => :destroy
  references_many :pages,
    :class_name => 'Jangle::Page',
    :inverse_of => :site,
    :dependent => :destroy
  references_many :templates,
    :class_name => 'Jangle::Template',
    :inverse_of => :site,
    :dependent => :destroy
  references_many :widgets,
    :class_name => 'Jangle::Widget',
    :inverse_of => :site,
    :dependent => :destroy
  references_many :snippets,
    :class_name => 'Jangle::Snippet',
    :inverse_of => :site,
    :dependent => :destroy
  references_many :uploads,
    :class_name => 'Jangle::Upload',
    :inverse_of => :site,
    :dependent => :destroy

  # -- Validations ----------------------------------------------------------
  validates :label,
    :presence   => true,
    :uniqueness => true
  validates :hostname,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with => /^[\w\.\-]+$/ }
end
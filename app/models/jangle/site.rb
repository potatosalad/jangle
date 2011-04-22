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
  references_many :widgets,
    :class_name => 'Jangle::Widget',
    :inverse_of => :site,
    :dependent => :destroy
  references_many :assets,
    :class_name => 'Jangle::Asset',
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
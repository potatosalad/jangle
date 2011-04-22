class Jangle::Page
  include Jangle::Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Tree

  include Models::Jangle::Extensions::Parse
  include Models::Jangle::Extensions::Render

  # -- Fields ---------------------------------------------------------------
  field :label,        :type => String
  slug  :label
  field :full_path,    :type => String
  field :content,      :type => String
  field :position,     :type => Integer, :default => 0
  field :published,    :type => Boolean, :default => false

  # -- Relationships --------------------------------------------------------
  referenced_in :site,
    :class_name => 'Jangle::Site',
    :inverse_of => :pages
  referenced_in :layout,
    :class_name => 'Jangle::Layout',
    :inverse_of => :pages
  referenced_in :target_page,
    :class_name => 'Jangle::Page'
  embeds_many :blocks,
    :class_name => 'Jangle::Block',
    :as         => :container
  accepts_nested_attributes_for :blocks
end
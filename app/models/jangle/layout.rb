class Jangle::Layout
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :label, :type => String
  field :description, :type => String
  field :content, :type => String
  field :application_layout, :type => String

  referenced_in :site, :class_name => 'Jangle::Site'

  slug :label
end
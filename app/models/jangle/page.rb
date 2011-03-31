class Jangle::Page
  include Mongoid::Document
  include Mongoid::Kraken
  include Mongoid::Kraken::Autoload
  include Mongoid::Tree
  #include Mongoid::Tree::Ordering
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :label, :type => String
  field :description, :type => String
  field :full_path, :type => String

  referenced_in :site,   :class_name => 'Jangle::Site'
  referenced_in :layout, :class_name => 'Jangle::Layout'

  slug :label
end
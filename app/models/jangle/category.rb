class Jangle::Category
  include Mongoid::Document
  include Mongoid::Tree
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :label, :type => String
  field :description, :type => String

  slug :label
end
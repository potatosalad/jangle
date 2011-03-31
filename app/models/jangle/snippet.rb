class Jangle::Snippet
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :label, :type => String
  field :description, :type => String
  field :content, :type => String

  slug :label
end
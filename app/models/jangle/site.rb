class Jangle::Site
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label,    :type => String
  field :hostname, :type => String

  references_many :pages, :class_name => 'Jangle::Page'
end
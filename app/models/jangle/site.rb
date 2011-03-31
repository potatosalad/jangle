class Jangle::Site
  include Mongoid::Document

  field :label,    :type => String
  field :hostname, :type => String

  references_many :pages, :class_name => 'Jangle::Page'
end
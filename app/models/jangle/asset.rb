class Jangle::Asset
  include Mongoid::Document
  include Mongoid::Timestamps

  # -- Fields ---------------------------------------------------------------
  field :name,         :type => String
  field :content_type, :type => String
  field :width,        :type => Integer
  field :height,       :type => Integer
  field :size,         :type => Integer
  field :position,     :type => Integer, :default => 0
  mount_uploader :source, Jangle::AssetUploader

  # -- Relationships --------------------------------------------------------
  referenced_in :site,
    :class_name => 'Jangle::Site',
    :inverse_of => :assets

  # -- Validations ----------------------------------------------------------
  validates_presence_of :name, :source

  # -- Instance Methods -----------------------------------------------------
  %w{image stylesheet javascript pdf media}.each do |type|
    define_method("#{type}?") do
      self.content_type.to_s == type
    end
  end

  def extname
    return nil unless self.source?
    File.extname(self.source_filename).gsub(/^\./, '')
  end

end
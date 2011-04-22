# encoding: utf-8

class AssetUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "sites/#{model.site_id}/#{model.class.to_s.pluralize.underscore}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  #version :thumb, :if => :image? do
  #  process :resize_to_fill => [50, 50]
  #  process :convert => 'png'
  #end

  #version :medium, :if => :image? do
  #  process :resize_to_fill => [80, 80]
  #  process :convert => 'png'
  #end

  #version :preview, :if => :image? do
  #  process :resize_to_fit => [880, 1100]
  #  process :convert => 'png'
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end

  process :set_content_type
  process :set_size
  process :set_width_and_height

  def set_content_type(*args)
    value = :other

    content_type = file.content_type == 'application/octet-stream' ? File.mime_type?(original_filename) : file.content_type

    self.class.content_types.each_pair do |type, rules|
      rules.each do |rule|
        case rule
        when String then value = type if content_type == rule
        when Regexp then value = type if (content_type =~ rule) == 0
        end
      end
    end

    model.content_type = value
  end

  def set_size(*args)
    model.size = file.size
  end

  def set_width_and_height
    if model.image?
      magick = ::MiniMagick::Image.new(current_path)
      model.width, model.height = magick[:width], magick[:height]
    end
  end

  def image?
    model.image?
  end

  def self.content_types
    {
      :image      => ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg', 'image/x-icon'],
      :media      => [/^video/, 'application/x-shockwave-flash', 'application/x-swf', /^audio/, 'application/ogg', 'application/x-mp3'],
      :pdf        => ['application/pdf', 'application/x-pdf'],
      :stylesheet => ['text/css'],
      :javascript => ['text/javascript', 'text/js', 'application/x-javascript', 'application/javascript'],
      :font       => ['application/x-font-ttf', 'application/vnd.ms-fontobject', 'image/svg+xml', 'application/x-woff']
    }
  end

end

module Models
  module Jangle
    module Extensions
      module Redirect

        extend ActiveSupport::Concern

        included do

          field :redirect, :type => Boolean, :default => false

          field :redirect_url, :type => String

          validates_presence_of :redirect_url, :if => :redirect

          validates_format_of   :redirect_url, :with => ::Jangle::Regexps::URL, :allow_blank => true

        end

      end
    end
  end
end
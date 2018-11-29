# encoding: utf-8

module SocialMediable
  extend ActiveSupport::Concern

  module ClassMethods
    SOCIAL_MEDIA = [:facebook, :instagram].freeze

    def social_media?(type)
      type && SOCIAL_MEDIA.index(type.to_sym).present?
    end

    def find_or_create_by(data, type)
      return nil unless social_media?(type)
      attribute_name = "#{type}_id"
      id = data[attribute_name]
      user = User.find_by(attribute_name.to_s => id)
      user.blank? && User.create!(data)
    end
  end
end

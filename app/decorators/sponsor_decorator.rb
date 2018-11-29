class SponsorDecorator < Draper::Decorator
  delegate_all

  def picture_version_size(version, size)
    h.image_tag(picture.url(version), height: size) if picture
  end
end

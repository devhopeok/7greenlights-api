class ArenaDecorator < Draper::Decorator
  delegate_all

  def image_version_size(version, size)
    h.image_tag(image.url(version), height: size) if image
  end
end

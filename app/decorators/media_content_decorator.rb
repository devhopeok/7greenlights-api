class MediaContentDecorator < Draper::Decorator
  delegate_all

  def links_to_s
    return unless links.present?
    links_s = links.map do |link|
      "<div>#{link['type'].try(:titleize)} - #{link['url']}</div>"
    end.join

    h.raw links_s
  end
end

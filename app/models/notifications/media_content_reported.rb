# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  event_entity_id   :integer
#  event_entity_type :string
#  sender_id         :integer
#  receiver_id       :integer
#  type              :string
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_notifications_on_event_entity_type_and_event_entity_id  (event_entity_type,event_entity_id)
#  index_notifications_on_receiver_id                            (receiver_id)
#  index_notifications_on_sender_id                              (sender_id)
#

module Notifications
  class MediaContentReported < Notifications::Notification
    def data
      super.merge(
        event_entity_url: event_entity.media_url,
        event_entity_name: event_entity.name,
        event_entity_thumbnail: event_entity.image.url(:thumbnail)
      )
    end
  end
end

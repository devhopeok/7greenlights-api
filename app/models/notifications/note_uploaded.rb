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
  class NoteUploaded < Notifications::Notification
    def data
      media_content = event_entity.media_content
      super.merge(
        event_entity_thumbnail: event_entity.image.url(:small),
        event_entity_name: media_content.name,
        media_content_id: media_content.id
      )
    end
  end
end

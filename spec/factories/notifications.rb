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

FactoryGirl.define do
  factory :notification, :class => Notifications::Notification do
    association :sender, factory: :user
    association :receiver, factory: :user
    association :event_entity, factory: :note

    factory :note_uploaded, :class => Notifications::NoteUploaded do
      association :event_entity, factory: :note
    end

    factory :media_content_greenlit, :class => Notifications::MediaContentGreenlit do
      association :event_entity, factory: :media_content
    end

    factory :note_featured, :class => Notifications::NoteFeatured do
      association :event_entity, factory: :note
    end

    factory :user_greenlit, :class => Notifications::UserGreenlit do
      association :event_entity, factory: :user
    end

    factory :note_greenlit, :class => Notifications::NoteGreenlit do
      association :event_entity, factory: :note
    end
  end
end

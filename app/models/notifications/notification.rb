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
  class Notification < ActiveRecord::Base
    belongs_to :event_entity, polymorphic: true
    belongs_to :sender, class_name: User
    belongs_to :receiver, class_name: User

    validates :event_entity, :sender, :receiver, presence: true
    validate :same_sender_receiver, on: :create
    after_create :pusher_notify

    protected

    def data
      {
        id: id,
        sender_id: sender_id,
        sender_username: sender.username,
        sender_thumbnail: sender.picture.url(:small),
        event_entity_id: event_entity_id,
        event_entity_type: event_entity_type,
        receiver_id: receiver_id,
        notification_type: self.class.name.demodulize,
        created_at: created_at
      }
    end

    private

    def same_sender_receiver
      errors.add(:to_myself, 'cannot notify to yourself') if sender_id == receiver_id
    end

    def pusher_notify
      PusherClient.trigger(receiver.channel, 'notifications', data) if receiver.present?
    end
    handle_asynchronously :pusher_notify
  end
end

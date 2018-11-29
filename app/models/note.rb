# == Schema Information
#
# Table name: notes
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  media_content_id  :integer
#  image             :string
#  created_at        :datetime
#  updated_at        :datetime
#  order             :integer          default(0)
#  is_feature        :boolean          default(FALSE)
#  greenlights_count :integer
#
# Indexes
#
#  index_notes_on_is_feature        (is_feature)
#  index_notes_on_media_content_id  (media_content_id)
#  index_notes_on_order             (order)
#  index_notes_on_user_id           (user_id)
#

class Note < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :media_content
  has_many :greenlights,
           as: :greenlighteable,
           dependent: :destroy
  has_many :notifications,
           class_name: Notifications::Notification,
           foreign_key: :event_entity_id,
           dependent: :destroy
  scope :featured,     -> { where is_feature: true  }
  scope :non_featured, -> { where is_feature: false }

  after_create :notify_uploaded
  after_update :notify_featured, if: :is_feature?

  private

  def notify_uploaded
    Notifications::NoteUploaded.create(
      event_entity: self,
      sender: user,
      receiver: media_content.user
    )
  end

  def notify_featured
    Notifications::NoteFeatured.create(
      event_entity: self,
      sender: media_content.user,
      receiver: user
    )
  end
end

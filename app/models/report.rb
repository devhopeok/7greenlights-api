# == Schema Information
#
# Table name: reports
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  media_content_id :integer
#  message          :text
#  solved           :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_reports_on_media_content_id  (media_content_id)
#  index_reports_on_user_id           (user_id)
#

class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :media_content

  validates :user, :media_content, presence: true

  after_create :notify_report

  private

  def notify_report
    Notifications::MediaContentReported.create(
      event_entity: media_content,
      sender: user,
      receiver: media_content.user
    )
  end
end

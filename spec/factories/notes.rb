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

FactoryGirl.define do
  factory :note do
    user
    media_content
    is_feature { false }
  end
end

# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  arena_id         :integer
#  media_content_id :integer
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_posts_on_arena_id          (arena_id)
#  index_posts_on_media_content_id  (media_content_id)
#  index_posts_on_user_id           (user_id)
#



FactoryGirl.define do
  factory :post do
    user
    arena
    media_content

    factory :post_with_media_content do
      association :media_content, factory: :media_content_with_greenlights
    end
  end
end

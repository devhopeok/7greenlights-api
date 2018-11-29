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

class Post < ActiveRecord::Base
  belongs_to :media_content
  belongs_to :arena
  belongs_to :user

  validates :media_content_id, uniqueness: { scope: :arena_id, message: 'Media content already posted here.' }

  def self.create_batch!(params)
    source = params[:arenas_ids] || params[:media_contents_ids]
    post_params = []
    source.each do |id|
      post_params << create_params(params, id)
    end
    Post.create(post_params)
  end

  def self.create_params(params, id)
    user_id = params[:user_id]
    if params[:arenas_ids]
      {
        user_id: user_id, arena_id: id,
        media_content_id: params[:media_content_id]
      }
    elsif params[:media_contents_ids]
      {
        user_id: user_id, arena_id: params[:arena_id],
        media_content_id: id
      }
    end
  end
end

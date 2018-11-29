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



require 'spec_helper'

describe Post, type: :model  do

  describe 'Associations' do
    it { is_expected.to belong_to(:media_content) }
    it { is_expected.to belong_to(:arena) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'Validation' do
    it do
      should validate_uniqueness_of(:media_content_id).scoped_to(:arena_id)
        .with_message('Media content already posted here.')
    end

  end

  describe 'self.create_batch' do

    context 'a media to several arenas' do
      let(:arenas_count) { 4 }
      let!(:arenas) { create_list :arena, arenas_count }
      let!(:user) { create :user }
      let!(:media_content) { create :media_content, user: user }
      let(:arenas_ids) { arenas.map { |a| a.id } }
      let(:attrs) do
        {
          user_id: user.id,
          media_content_id: media_content.id,
          arenas_ids: arenas_ids
        }
      end
      it do
        Post.create_batch!(attrs)
        posts = Post.all
        expect(posts.pluck(:arena_id)).to match_array(arenas_ids)
        expect(posts.pluck(:user_id).uniq).to eq([user.id])
        expect(posts.pluck(:media_content_id).uniq).to eq([media_content.id])
        expect(Post.count).to eq(arenas_count)
      end
    end

    context 'several medias to an arena' do
      let(:media_content_count) { 4 }
      let!(:arena) { create :arena }
      let!(:user) { create :user }
      let!(:media_contents) { create_list :media_content, media_content_count, user: user }
      let(:media_contents_ids) { media_contents.map { |m| m.id } }
      let(:attrs) do
        {
          user_id: user.id,
          media_contents_ids: media_contents_ids,
          arena_id: arena.id
        }
      end

      it do
        Post.create_batch!(attrs)
        posts = Post.all
        expect(posts.pluck(:arena_id).uniq).to eq([arena.id])
        expect(posts.pluck(:user_id).uniq).to eq([user.id])
        expect(posts.pluck(:media_content_id)).to match_array(media_contents_ids)
        expect(Post.count).to eq(media_content_count)
      end
    end
  end
end

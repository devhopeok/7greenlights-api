# == Schema Information
#
# Table name: media_contents
#
#  id                :integer          not null, primary key
#  name              :string
#  media_url         :string
#  links             :json
#  is_hidden         :boolean          default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#  user_id           :integer
#  greenlights_count :integer          default(0)
#  username          :string
#  content_type      :integer          default(0)
#  image             :string
#
# Indexes
#
#  index_media_contents_on_content_type  (content_type)
#  index_media_contents_on_is_hidden     (is_hidden)
#  index_media_contents_on_user_id       (user_id)
#  index_media_contents_on_username      (username)
#

require 'spec_helper'

describe MediaContent, type: :model  do
  describe 'self.filtered' do

    let(:filter_types) do
      {
        by_arena: 0,
        by_content_type: 1,
        by_population: 2,
      }
    end

    let(:population_types) do
      {
        by_friends: 0,
        by_following_users: 1,
        by_follower_users: 2,
        by_strangers: 3
      }
    end

    let(:content_types) do
      {
        other: 0,
        audio: 1,
        video: 2
      }
    end

    let(:posts_count)         { 2 }
    let(:media_content_count) { 3 }
    let!(:arena_a)            { create :arena }
    let!(:arena_b)            { create :arena }
    let!(:media_contents)     { create_list :media_content, media_content_count }
    let!(:audio_content)      { create :media_content, content_type: content_types[:audio] }
    let!(:video_content)      { create :media_content, content_type: content_types[:video] }
    let!(:other_content)      { create :media_content, content_type: content_types[:other] }
    let!(:posts_a)            { create_list :post, posts_count, arena: arena_a }
    let!(:posts_b)            { create_list :post, posts_count, arena: arena_b }
    let!(:user)               { create :user }
    let!(:user_b)             { create :user }
    let!(:user_c)             { create :user }
    let!(:user_d)             { create :user }

    let!(:media_content_a) { create :media_content, user: user_b }

    def is_posted_on_arena?(media_content, arena)
      media_content.posts.any? { |post| post.arena.id == arena.id }
    end

    context 'by arena' do
      it do
        medias = MediaContent.filtered(filter_types: [filter_types[:by_arena]],
                                       arenas_ids: [arena_a.id])
        expect(medias.all? { |m| is_posted_on_arena?(m, arena_a)}).to eq(true)
      end
    end

    context 'by content type' do
      context 'by audio' do
        it do
          medias = MediaContent.filtered(filter_types: [filter_types[:by_content_type]],
                                         content_types: [content_types[:audio]])
          expect(medias.all? { |m| m.audio?}).to eq(true)
        end
      end

      context 'by other' do
        it do
          medias = MediaContent.filtered(filter_types: [filter_types[:by_content_type]],
                                         content_types: [content_types[:video]])
          expect(medias.all? { |m| m.video?}).to eq(true)
        end
      end

      context 'by video' do
        it do
          medias = MediaContent.filtered(filter_types: [filter_types[:by_content_type]],
                                         content_types: [content_types[:other]])
          expect(medias.all? { |m| m.other?}).to eq(true)
        end
      end
    end

    context 'by greenlight population' do
      context 'pop A' do
        it do
          user.toggle_greenlight(user_b)
          user_b.toggle_greenlight(user)
          medias = MediaContent.filtered(filter_types: [filter_types[:by_population]],
                                         user: user,
                                         population_types: [population_types[:by_friends]])
          expect(medias.all? { |m| m.user.id == user_b.id}).to eq(true)
        end
      end

      context 'pop B' do
        it do
          user.toggle_greenlight(user_b)
          medias = MediaContent.filtered(filter_types: [filter_types[:by_population]],
                                         user: user,
                                         population_types: [population_types[:by_following_users]])
          expect(medias.all? { |m| m.user.id == user_b.id}).to eq(true)
        end
      end

      context 'pop C' do
        it do
          user_b.toggle_greenlight(user)
          medias = MediaContent.filtered(filter_types: [filter_types[:by_population]],
                                         user: user,
                                         population_types: [population_types[:by_follower_users]])
          expect(medias.all? { |m| m.user.id == user_b.id}).to eq(true)
        end
      end

      context 'pop D' do
        it do
          user.toggle_greenlight(user_c)
          user_b.toggle_greenlight(user)
          user.toggle_greenlight(user_d)
          user_d.toggle_greenlight(user)
          medias = MediaContent.filtered(filter_types: [filter_types[:by_population]],
                                         user: user,
                                         population_types: [population_types[:by_strangers]])
          expect(medias.any? { |m| m.user.id == user_b.id}).to eq(false)
        end
      end
    end
  end

  describe 'self.sorted' do
    let(:sort_type) do
      {
        creator: 0,
        total_greenlight: 1,
        alphabetically: 2,
        added_date: 3
      }
    end

    let(:sorting_attribute) do
      {
        0 => :username,
        1 => :greenlights_count,
        2 => :name,
        3 => :created_at
      }
    end

    let(:order_type) do
      {
        ascending: 0,
        descending: 1
      }
    end

    def test_ascending(arr, attribute)
      expect(arr.first.send(attribute)).to be < arr.second.send(attribute)
    end

    def test_descending(arr, attribute)
      expect(arr.first.send(attribute)).to be > arr.second.send(attribute)
    end

    describe 'by alphabetically' do
      let!(:media_1) { create :media_content, name: 'a' }
      let!(:media_2) { create :media_content, name: 'b' }

      context 'Ascendant' do
        it do
          sort = sort_type[:alphabetically]
          medias = MediaContent.sorted(sort_type: sort,
                                       order_type: order_type[:ascending])
          test_ascending(medias, sorting_attribute[sort])
        end
      end

      context 'Descendant' do
        it do
          sort = sort_type[:alphabetically]
          medias = MediaContent.sorted(sort_type: sort,
                                       order_type: order_type[:descending])
          test_descending(medias, sorting_attribute[sort])
        end
      end
    end

    describe 'by creator' do
      let!(:media_1) { create :media_content, username: 'a' }
      let!(:media_2) { create :media_content, username: 'b' }


      context 'Ascendant' do
        it do
          sort = sort_type[:creator]
          medias = MediaContent.sorted(sort_type: sort,
                                       order_type: order_type[:ascending])
          test_ascending(medias, sorting_attribute[sort])
        end
      end

      context 'Descendant' do
        it do
          sort = sort_type[:creator]
          medias = MediaContent.sorted(sort_type: sort,
                                       order_type: order_type[:descending])
          test_descending(medias, sorting_attribute[sort])
        end
      end
    end

    describe 'total greenlights' do
      let!(:media_1) { create :media_content, greenlights_count: 1 }
      let!(:media_2) { create :media_content, greenlights_count: 2 }
      context 'least' do
        it do
          sort = sort_type[:total_greenlight]
          medias = MediaContent.sorted(sort_type: sort,
                                       order_type: order_type[:ascending])
          test_ascending(medias, sorting_attribute[sort])
        end
      end

      context 'most' do
        it do
          sort = sort_type[:total_greenlight]
          medias = MediaContent.sorted(sort_type: sort,
                                       order_type: order_type[:descending])
          test_descending(medias, sorting_attribute[sort])
        end
      end
    end

    describe 'added_date' do
      let!(:user) { create :user }

      let!(:media_1) { create :media_content }
      let!(:media_2) { create :media_content }
      let!(:arena)   { create :arena }
      let!(:post_1)  { create :post, arena: arena, media_content: media_1 }
      let!(:post_2)  { create :post, arena: arena, media_content: media_2 }

      before :each do
        user.toggle_greenlight(media_1)
        user.toggle_greenlight(media_2)
      end

      context 'to_stream' do
        context 'oldest' do
          it do
            sort = sort_type[:added_date]
            medias = user.stream_items.sorted(sort_type: sort,
                                              order_type: order_type[:ascending],
                                              context: 'stream')
            expect(medias.first.id).to eq(media_1.id)
            expect(medias.second.id).to eq(media_2.id)
          end
        end

        context 'newest' do
          it do
            sort = sort_type[:added_date]

            medias = user.stream_items.sorted(sort_type: sort,
                                              order_type: order_type[:descending],
                                              context: 'stream')
            expect(medias.first.id).to eq(media_2.id)
            expect(medias.second.id).to eq(media_1.id)
          end
        end
      end

      context 'to_media' do
        let!(:arena_1) { create :arena }
        let!(:arena_2) { create :arena, created_at: 1.year.from_now }

        context 'oldest' do
          it do
            sort = sort_type[:added_date]
            medias = MediaContent.sorted(sort_type: sort,
                                         order_type: order_type[:ascending],
                                         context: 'media')
            test_ascending(medias, sorting_attribute[sort])
          end
        end

        context 'newest' do
          it do
            sort = sort_type[:added_date]
            medias = MediaContent.sorted(sort_type: sort,
                                         order_type: order_type[:descending],
                                         context: 'media')
            test_descending(medias, sorting_attribute[sort])
          end
        end
      end

      context 'to_arena' do
        context 'oldest' do
          it do
            sort = sort_type[:added_date]
            medias = arena.media_contents.sorted(sort_type: sort,
                                  order_type: order_type[:ascending],
                                  context: 'arena')
            expect(medias.first.id).to eq(media_1.id)
            expect(medias.second.id).to eq(media_2.id)
          end
        end

        context 'newest' do
          it do
            sort = sort_type[:added_date]
            medias = arena.media_contents.sorted(sort_type: sort,
                                  order_type: order_type[:descending],
                                  context: 'arena')
            expect(medias.first.id).to eq(media_2.id)
            expect(medias.second.id).to eq(media_1.id)
          end
        end
      end
    end
  end

  describe 'self.with_feature_notes' do
    let!(:media)    { create :media_content }
    let!(:featured) { create_list :note, 3, is_feature: true, media_content: media }
    let!(:notes)    { create_list :note, 3, is_feature: false, media_content: media }

    it 'preloaded notes into media_contents' do
      db_medias = MediaContent.with_featured_notes
      media_with_notes = db_medias.select { |r| r.id == media.id }
      media_notes_ids = media_with_notes[0].featured_notes.map(&:id)
      notes_ids = featured.map(&:id)
      expect(media_notes_ids).to match_array(notes_ids)
    end
  end

  describe 'notification' do
    let(:user)   { create :user }
    let(:user_b) { create :user }
    let(:media)  { create :media_content, user: user }
    let!(:note)  { create :note, media_content: media, user: user }

    context 'greenlight' do
      it do
        user_b.toggle_greenlight(media)
        notification = Notifications::MediaContentGreenlit.find_by(
          event_entity: media,
          sender: user_b,
          receiver: user
        )
        expect(notification).not_to be_nil
      end

      context 'when greenlight my own stuff' do
        it 'do not notify to myself' do
          user.toggle_greenlight(media)
          notification = Notifications::MediaContentGreenlit.find_by(
            event_entity: media,
            sender: user,
            receiver: user
          )
          expect(notification).to be_nil
        end
      end
    end
  end
end

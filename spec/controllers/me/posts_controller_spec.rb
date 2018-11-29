# encoding: utf-8

require 'spec_helper'

describe Api::V1::Me::PostsController do
  render_views
  let!(:user) { create :user }
  let(:media_content) { create :media_content, user: user }
  let(:arena1) { create :arena }
  let(:arena2) { create :arena }

  before(:each) { sign_in user }

  describe 'POST Create' do
    it 'returns no content' do
      post :create, arenas_ids: [ arena1.id, arena2.id ], media_content_id: media_content.id, format: :json
      expect(response).to have_http_status(:no_content)
    end

    it 'creates a post for current user' do
      expect {
        post :create, arenas_ids: [ arena1.id, arena2.id ], media_content_id: media_content.id, format: :json
      }.to change {
        user.posts.count
      }.from(0).to(2)
    end

    it 'creates a post for arenas' do
      post :create, arenas_ids: [ arena1.id, arena2.id ], media_content_id: media_content.id, format: :json
      expect(arena1.posts.count).to eq(1)
      expect(arena2.posts.count).to eq(1)
    end

    context 'media content with 3 posts' do
      let!(:posts) { create_list :post, 3, user: user, media_content: media_content }

      skip 'returns error' do
        post :create, arenas_ids: [ arena1.id ], media_content_id: media_content.id, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
